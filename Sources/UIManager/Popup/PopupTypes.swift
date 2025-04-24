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
    
    // 获取默认动画
    func getDefaultAnimation(duration: Double = 0.3) -> Animation {
        switch self {
        case .top, .right, .bottom, .left:
            return .linear(duration: duration) // 使用线性动画
        case .center, .custom:
            return .easeInOut(duration: duration) // 中心和自定义位置使用缓入缓出
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
    
    // 自定义过渡效果（如果为 nil，则使用默认的位置相关过渡效果）
    public var customTransition: AnyTransition? = nil
    
    // 弹窗垂直偏移量（正值向上偏移，负值向下偏移）
    public var offsetY: CGFloat = 0
    
    public enum CloseButtonPosition {
        case topLeading, topTrailing, none
    }
    
    public enum CloseButtonStyle {
        case circular     // 圆形按钮
        case square       // 方形按钮
        case minimal      // 仅图标
        case custom(Color, Color) // 自定义按钮样式 (背景色, 图标色)
        
        // 获取背景颜色
        var backgroundColor: Color {
            switch self {
            case .circular, .square:
                return Color.gray.opacity(0.1)
            case .minimal:
                return Color.clear
            case .custom(_, let iconColor):
                return iconColor.opacity(0.1)
            }
        }
        
        // 获取图标颜色
        var iconColor: Color {
            switch self {
            case .circular, .square, .minimal:
                return Color.gray
            case .custom(let bgColor, _):
                return bgColor
            }
        }
    }
    
    public var closeButtonPosition: CloseButtonPosition = .topTrailing
    public var closeButtonStyle: CloseButtonStyle = .circular
    
    public init(
        backgroundColor: Color = Color(.systemBackground),
        cornerRadius: CGFloat = 12,
        shadowEnabled: Bool = true,
        closeOnTapOutside: Bool = true,
        showCloseButton: Bool = false,
        closeButtonPosition: CloseButtonPosition = .topTrailing,
        closeButtonStyle: CloseButtonStyle = .circular,
        animation: Animation = .spring(response: 0.3, dampingFraction: 0.8),
        customTransition: AnyTransition? = nil,
        offsetY: CGFloat = 0,
        onClose: (() -> Void)? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowEnabled = shadowEnabled
        self.closeOnTapOutside = closeOnTapOutside
        self.showCloseButton = showCloseButton
        self.closeButtonPosition = closeButtonPosition
        self.closeButtonStyle = closeButtonStyle
        self.animation = animation
        self.customTransition = customTransition
        self.offsetY = offsetY
        self.onClose = onClose
    }
}

// MARK: - 通用Popup数据结构
public struct PopupData: Identifiable {
    public var id: UUID
    public var content: AnyView
    public var position: PopupPosition
    public var size: PopupSize
    public var config: PopupBaseConfig
    // 退出时使用的配置，如果为nil则使用普通config
    public var exitConfig: PopupBaseConfig?
    
    // 标准弹窗，使用随机生成的ID
    public init<Content: View>(
        content: Content,
        position: PopupPosition = .center,
        size: PopupSize = .flexible,
        config: PopupBaseConfig = PopupBaseConfig(),
        exitConfig: PopupBaseConfig? = nil
    ) {
        self.id = UUID()
        self.content = AnyView(content)
        self.position = position
        self.size = size
        self.config = config
        self.exitConfig = exitConfig
    }
    
    // 带自定义ID的初始化方法
    public init<Content: View>(
        id: UUID,
        content: Content,
        position: PopupPosition = .center,
        size: PopupSize = .flexible,
        config: PopupBaseConfig = PopupBaseConfig(),
        exitConfig: PopupBaseConfig? = nil
    ) {
        self.id = id
        self.content = AnyView(content)
        self.position = position
        self.size = size
        self.config = config
        self.exitConfig = exitConfig
    }
} 

// 扩展PopupModel，添加退出配置
public class PopupModel: Identifiable, ObservableObject {
    public var id: UUID
    public var content: AnyView
    public var position: PopupPosition
    public var width: CGFloat?
    public var height: CGFloat?
    @Published public var config: PopupBaseConfig
    @Published public var exitConfig: PopupBaseConfig? // 新增退出配置
    public var onClose: (() -> Void)?
    
    public init(
        id: UUID = UUID(),
        content: AnyView,
        position: PopupPosition,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        config: PopupBaseConfig = PopupBaseConfig(),
        exitConfig: PopupBaseConfig? = nil,
        onClose: (() -> Void)? = nil
    ) {
        self.id = id
        self.content = content
        self.position = position
        self.width = width
        self.height = height
        self.config = config
        self.exitConfig = exitConfig
        self.onClose = onClose
    }
} 