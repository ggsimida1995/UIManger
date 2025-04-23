import SwiftUI
import Combine

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
    
    // MARK: - 核心API
    
    /// 显示弹窗（核心方法）
    public func showPopup(_ popup: PopupData) {
        // 使用动画添加弹窗
        activePopups.append(popup)
        // 分离动画应用，避免未使用返回值警告
        animateLastPopup(with: .spring(response: 0.35, dampingFraction: 0.7))
    }
    
    /// 为最后添加的弹窗应用动画
    private func animateLastPopup(with animation: Animation) {
        guard !activePopups.isEmpty else { return }
        // 分离动画方法，避免返回值未使用警告
        withAnimation(animation) {}
    }
    
    /// 显示视图弹窗（统一方法）
    /// - Parameters:
    ///   - content: 弹窗内容视图
    ///   - position: 弹窗位置（如：.center, .top, .bottom, .left, .right）
    ///   - width: 弹窗宽度（nil表示自适应宽度）
    ///   - height: 弹窗高度（nil表示自适应高度）
    ///   - config: 弹窗配置（如圆角、阴影等）
    ///   - id: 自定义ID（可选）
    public func show<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        position: PopupPosition = .center,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        config: PopupBaseConfig = PopupBaseConfig(),
        id: UUID? = nil
    ) {
        // 根据位置和尺寸设置合适的PopupSize
        let size: PopupSize = {
            switch position {
            case .top, .bottom:
                return .fullWidth(height)
            case .left, .right:
                return .fullHeight(width)
            case .center, .custom:
                if let width = width, let height = height {
                    return .fixed(CGSize(width: width, height: height))
                } else {
                    return .flexible
                }
            }
        }()
        
        // 创建并显示弹窗
        let popup: PopupData
        
        if let customID = id {
            // 使用自定义ID
            popup = PopupData(
                id: customID,
                content: content(),
                position: position,
                size: size,
                config: config
            )
        } else {
            // 使用自动生成的ID
            popup = PopupData(
                content: content(),
                position: position,
                size: size,
                config: config
            )
        }
        
        showPopup(popup)
    }
    
    /// 更新现有弹窗的配置
    public func updatePopup(id: UUID, config: PopupBaseConfig) {
        DispatchQueue.main.async {
            if let index = self.activePopups.firstIndex(where: { $0.id == id }) {
                // 先更新值
                self.activePopups[index].config = config
                // 再应用动画，避免返回值未使用警告
                withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {}
            }
        }
    }
    
    // MARK: - 关闭方法
    
    /// 关闭指定 Popup
    public func closePopup(id: UUID) {
        DispatchQueue.main.async {
            if let index = self.activePopups.firstIndex(where: { $0.id == id }) {
                let popup = self.activePopups[index]
                
                // 先移除弹窗
                self.activePopups.remove(at: index)
                // 再应用动画，避免返回值未使用警告
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {}
                
                popup.config.onClose?()
            }
        }
    }
    
    /// 关闭所有 Popup
    public func closeAllPopups() {
        let popupsCopy = self.activePopups
        
        // 先清空弹窗列表
        self.activePopups.removeAll()
        // 再应用动画，避免返回值未使用警告
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {}
        
        // 在移除所有弹窗后调用onClose回调
        for popup in popupsCopy {
            popup.config.onClose?()
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