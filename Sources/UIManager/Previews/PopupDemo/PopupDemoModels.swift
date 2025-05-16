#if DEBUG || PREVIEW
import SwiftUI
//import UIManager

// 弹窗演示模型和枚举
public extension PreviewPopupDemo {
    // 使用自定义类型来区分不同的位置选项，而不是直接使用PopupPosition
    enum PositionOption: String, CaseIterable, Identifiable {
        case center, top, bottom, left, right
        public var id: String { self.rawValue }
    }
    
    // 添加动画类型枚举
    enum AnimationType: String, CaseIterable, Identifiable {
        case spring = "弹簧"
        case easeInOut = "缓入缓出"
        case easeIn = "缓入"
        case easeOut = "缓出"
        case linear = "线性"
        
        public var id: String { self.rawValue }
        
        // 添加描述文本，解释动画类型特点
        var description: String {
            switch self {
            case .spring: 
                return "带有回弹效果的自然动画，适合大多数场景"
            case .easeInOut: 
                return "开始和结束慢，中间快，最平滑的动画效果"
            case .easeIn: 
                return "开始慢逐渐加速，适合退出场景"
            case .easeOut: 
                return "开始快逐渐减速，适合进入场景"
            case .linear: 
                return "匀速动画，速度恒定，适合匀速旋转等效果"
            }
        }
        
        // 转换为SwiftUI动画，优化弹簧动画参数以减少抖动
        func toAnimation(duration: Double = 0.3) -> Animation {
            switch self {
            case .spring:
                // 增加阻尼比，减少回弹过度
                return .spring(response: duration, dampingFraction: 0.85, blendDuration: 0.3)
            case .easeInOut:
                return .easeInOut(duration: duration)
            case .easeIn:
                return .easeIn(duration: duration)
            case .easeOut:
                return .easeOut(duration: duration)
            case .linear:
                return .linear(duration: duration)
            }
        }
    }
    
    // 替换原来的过渡效果枚举为更复杂的版本
    enum TransitionType: String, CaseIterable, Identifiable {
        case fade = "淡入淡出"
        case scale = "缩放"
        case slide = "滑动"
        case move = "移动"
        case asymmetric = "不对称"
        
        public var id: String { self.rawValue }
        
        // 添加描述文本，解释每种动画效果
        var description: String {
            switch self {
            case .fade:
                return "弹窗逐渐显示或消失，适合需要温和过渡的场景"
            case .scale:
                return "弹窗从零大小逐渐缩放到正常大小，退出时从正常大小缩小到零，实现完美的缩放效果"
            case .slide:
                return "弹窗从屏幕边缘滑入滑出，适合抽屉式弹窗和提示框"
            case .move:
                return "弹窗从指定方向移入移出，适合需要明确方向感的场景"
            case .asymmetric:
                return "进入时从零大小缩放到正常大小并淡入，退出时从正常大小缩小到零并淡出，实现完美的缩放效果"
            }
        }
    }
    
    // 添加动画方向枚举
    enum AnimationDirection: String, CaseIterable, Identifiable {
        case top = "顶部"
        case bottom = "底部"
        case leading = "左侧"
        case trailing = "右侧"
        case topLeading = "左上"
        case topTrailing = "右上"
        case bottomLeading = "左下"
        case bottomTrailing = "右下" 
        
        public var id: String { self.rawValue }
        
        // 转换为 Edge 值
        func toEdge() -> Edge {
            switch self {
            case .top: return .top
            case .bottom: return .bottom
            case .leading: return .leading
            case .trailing: return .trailing
            default: return .top // 对角线方向使用默认值
            }
        }
        
        // 添加描述文本，解释方向的影响
        var description: String {
            switch self {
            case .top: return "弹窗从顶部出现/消失"
            case .bottom: return "弹窗从底部出现/消失，适合贴近底部操作区的弹窗"
            case .leading: return "弹窗从左侧出现/消失，适合侧边菜单"
            case .trailing: return "弹窗从右侧出现/消失，适合辅助信息面板"
            case .topLeading: return "弹窗从左上方出现/消失"
            case .topTrailing: return "弹窗从右上方出现/消失"
            case .bottomLeading: return "弹窗从左下方出现/消失"
            case .bottomTrailing: return "弹窗从右下方出现/消失"
            }
        }
    }
    
