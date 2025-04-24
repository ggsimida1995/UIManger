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
    ///   - exitConfig: 退出时使用的弹窗配置（如果为nil，则使用config）
    ///   - id: 自定义ID（可选）
    public func show<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        position: PopupPosition = .center,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        config: PopupConfig = PopupConfig(),
        exitConfig: PopupConfig? = nil,
        id: UUID? = nil
    ) {
        // 根据位置和尺寸设置合适的PopupSize
        let size: PopupSize = {
            switch position {
            case .top, .bottom:
                return .fullWidth(height)
            case .left, .right:
                return .fullHeight(width)
            case .center, .absolute:
                if let width = width {
                    // 如果指定了宽度，则使用固定宽度和自适应高度
                    return .fixed(CGSize(width: width, height: CGFloat.nan))
                } else if let height = height {
                    // 如果只指定了高度，则使用自适应宽度和固定高度
                    return .fixed(CGSize(width: CGFloat.nan, height: height))
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
                config: updatedConfig,
                exitConfig: exitConfig
            )
        } else {
            // 使用自动生成的ID
            popup = PopupData(
                content: content(),
                position: position,
                size: size,
                config: updatedConfig,
                exitConfig: exitConfig
            )
        }
        
        // 使用withAnimation包装显示操作，确保动画生效
        withAnimation(updatedConfig.animation) {
            showPopup(popup)
        }
    }
    
    /// 使用绝对位置显示弹窗
    /// - Parameters:
    ///   - content: 弹窗内容视图
    ///   - left: 距离左边缘的距离（如果为nil则水平居中或使用right值）
    ///   - top: 距离顶部边缘的距离（如果为nil则垂直居中或使用bottom值）
    ///   - right: 距离右边缘的距离（如果left和right都为nil则水平居中）
    ///   - bottom: 距离底部边缘的距离（如果top和bottom都为nil则垂直居中）
    ///   - width: 弹窗宽度（nil表示自适应宽度）
    ///   - height: 弹窗高度（nil表示自适应高度）
    ///   - config: 弹窗配置
    ///   - exitConfig: 退出时使用的弹窗配置（如果为nil，则使用config）
    ///   - id: 自定义ID（可选）
    public func showAt<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        left: CGFloat? = nil,
        top: CGFloat? = nil,
        right: CGFloat? = nil,
        bottom: CGFloat? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        config: PopupConfig = PopupConfig(),
        exitConfig: PopupConfig? = nil,
        id: UUID? = nil
    ) {
        // 创建绝对位置
        let position = PopupPosition.absolute(left: left, top: top, right: right, bottom: bottom)
        
        // 调用标准显示方法
        show(
            content: content,
            position: position,
            width: width,
            height: height,
            config: config,
            exitConfig: exitConfig,
            id: id
        )
    }
    
    /// 显示侧边栏弹窗（便捷方法）
    /// - Parameters:
    ///   - side: 侧边栏位置 (.left 或 .right)
    ///   - width: 侧边栏宽度（默认为屏幕宽度的80%）
    ///   - content: 侧边栏内容视图
    ///   - config: 弹窗配置
    ///   - exitConfig: 退出时使用的弹窗配置
    ///   - id: 自定义ID
    public func showSidebar<Content: View>(
        side: PopupPosition,
        width: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content,
        config: PopupConfig = PopupConfig(),
        exitConfig: PopupConfig? = nil,
        id: UUID? = nil
    ) {
        // 确保side是left或right
        guard side == .left || side == .right else {
            print("警告: showSidebar 方法仅支持 .left 或 .right 位置")
            return
        }
        
        // 如果没有指定宽度，则默认为屏幕宽度的80%
        let calculatedWidth: CGFloat? = width ?? {
            #if canImport(UIKit) && !targetEnvironment(macCatalyst)
            return UIScreen.main.bounds.width * 0.8
            #elseif canImport(AppKit)
            return NSScreen.main?.frame.width ?? 800 * 0.8
            #else
            return 800 * 0.8 // 默认宽度
            #endif
        }()
        
        // 创建侧边栏专用动画配置
        var sidebarConfig = config
        if config.customTransition == nil {
            // 为侧边栏设置专门的过渡效果
            sidebarConfig.customTransition = side.getEntryTransition()
        }
        if config.animation == .spring(response: 0.3, dampingFraction: 0.8) {
            // 为侧边栏设置专门的动画
            sidebarConfig.animation = .spring(response: 0.35, dampingFraction: 0.7)
        }
        
        // 调用标准显示方法
        show(
            content: content,
            position: side,
            width: calculatedWidth,
            height: nil,
            config: sidebarConfig,
            exitConfig: exitConfig,
            id: id
        )
    }
    
    /// 显示横幅弹窗（顶部或底部，便捷方法）
    /// - Parameters:
    ///   - position: 横幅位置 (.top 或 .bottom)
    ///   - height: 横幅高度（默认为80）
    ///   - content: 横幅内容视图
    ///   - config: 弹窗配置
    ///   - exitConfig: 退出时使用的弹窗配置
    ///   - autoHide: 是否自动隐藏
    ///   - autoHideDuration: 自动隐藏时间（秒）
    ///   - id: 自定义ID
    public func showBanner<Content: View>(
        position: PopupPosition,
        height: CGFloat = 80,
        @ViewBuilder content: @escaping () -> Content,
        config: PopupConfig = PopupConfig(),
        exitConfig: PopupConfig? = nil,
        autoHide: Bool = false,
        autoHideDuration: TimeInterval = 3.0,
        id: UUID? = nil
    ) {
        // 确保position是top或bottom
        guard position == .top || position == .bottom else {
            print("警告: showBanner 方法仅支持 .top 或 .bottom 位置")
            return
        }
        
        // 生成唯一ID以供自动隐藏使用
        let bannerId = id ?? UUID()
        
        // 显示横幅
        show(
            content: content,
            position: position,
            width: nil,
            height: height,
            config: config,
            exitConfig: exitConfig,
            id: bannerId
        )
        
        // 如果需要自动隐藏，设置定时器
        if autoHide {
            DispatchQueue.main.asyncAfter(deadline: .now() + autoHideDuration) {
                self.closePopup(id: bannerId)
            }
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
                let position = popup.position
                
                // 如果没有自定义退出配置，创建一个与进入动画一致的退出配置
                if popup.exitConfig == nil {
                    let exitConfig = PopupConfig(
                        backgroundColor: popup.config.backgroundColor,
                        cornerRadius: popup.config.cornerRadius,
                        shadowEnabled: popup.config.shadowEnabled,
                        offsetY: popup.config.offsetY,
                        showCloseButton: popup.config.showCloseButton,
                        closeButtonPosition: popup.config.closeButtonPosition,
                        closeButtonStyle: popup.config.closeButtonStyle,
                        closeOnTapOutside: popup.config.closeOnTapOutside,
                        // 使用与位置相关的线性动画
                        animation: position.getDefaultAnimation(),
                        // 使用与位置相关的过渡效果
                        customTransition: position.getEntryTransition(),
                        onClose: popup.config.onClose
                    )
                    self.activePopups[index].exitConfig = exitConfig
                }
                
                // 当存在exitConfig时，把退出配置应用到popup.config
                // 这样PopupViewModifier中可以使用一致的方式应用动画
                if let exitConfig = popup.exitConfig {
                    // 保留一些原始配置但应用动画和过渡效果
                    self.activePopups[index].config.animation = exitConfig.animation
                    self.activePopups[index].config.customTransition = exitConfig.customTransition
                }
                
                // 先发送变更通知以触发SwiftUI视图更新
                self.objectWillChange.send()
                
                // 选择正确的动画
                let animationToUse = popup.exitConfig?.animation ?? position.getDefaultAnimation()
                
                // 使用显式的withAnimation来确保动画被应用
                withAnimation(animationToUse) {
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
    
    /// 更新退出配置
    public func updateExitConfig(id: UUID, config: PopupConfig) {
        DispatchQueue.main.async {
            if let index = self.activePopups.firstIndex(where: { $0.id == id }) {
                self.objectWillChange.send()
                // 更新退出配置
                self.activePopups[index].exitConfig = config
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
