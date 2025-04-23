import SwiftUI
import Combine

/// Popup 位置枚举
public enum PopupPosition: Hashable {
    case top        // 顶部
    case right      // 右侧
    case bottom     // 底部
    case left       // 左侧
    case center     // 中心
    case custom(CGPoint) // 自定义位置，使用相对屏幕的比例坐标 (0-1)
    
    // 为了满足Hashable协议，需要实现hash方法
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .top: hasher.combine(0)
        case .right: hasher.combine(1)
        case .bottom: hasher.combine(2)
        case .left: hasher.combine(3)
        case .center: hasher.combine(4)
        case .custom(let point):
            hasher.combine(5)
            hasher.combine(point.x)
            hasher.combine(point.y)
        }
    }
    
    // 为了满足Equatable协议(Hashable继承自Equatable)，需要实现==
    public static func == (lhs: PopupPosition, rhs: PopupPosition) -> Bool {
        switch (lhs, rhs) {
        case (.top, .top), (.right, .right), (.bottom, .bottom), (.left, .left), (.center, .center):
            return true
        case (.custom(let lhsPoint), .custom(let rhsPoint)):
            return lhsPoint.x == rhsPoint.x && lhsPoint.y == rhsPoint.y
        default:
            return false
        }
    }
    
    func getAlignment() -> Alignment {
        switch self {
        case .top: return .top
        case .right: return .trailing
        case .bottom: return .bottom
        case .left: return .leading
        case .center: return .center
        case .custom: return .center  // 对于自定义位置，默认使用中心对齐但实际会被忽略
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
        case .center, .custom:
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
            return CGSize(width: screenSize.width, height: height ?? CGFloat.nan)
        case .fullHeight(let width):
            let safeHeight = screenSize.height - safeArea.top - safeArea.bottom
            return CGSize(width: width ?? CGFloat.nan, height: safeHeight)
        case .percentage(let width, let height):
            let w = screenSize.width * max(0.1, min(0.95, width))
            let h = height.map { screenSize.height * max(0.1, min(0.95, $0)) } ?? CGFloat.nan
            return CGSize(width: w, height: h)
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
    }
} 