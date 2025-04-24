#if DEBUG || PREVIEW
import SwiftUI

// 弹窗演示的动画帮助函数
public extension PreviewPopupDemo {
    // 根据用户选择生成过渡效果，分别为进入和退出创建不同的效果
    func getEntryTransition() -> AnyTransition {
        switch selectedTransitionType {
        case .fade:
            return AnyTransition.opacity
        case .scale:
            switch selectedScaleType {
            case .uniform, .fromCenter:
                // 明确指定使用.center作为缩放锚点，从0开始缩放（完全不可见）到正常大小
                return AnyTransition.scale(scale: 0, anchor: .center).combined(with: .opacity)
            case .fromTop:
                return AnyTransition.scale(scale: 0, anchor: .top).combined(with: .opacity)
            case .fromBottom:
                return AnyTransition.scale(scale: 0, anchor: .bottom).combined(with: .opacity)
            case .fromLeading:
                return AnyTransition.scale(scale: 0, anchor: .leading).combined(with: .opacity)
            case .fromTrailing:
                return AnyTransition.scale(scale: 0, anchor: .trailing).combined(with: .opacity)
            }
        case .slide:
            // 使用move with edge来实现方向控制的滑动效果
            switch selectedDirection {
            case .top:
                return AnyTransition.move(edge: .top).combined(with: .opacity)
            case .bottom:
                return AnyTransition.move(edge: .bottom).combined(with: .opacity)
            case .leading:
                return AnyTransition.move(edge: .leading).combined(with: .opacity)
            case .trailing:
                return AnyTransition.move(edge: .trailing).combined(with: .opacity)
            default:
                // 对于对角线方向，使用默认的滑动效果
                return AnyTransition.slide.combined(with: .opacity)
            }
        case .move:
            return AnyTransition.move(edge: selectedDirection.toEdge()).combined(with: .opacity)
        case .asymmetric:
            // 确保异步过渡效果也使用中心锚点，进入从0到1，退出从1到0
            return AnyTransition.asymmetric(
                insertion: .scale(scale: 0, anchor: .center).combined(with: .opacity),
                removal: .scale(scale: 0, anchor: .center).combined(with: .opacity)
            )
        }
    }
    
    func getExitTransition() -> AnyTransition {
        switch selectedTransitionType {
        case .fade:
            return AnyTransition.opacity
        case .scale:
            // 退出时使用缩放到0的效果（从正常大小缩小到完全不可见）
            return AnyTransition.scale(scale: 0, anchor: .center).combined(with: .opacity)
        case .slide:
            // 使退出方向与进入方向一致，这样体验更自然
            switch selectedDirection {
            case .top:
                return AnyTransition.move(edge: .top).combined(with: .opacity) // 从顶部退出
            case .bottom:
                return AnyTransition.move(edge: .bottom).combined(with: .opacity) // 从底部退出 
            case .leading:
                return AnyTransition.move(edge: .leading).combined(with: .opacity) // 从左侧退出
            case .trailing:
                return AnyTransition.move(edge: .trailing).combined(with: .opacity) // 从右侧退出
            default:
                // 对于对角线方向，使用默认的滑动效果
                return AnyTransition.slide.combined(with: .opacity)
            }
        case .move:
            // 同样使退出方向与进入方向一致
            switch selectedDirection {
            case .top:
                return AnyTransition.move(edge: .top).combined(with: .opacity)
            case .bottom:
                return AnyTransition.move(edge: .bottom).combined(with: .opacity)
            case .leading:
                return AnyTransition.move(edge: .leading).combined(with: .opacity)
            case .trailing:
                return AnyTransition.move(edge: .trailing).combined(with: .opacity)
            default:
                return AnyTransition.move(edge: .bottom).combined(with: .opacity)
            }
        case .asymmetric:
            // 退出时使用放大效果 (从正常大小放大到1.1倍)
            return AnyTransition.scale(scale: 0, anchor: .center).combined(with: .opacity)
        }
    }
} #endif
