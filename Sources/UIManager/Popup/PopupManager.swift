import SwiftUI
import Combine
#if canImport(UIKit)
import UIKit
#endif

/// Popup 管理器 - 全局单例
public class PopupManager: ObservableObject {
    /// 当前显示的 Popup 列表
    @Published fileprivate var activePopups: [PopupData] = []
    
    /// 弹窗数量存储属性
    @Published private var popupCountValue: Int = 0
    
    /// 公开的弹窗数量发布者，用于外部监听
    public var popupCountPublisher: Published<Int>.Publisher {
        $popupCountValue
    }
    
    /// 单例实例
    public static let shared = PopupManager()
    
    private init() {
        // 监听activePopups变化，更新popupCount
        $activePopups
            .map { $0.count }
            .assign(to: &$popupCountValue)
    }
    
    /// 当前活跃的弹窗数量
    public var popupCount: Int { activePopups.count }
    
    /// 获取指定索引的弹窗
    public func popup(at index: Int) -> PopupData? {
        guard index >= 0 && index < activePopups.count else { return nil }
        return activePopups[index]
    }
    
    /// 获取所有活跃弹窗列表（用于 ForEach 遍历）
    public func getActivePopups() -> [PopupData] {
        return activePopups
    }
    
    // MARK: - 核心API
    
    /// 显示弹窗（核心方法）
    public func showPopup(_ popup: PopupData) {
        // 使用主线程确保UI更新同步
        DispatchQueue.main.async {
            // 先发送变更通知以触发SwiftUI视图更新
            self.objectWillChange.send()
            
            // 使用显式的withAnimation来包装弹窗添加操作
            withAnimation(popup.config.animation) {
                self.activePopups.append(popup)
            }
        }
    }
    
    /// 显示视图弹窗（统一方法）
    /// - Parameters:
    ///   - content: 弹窗内容视图
    ///   - position: 弹窗位置（如：.center, .top, .bottom, .left, .right）
    ///   - width: 弹窗宽度（nil表示自适应宽度）
    ///   - height: 弹窗高度（nil表示自适应高度）
    ///   - config: 弹窗配置
    ///   - id: 自定义ID（可选）
    public func show<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        position: PopupPosition = .center,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        config: PopupConfig = PopupConfig(),
        id: UUID? = nil
    ) {
        // 根据位置和尺寸设置合适的PopupSize
        let size: PopupSize = {
            switch position {
            case .top, .bottom:
                // 确保高度是有效值
                let safeHeight = height.map { max(0, $0) } ?? CGFloat.nan
                return .fullWidth(safeHeight)
            case .left, .right:
                // 确保宽度是有效值
                let safeWidth = width.map { max(0, $0) } ?? CGFloat.nan
                return .fullHeight(safeWidth)
            case .center, .absolute:
                if let width = width, let height = height {
                    // 确保宽度和高度都是有效值
                    let safeWidth = max(0, width)
                    let safeHeight = max(0, height)
                    return .fixed(CGSize(width: safeWidth, height: safeHeight))
                } else if let width = width {
                    // 确保宽度是有效值
                    let safeWidth = max(0, width)
                    return .fixed(CGSize(width: safeWidth, height: CGFloat.nan))
                } else if let height = height {
                    // 确保高度是有效值
                    let safeHeight = max(0, height)
                    return .fixed(CGSize(width: CGFloat.nan, height: safeHeight))
                } else {
                    // 如果都没有指定，则完全自适应
                    return .flexible
                }
            }
        }()
        
        // 根据位置设置合适的过渡效果和动画
        var updatedConfig = config
        // 如果没有指定自定义过渡效果，则使用位置相关的默认过渡效果
        if updatedConfig.customTransition == nil {
            updatedConfig.customTransition = position.getEntryTransition()
        }
        // 如果没有指定自定义动画，则使用位置相关的默认动画
        if updatedConfig.animation == .spring(response: 0.3, dampingFraction: 0.8) {
            // 仅当使用默认动画参数时替换
            updatedConfig.animation = position.getDefaultAnimation()
        }
        
        // 创建并显示弹窗
        let popup: PopupData
        
        if let customID = id {
            // 使用自定义ID
            popup = PopupData(
                id: customID,
                content: content(),
                position: position,
                size: size,
                config: updatedConfig
            )
        } else {
            // 使用自动生成的ID
            popup = PopupData(
                content: content(),
                position: position,
                size: size,
                config: updatedConfig
            )
        }
        
        // 使用withAnimation包装显示操作，确保动画生效
        withAnimation(updatedConfig.animation) {
            showPopup(popup)
        }
    }
    
    /// 更新现有弹窗的配置
    public func updatePopup(id: UUID, config: PopupConfig) {
        DispatchQueue.main.async {
            if let index = self.activePopups.firstIndex(where: { $0.id == id }) {
                self.objectWillChange.send()
                // 更新配置
                self.activePopups[index].config = config
            }
        }
    }
    
    // MARK: - 关闭方法
    
    /// 关闭指定 Popup
    public func closePopup(id: UUID) {
        DispatchQueue.main.async {
            if let index = self.activePopups.firstIndex(where: { $0.id == id }) {
                let popup = self.activePopups[index]
                
                // 先发送变更通知以触发SwiftUI视图更新
                self.objectWillChange.send()
                
                // 使用显式的withAnimation来确保动画被应用
                withAnimation(popup.config.animation) {
                    // 从活跃弹窗列表中移除
                    self.activePopups.remove(at: index)
                    
                    // 调用关闭回调
                    popup.config.onClose?()
                }
            }
        }
    }
    
    /// 关闭所有 Popup
    public func closeAllPopups() {
        guard !activePopups.isEmpty else { return }
        
        let popupsCopy = self.activePopups
        
        DispatchQueue.main.async {
            // 发送变更通知
            self.objectWillChange.send()
            
            // 使用动画关闭所有弹窗
            withAnimation {
                // 清空弹窗列表
                self.activePopups.removeAll()
                
                // 在移除所有弹窗后调用onClose回调
                for popup in popupsCopy {
                    popup.config.onClose?()
                }
            }
        }
    }
}

// MARK: - 环境扩展
// 创建一个环境键，用于访问 PopupManager
struct PopupManagerKey: EnvironmentKey {
    static let defaultValue = PopupManager.shared
}

// 扩展 EnvironmentValues，方便在 SwiftUI 环境中访问 PopupManager
public extension EnvironmentValues {
    var popupManager: PopupManager {
        get { self[PopupManagerKey.self] }
        set { self[PopupManagerKey.self] = newValue }
    }
} 
