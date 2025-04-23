import SwiftUI
import Combine

// 为withAnimation添加可丢弃结果标记，避免"Result of call to 'withAnimation' is unused"警告
@discardableResult
private func animateChanges<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    return try withAnimation(animation, body)
}

/// Popup 管理器 - 全局单例
public class PopupManager: ObservableObject {
    /// 当前显示的 Popup 列表
    @Published fileprivate var activePopups: [PopupData] = []
    
    /// 公开的弹窗数量发布者，用于外部监听
    public var popupCountPublisher: Published<Int>.Publisher {
        $popupCountValue
    }
    
    /// 弹窗数量存储属性
    @Published private var popupCountValue: Int = 0
    
    /// 单例实例
    public static let shared = PopupManager()
    
    private init() {
        // 监听activePopups变化，更新popupCount
        $activePopups
            .map { $0.count }
            .assign(to: &$popupCountValue)
    }
    
    /// 当前活跃的弹窗数量
    public var popupCount: Int {
        return activePopups.count
    }
    
    /// 获取指定索引的弹窗
    public func popup(at index: Int) -> PopupData? {
        guard index >= 0 && index < activePopups.count else { return nil }
        return activePopups[index]
    }
    
    // MARK: - 核心API
    
    /// 显示弹窗（核心方法）
    public func showPopup(_ popup: PopupData) {
        // 使用适当的动画
        let animation: Animation = .spring(response: 0.35, dampingFraction: 0.7)
        withAnimation(animation) {
            activePopups.append(popup)
        }
    }
    
    /// 显示视图弹窗（便捷方法）
    public func show<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        position: PopupPosition = .center,
        size: PopupSize = .flexible,
        config: PopupBaseConfig = PopupBaseConfig()
    ) {
        let popup = PopupData(
            content: content(),
            position: position,
            size: size,
            config: config
        )
        showPopup(popup)
    }
    
    /// 显示输入框弹窗（便捷方法）
    public func showInput<Content: View>(
        @ViewBuilder content: @escaping (KeyboardHeightObserver) -> Content,
        position: PopupPosition = .center,
        size: PopupSize = .flexible,
        config: PopupBaseConfig = PopupBaseConfig()
    ) {
        let popup = PopupData(
            content: content,
            position: position,
            size: size,
            config: config
        )
        showPopup(popup)
    }
    
    // MARK: - 常用预设
    
    /// 显示底部菜单（便捷方法）
    public func showBottomSheet<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        height: CGFloat? = nil,
        cornerRadius: CGFloat = 12,
        closeOnTapOutside: Bool = true,
        onClose: (() -> Void)? = nil
    ) {
        let config = PopupBaseConfig(
            cornerRadius: cornerRadius,
            closeOnTapOutside: closeOnTapOutside,
            onClose: onClose
        )
        
        show(
            content: content,
            position: .bottom,
            size: .fullWidth(height),
            config: config
        )
    }
    
    /// 显示侧边栏（便捷方法）
    public func showSidebar<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        side: PopupPosition = .right,
        width: CGFloat = UIScreen.main.bounds.width * 0.75,
        closeOnTapOutside: Bool = true,
        onClose: (() -> Void)? = nil
    ) {
        // 只支持左侧和右侧弹出
        switch side {
        case .left, .right:
            let config = PopupBaseConfig(
                cornerRadius: 0,
                closeOnTapOutside: closeOnTapOutside,
                onClose: onClose
            )
            
            show(
                content: content,
                position: side,
                size: .fullHeight(width),
                config: config
            )
        default:
            return
        }
    }
    
    /// 显示标准输入弹窗（便捷方法）
    public func showStandardInput(
        title: String,
        message: String? = nil,
        placeholder: String = "",
        initialText: String = "",
        keyboardType: UIKeyboardType = .default,
        submitLabel: SubmitLabel = .done,
        onCancel: (() -> Void)? = nil,
        onSubmit: @escaping (String) -> Void
    ) {
        showInput { keyboardObserver in
            StandardInputPopupView(
                title: title,
                message: message,
                placeholder: placeholder,
                initialText: initialText,
                keyboardType: keyboardType,
                submitLabel: submitLabel,
                keyboardObserver: keyboardObserver,
                onCancel: {
                    self.closeAllPopups()
                    onCancel?()
                },
                onSubmit: { text in
                    self.closeAllPopups()
                    onSubmit(text)
                }
            )
        }
    }
    
    // MARK: - 关闭方法
    
    /// 关闭指定 Popup
    public func closePopup(id: UUID) {
        // 使用同步锁避免多线程访问冲突
        DispatchQueue.main.async {
            if let index = self.activePopups.firstIndex(where: { $0.id == id }) {
                let popup = self.activePopups[index]
                let animation: Animation = .spring(response: 0.35, dampingFraction: 0.7)
                
                // 如果弹窗支持键盘处理，在关闭前隐藏键盘
                if popup.isKeyboardAdaptive, let keyboardObserver = popup.keyboardObserver {
                    keyboardObserver.hideKeyboard()
                    
                    // 延迟关闭弹窗，让键盘有时间完全收起
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(animation) {
                            if let index = self.activePopups.firstIndex(where: { $0.id == id }) {
                                self.activePopups.remove(at: index)
                            }
                        }
                        popup.config.onClose?()
                    }
                } else {
                    withAnimation(animation) {
                        if let index = self.activePopups.firstIndex(where: { $0.id == id }) {
                            self.activePopups.remove(at: index)
                        }
                    }
                    popup.config.onClose?()
                }
            }
        }
    }
    
    /// 关闭所有 Popup
    public func closeAllPopups() {
        // 先隐藏键盘
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
        
        // 短暂延迟后关闭所有弹窗
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let popupsCopy = self.activePopups
            let animation: Animation = .spring(response: 0.35, dampingFraction: 0.7)
            withAnimation(animation) {
                self.activePopups.removeAll()
            }
            // 在移除所有弹窗后调用onClose回调
            for popup in popupsCopy {
                popup.config.onClose?()
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