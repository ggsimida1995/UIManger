import SwiftUI
import Combine
#if canImport(UIKit)
import UIKit
#endif

/// Popup 位置枚举
public enum PopupPosition: Hashable {
    case top        // 顶部
    case right      // 右侧
    case bottom     // 底部
    case left       // 左侧
    case center     // 中心
    case absolute(left: CGFloat?, top: CGFloat?, right: CGFloat?, bottom: CGFloat?) // 绝对位置
    
    // 为了满足Hashable协议，需要实现hash方法
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .top: hasher.combine(0)
        case .right: hasher.combine(1)
        case .bottom: hasher.combine(2)
        case .left: hasher.combine(3)
        case .center: hasher.combine(4)
        case .absolute(let left, let top, let right, let bottom):
            hasher.combine(5)
            hasher.combine(left)
            hasher.combine(top)
            hasher.combine(right)
            hasher.combine(bottom)
        }
    }
    
    // 为了满足Equatable协议(Hashable继承自Equatable)，需要实现==
    public static func == (lhs: PopupPosition, rhs: PopupPosition) -> Bool {
        switch (lhs, rhs) {
        case (.top, .top), (.right, .right), (.bottom, .bottom), (.left, .left), (.center, .center):
            return true
        case (.absolute(let lhsLeft, let lhsTop, let lhsRight, let lhsBottom), 
              .absolute(let rhsLeft, let rhsTop, let rhsRight, let rhsBottom)):
            return lhsLeft == rhsLeft && lhsTop == rhsTop && lhsRight == rhsRight && lhsBottom == rhsBottom
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
        case .absolute: return .center  // 对于绝对位置，默认使用中心对齐但实际会被忽略
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
        case .center, .absolute:
            // 使用不对称过渡效果：进入时从大到小，退出时从小到大
            return AnyTransition.asymmetric(
                insertion: .scale(scale: 1.1, anchor: .center).combined(with: .opacity),
                removal: .scale(scale: 1.1, anchor: .center).combined(with: .opacity)
            )
        }
    }
    
    // 获取默认动画
    func getDefaultAnimation(duration: Double = 0.3) -> Animation {
        switch self {
        case .top, .right, .bottom, .left:
            return .linear(duration: duration) // 使用线性动画
        case .center, .absolute:
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

/// Popup 配置类型
public struct PopupConfig {
    // MARK: - 视觉属性
    
    /// 弹窗圆角半径
    public var cornerRadius: CGFloat
    
    /// 是否启用阴影
    public var shadowEnabled: Bool
    
    // MARK: - 标题
    
    /// 标题文本
    public var title: String?
    
    // MARK: - 关闭按钮
    
    /// 关闭按钮位置
    public enum CloseButtonPosition {
        case topLeading, topTrailing, none
    }
    
    /// 关闭按钮样式
    public enum CloseButtonStyle {
        case circular     // 圆形按钮
        case square       // 方形按钮
        case minimal      // 仅图标
    }
    
    /// 是否显示关闭按钮
    public var showCloseButton: Bool
    
    /// 关闭按钮位置
    public var closeButtonPosition: CloseButtonPosition
    
    /// 关闭按钮样式
    public var closeButtonStyle: CloseButtonStyle
    
    // MARK: - 交互行为
    
    /// 点击外部是否关闭弹窗
    public var closeOnTapOutside: Bool
    
    // MARK: - 动画和过渡效果
    
    /// 弹窗显示/隐藏动画
    public var animation: Animation
    
    /// 自定义过渡效果
    public var customTransition: AnyTransition?
    
    // MARK: - 回调
    
    /// 弹窗关闭回调
    public var onClose: (() -> Void)?
    
    // MARK: - 构造方法
    
    /// 初始化方法
    public init(
        // 视觉属性
        cornerRadius: CGFloat = 12,
        shadowEnabled: Bool = true,
        
        // 标题
        title: String? = nil,
        
        // 关闭按钮
        showCloseButton: Bool = false,
        closeButtonPosition: CloseButtonPosition = .topTrailing,
        closeButtonStyle: CloseButtonStyle = .circular,
        
        // 交互行为
        closeOnTapOutside: Bool = true,
        
        // 动画和过渡效果
        animation: Animation = .spring(response: 0.3, dampingFraction: 0.8),
        customTransition: AnyTransition? = nil,
        
        // 回调
        onClose: (() -> Void)? = nil
    ) {
        self.cornerRadius = cornerRadius
        self.shadowEnabled = shadowEnabled
        
        self.title = title
        
        self.showCloseButton = showCloseButton
        self.closeButtonPosition = closeButtonPosition
        self.closeButtonStyle = closeButtonStyle
        
        self.closeOnTapOutside = closeOnTapOutside
        
        self.animation = animation
        self.customTransition = customTransition
        
        self.onClose = onClose
    }
}

// MARK: - 通用Popup数据结构
public struct PopupData: Identifiable {
    /// 唯一标识
    public var id: UUID
    
    /// 弹窗内容
    public var content: AnyView
    
    /// 弹窗位置
    public var position: PopupPosition
    
    /// 弹窗尺寸
    public var size: PopupSize
    
    /// 弹窗配置
    public var config: PopupConfig
    
    // MARK: - 构造方法
    
    /// 标准弹窗，使用随机生成的ID
    public init<Content: View>(
        content: Content,
        position: PopupPosition = .center,
        size: PopupSize = .flexible,
        config: PopupConfig = PopupConfig()
    ) {
        self.id = UUID()
        self.content = AnyView(content)
        self.position = position
        self.size = size
        self.config = config
    }
    
    /// 带自定义ID的初始化方法
    public init<Content: View>(
        id: UUID,
        content: Content,
        position: PopupPosition = .center,
        size: PopupSize = .flexible,
        config: PopupConfig = PopupConfig()
    ) {
        self.id = id
        self.content = AnyView(content)
        self.position = position
        self.size = size
        self.config = config
    }
}

// MARK: - 弹窗模型
public class PopupModel: Identifiable, ObservableObject {
    /// 唯一标识
    public var id: UUID
    
    /// 弹窗内容
    public var content: AnyView
    
    /// 弹窗位置
    public var position: PopupPosition
    
    /// 弹窗宽度
    public var width: CGFloat?
    
    /// 弹窗高度
    public var height: CGFloat?
    
    /// 弹窗配置
    @Published public var config: PopupConfig
    
    /// 退出配置
    @Published public var exitConfig: PopupConfig?
    
    /// 关闭回调
    public var onClose: (() -> Void)?
    
    /// 初始化方法
    public init(
        id: UUID = UUID(),
        content: AnyView,
        position: PopupPosition,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        config: PopupConfig = PopupConfig(),
        exitConfig: PopupConfig? = nil,
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