    // 添加缩放类型枚举
    enum ScaleType: String, CaseIterable, Identifiable {
        case uniform = "均匀"
        case fromTop = "从顶部"
        case fromBottom = "从底部"
        case fromLeading = "从左侧"
        case fromTrailing = "从右侧"
        case fromCenter = "从中心"
        
        public var id: String { self.rawValue }
        
        // 添加描述文本，解释缩放方式的区别
        var description: String {
            switch self {
            case .uniform: return "从中心点均匀缩放，从零大小到正常大小"
            case .fromTop: return "从顶部开始缩放，从零大小向下扩展"
            case .fromBottom: return "从底部开始缩放，从零大小向上扩展"
            case .fromLeading: return "从左侧开始缩放，从零大小向右扩展"
            case .fromTrailing: return "从右侧开始缩放，从零大小向左扩展"
            case .fromCenter: return "从中心点开始缩放，从零大小向四周扩展"
            }
        }
    }
    
    // 添加动画效果枚举
    enum TransitionEffect: String, CaseIterable, Identifiable {
        case fade = "淡入淡出"
        case scale = "缩放"
        case slide = "滑动"
        case move = "移动"
        case asymmetric = "不对称"
        
        public var id: String { self.rawValue }
        
        // 转换为SwiftUI过渡效果，修复缩放抖动问题
        func toTransition(position: PositionOption) -> AnyTransition {
            switch self {
            case .fade:
                return AnyTransition.opacity
            case .scale:
                // 添加center锚点以避免缩放时的位置偏移
                // 使用0表示从完全不可见缩放到正常大小
                return AnyTransition.scale(scale: 0, anchor: .center).combined(with: .opacity)
            case .slide:
                // 根据位置选择合适的滑动方向
                switch position {
                case .top:
                    return AnyTransition.move(edge: .top).combined(with: .opacity)
                case .bottom:
                    return AnyTransition.move(edge: .bottom).combined(with: .opacity)
                case .left:
                    return AnyTransition.move(edge: .leading).combined(with: .opacity)
                case .right:
                    return AnyTransition.move(edge: .trailing).combined(with: .opacity)
                default:
                    return AnyTransition.slide.combined(with: .opacity)
                }
            case .move:
                switch position {
                case .top:
                    return AnyTransition.move(edge: .top).combined(with: .opacity)
                case .bottom:
                    return AnyTransition.move(edge: .bottom).combined(with: .opacity)
                case .left:
                    return AnyTransition.move(edge: .leading).combined(with: .opacity)
                case .right:
                    return AnyTransition.move(edge: .trailing).combined(with: .opacity)
                default:
                    return AnyTransition.move(edge: .top).combined(with: .opacity)
                }
            case .asymmetric:
                // 确保异步过渡效果也使用中心锚点，进入从0到1，退出从1到0
                return AnyTransition.asymmetric(
                    insertion: .scale(scale: 0, anchor: .center).combined(with: .opacity),
                    removal: .scale(scale: 0, anchor: .center).combined(with: .opacity)
                )
            }
        }
    }
    
    // 关闭按钮样式选项
    enum CloseButtonStyleOption: String, CaseIterable, Identifiable {
        case circular = "圆形"
        case square = "方形"
        case minimal = "简约"
        case custom = "自定义"
        
        public var id: String { self.rawValue }
        
        // 转换为PopupConfig.CloseButtonStyle
//        func toStyle(themeColor: Color) -> PopupConfig.CloseButtonStyle {
//            switch self {
//            case .circular: return .circular
//            case .square: return .square
//            case .minimal: return .minimal
//            case .custom: return .custom(themeColor, Color.white)
//            }
//        }
    }
} #endif
