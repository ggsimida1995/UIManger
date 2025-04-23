import SwiftUI
import Combine

/// Popup 位置枚举
public enum PopupPosition {
    case top        // 顶部
    case right      // 右侧
    case bottom     // 底部
    case left       // 左侧
    case center     // 中心
    case custom(CGPoint) // 自定义位置
    
    func getAlignment() -> Alignment {
        switch self {
        case .top:
            return .top
        case .right:
            return .trailing
        case .bottom:
            return .bottom
        case .left:
            return .leading
        case .center:
            return .center
        case .custom:
            return .center
        }
    }
    
    // 获取进入动画
    func getEntryTransition() -> AnyTransition {
        switch self {
        case .top:
            return AnyTransition.move(edge: .top).combined(with: .opacity)
        case .right:
            return AnyTransition.move(edge: .trailing).combined(with: .opacity)
        case .bottom:
            return AnyTransition.move(edge: .bottom).combined(with: .opacity)
        case .left:
            return AnyTransition.move(edge: .leading).combined(with: .opacity)
        case .center:
             return AnyTransition.opacity
        case .custom:
            return AnyTransition.opacity
        }
    }
}

/// Popup 尺寸类型
public enum PopupSize {
    case fixed(CGSize)        // 固定尺寸
    case flexible             // 根据内容自适应
    case fullWidth(CGFloat?)  // 全宽，可选高度
    case fullHeight(CGFloat?) // 全高，可选宽度
    case percentage(width: CGFloat, height: CGFloat?) // 屏幕尺寸的百分比
    
    func getSize(screenSize: CGSize, safeArea: EdgeInsets) -> CGSize? {
        switch self {
        case .fixed(let size):
            return size
        case .flexible:
            return nil
        case .fullWidth(let height):
            if let height = height {
                return CGSize(width: screenSize.width, height: height)
            } else {
                return CGSize(width: screenSize.width, height: CGFloat.nan)
            }
        case .fullHeight(let width):
            if let width = width {
                return CGSize(width: width, height: screenSize.height - safeArea.top - safeArea.bottom)
            } else {
                return CGSize(width: CGFloat.nan, height: screenSize.height - safeArea.top - safeArea.bottom)
            }
        case .percentage(let width, let height):
            let w = screenSize.width * max(0.1, min(0.95, width))
            if let h = height {
                let h = screenSize.height * max(0.1, min(0.95, h))
                return CGSize(width: w, height: h)
            } else {
                return CGSize(width: w, height: CGFloat.nan)
            }
        }
    }
}

// MARK: - 基础Popup配置
public struct PopupBaseConfig {
    public var backgroundColor: Color = Color(.systemBackground)
    public var cornerRadius: CGFloat = 12
    public var shadowEnabled: Bool = true
    public var closeOnTapOutside: Bool = true
    public var showCloseButton: Bool = false
    public var animation: Animation = .spring(response: 0.3, dampingFraction: 0.8)
    public var onClose: (() -> Void)?
    
    public enum CloseButtonPosition {
        case topLeading, topTrailing, none
    }
    
    public var closeButtonPosition: CloseButtonPosition = .topTrailing
    
    public init(
        backgroundColor: Color = Color(.systemBackground),
        cornerRadius: CGFloat = 12,
        shadowEnabled: Bool = true,
        closeOnTapOutside: Bool = true,
        showCloseButton: Bool = false,
        closeButtonPosition: CloseButtonPosition = .topTrailing,
        animation: Animation = .spring(response: 0.3, dampingFraction: 0.8),
        onClose: (() -> Void)? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowEnabled = shadowEnabled
        self.closeOnTapOutside = closeOnTapOutside
        self.showCloseButton = showCloseButton
        self.closeButtonPosition = closeButtonPosition
        self.animation = animation
        self.onClose = onClose
    }
}

// MARK: - 通用Popup数据结构
public struct PopupData: Identifiable {
    public let id = UUID()
    public var content: AnyView
    public var position: PopupPosition
    public var size: PopupSize
    public var config: PopupBaseConfig
    public var keyboardObserver: KeyboardHeightObserver?
    
    // 标准弹窗
    public init<Content: View>(
        content: Content,
        position: PopupPosition = .center,
        size: PopupSize = .flexible,
        config: PopupBaseConfig = PopupBaseConfig()
    ) {
        self.content = AnyView(content)
        self.position = position
        self.size = size
        self.config = config
        self.keyboardObserver = nil
    }
    
    // 输入弹窗
    public init<Content: View>(
        content: @escaping (KeyboardHeightObserver) -> Content,
        position: PopupPosition = .center,
        size: PopupSize = .flexible,
        config: PopupBaseConfig = PopupBaseConfig()
    ) {
        let observer = KeyboardHeightObserver()
        self.keyboardObserver = observer
        self.position = position
        self.size = size
        self.config = config
        
        // 创建包装视图
        let wrappedContent = KeyboardAdaptiveView(keyboardObserver: observer) {
            content(observer)
        }
        self.content = AnyView(wrappedContent)
    }
    
    // 判断是否为键盘适配型弹窗
    var isKeyboardAdaptive: Bool {
        return keyboardObserver != nil
    }
} 