#if canImport(UIKit)
import SwiftUI

/// UIManager 组件预览集合入口点
public struct UIManagerDemos: View {
    @StateObject private var themeManager = UIManagerThemeViewModel()
    
    public init() {
        // 确保只初始化一次
        //        if PopupManager.shared.activePopups.isEmpty {
        //            UIManager.initialize()
        //        }
    }
    
    public var body: some View {
        PreviewPopupDemo()
            .environmentObject(themeManager)
            .environmentObject(PopupManager.shared)
            .environmentObject(ToastManager.shared)
            .withUIComponents()
    }
    
    /// 导航包装器
    struct NavWrapper<Content: View>: View {
        let title: String
        let content: Content
        
        init(title: String, @ViewBuilder content: () -> Content) {
            self.title = title
            self.content = content()
        }
        
        var body: some View {
            NavigationView {
                content
                    .navigationTitle(title)
            }
        }
    }
    
    // 内部ThemeViewModel实现
    public class UIManagerThemeViewModel: ObservableObject {
        @Published public var isDarkMode: Bool = false
        
        // 主题色
        public var themeColor: Color {
            Color.blue
        }
        
        // 背景色
        public var backgroundColor: Color {
            isDarkMode ? Color.black : Color(UIColor.systemGray6)
        }
        
        // 主要文本色
        public var primaryTextColor: Color {
            isDarkMode ? Color.white : Color.black
        }
        
        // 次要文本色
        public var secondaryTextColor: Color {
            isDarkMode ? Color.gray : Color.gray
        }
        
        // 切换暗黑模式
        public func toggleDarkMode() {
            isDarkMode.toggle()
        }
    }
    
    // 简化版 PopupDemoView
    struct PreviewPopupDemo: View {
        @EnvironmentObject private var themeManager: UIManagerThemeViewModel
        @EnvironmentObject private var popupManager: PopupManager
        @EnvironmentObject private var toastManager: ToastManager
        
        // 使用自定义类型来区分不同的位置选项，而不是直接使用PopupPosition
        enum PositionOption: String, CaseIterable, Identifiable {
            case center, top, bottom, left, right, custom
            var id: String { self.rawValue }
        }
        
        // 添加动画类型枚举
        enum AnimationType: String, CaseIterable, Identifiable {
            case spring = "弹簧"
            case easeInOut = "缓入缓出"
            case easeIn = "缓入"
            case easeOut = "缓出"
            case linear = "线性"
            
            var id: String { self.rawValue }
            
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
            
            var id: String { self.rawValue }
            
            // 添加描述文本，解释每种动画效果
            var description: String {
                switch self {
                case .fade:
                    return "弹窗逐渐显示或消失，适合需要温和过渡的场景"
                case .scale:
                    return "弹窗从小到大或从大到小缩放，可选择不同的缩放锚点"
                case .slide:
                    return "弹窗从屏幕边缘滑入滑出，适合抽屉式弹窗和提示框"
                case .move:
                    return "弹窗从指定方向移入移出，适合需要明确方向感的场景"
                case .asymmetric:
                    return "进入时缩放并淡入，退出时仅淡出，提供平滑的用户体验"
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
            
            var id: String { self.rawValue }
            
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
            
            var id: String { self.rawValue }
            
            // 添加描述文本，解释缩放方式的区别
            var description: String {
                switch self {
                case .uniform: return "从中心点均匀缩放，最常见的缩放效果"
                case .fromTop: return "从顶部向下缩放，类似下拉效果"
                case .fromBottom: return "从底部向上缩放，适合从底部浮现的弹窗"
                case .fromLeading: return "从左侧向右缩放，适合从左侧展开的面板"
                case .fromTrailing: return "从右侧向左缩放，适合从右侧展开的面板"
                case .fromCenter: return "从中心点向四周缩放，最自然的缩放效果"
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
            
            var id: String { self.rawValue }
            
            // 转换为SwiftUI过渡效果，修复缩放抖动问题
            func toTransition(position: PositionOption) -> AnyTransition {
                switch self {
                case .fade:
                    return AnyTransition.opacity
                case .scale:
                    // 添加center锚点以避免缩放时的位置偏移
                    return AnyTransition.scale(scale: 0.85, anchor: .center).combined(with: .opacity)
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
                    return AnyTransition.asymmetric(
                        insertion: .scale(scale: 0.85).combined(with: .opacity),
                        removal: .opacity
                    )
                }
            }
        }
        
        @State private var selectedPositionOption: PositionOption = .center
        @State private var width: CGFloat = 250
        @State private var height: CGFloat = 250
        @State private var showSizeControls: Bool = false
        @State private var customX: CGFloat = 0.5  // 自定义X坐标比例(0-1)
        @State private var customY: CGFloat = 0.5  // 自定义Y坐标比例(0-1)
        @State private var showCloseButton: Bool = false  // 是否显示关闭按钮
        @State private var offsetY: CGFloat = 0 // 垂直偏移量
        
        // 更新动画相关状态
        @State private var selectedEntryAnimation: AnimationType = .spring
        @State private var selectedExitAnimation: AnimationType = .spring
        @State private var selectedTransitionType: TransitionType = .fade
        @State private var selectedDirection: AnimationDirection = .top
        @State private var selectedScaleType: ScaleType = .uniform
        @State private var animationDuration: Double = 0.3
        @State private var showAnimationControls: Bool = false
        @State private var showAdvancedAnimation: Bool = false
        
        // 关闭按钮样式选项
        enum CloseButtonStyleOption: String, CaseIterable, Identifiable {
            case circular = "圆形"
            case square = "方形"
            case minimal = "简约"
            case custom = "自定义"
            
            var id: String { self.rawValue }
            
            // 转换为PopupBaseConfig.CloseButtonStyle
            func toStyle(themeColor: Color) -> PopupBaseConfig.CloseButtonStyle {
                switch self {
                case .circular: return .circular
                case .square: return .square
                case .minimal: return .minimal
                case .custom: return .custom(themeColor, Color.white)
                }
            }
        }
        
        @State private var selectedButtonStyle: CloseButtonStyleOption = .circular
        
        // 输入框相关状态
        @State private var text = ""
        @FocusState private var isTextFieldFocused: Bool
        
        
        var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Popup 基础组件演示")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.primaryTextColor)
                        .padding(.vertical, 10)
                    
                    // 位置选择器
                    VStack(alignment: .leading, spacing: 8) {
                        Text("选择弹窗位置")
                            .font(.headline)
                            .foregroundColor(themeManager.primaryTextColor)
                        
                        Picker("位置", selection: $selectedPositionOption) {
                            Text("中间").tag(PositionOption.center)
                            Text("顶部").tag(PositionOption.top)
                            Text("底部").tag(PositionOption.bottom)
                            Text("左侧").tag(PositionOption.left)
                            Text("右侧").tag(PositionOption.right)
                            Text("自定义").tag(PositionOption.custom)
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.horizontal)
                    
                    // 自定义位置控制
                    if selectedPositionOption == .custom {
                        VStack(spacing: 12) {
                            Text("自定义位置坐标")
                                .font(.headline)
                                .foregroundColor(themeManager.primaryTextColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // X坐标滑块
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("X坐标: \(Int(customX * 100))%")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.primaryTextColor)
                                    
                                    Spacer()
                                    
                                    Button("居中") {
                                        customX = 0.5
                                    }
                                    .font(.caption)
                                    .foregroundColor(themeManager.themeColor)
                                }
                                
                                Slider(value: $customX, in: 0...1, step: 0.05)
                                    .accentColor(themeManager.themeColor)
                            }
                            
                            // Y坐标滑块
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("Y坐标: \(Int(customY * 100))%")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.primaryTextColor)
                                    
                                    Spacer()
                                    
                                    Button("居中") {
                                        customY = 0.5
                                    }
                                    .font(.caption)
                                    .foregroundColor(themeManager.themeColor)
                                }
                                
                                Slider(value: $customY, in: 0...1, step: 0.05)
                                    .accentColor(themeManager.themeColor)
                            }
                            
                            // 位置预览
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(height: 120)
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                
                                // 位置指示器
                                Circle()
                                    .fill(themeManager.themeColor)
                                    .frame(width: 16, height: 16)
                                    .position(
                                        x: customX * 300,
                                        y: customY * 120
                                    )
                            }
                            .frame(width: 300, height: 120)
                            .clipped()
                            
                            // 添加边界保护说明
                            Text("注意: 弹窗会自动保持在屏幕边界内，即使设置了极端坐标")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.horizontal)
                    }
                    
                    // 尺寸控制开关
                    Toggle(isOn: $showSizeControls) {
                        Text("自定义尺寸")
                            .font(.headline)
                            .foregroundColor(themeManager.primaryTextColor)
                    }
                    .padding(.horizontal)
                    
                    // 自定义尺寸控制
                    if showSizeControls {
                        VStack(spacing: 12) {
                            // 宽度滑块
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("宽度: \(Int(width))")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.primaryTextColor)
                                    
                                    Spacer()
                                    
                                    Button("重置") {
                                        width = 250
                                    }
                                    .font(.caption)
                                    .foregroundColor(themeManager.themeColor)
                                }
                                
                                Slider(value: $width, in: 100...350, step: 10)
                                    .accentColor(themeManager.themeColor)
                            }
                            
                            // 高度滑块
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("高度: \(Int(height))")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.primaryTextColor)
                                    
                                    Spacer()
                                    
                                    Button("重置") {
                                        height = 250
                                    }
                                    .font(.caption)
                                    .foregroundColor(themeManager.themeColor)
                                }
                                
                                Slider(value: $height, in: 100...350, step: 10)
                                    .accentColor(themeManager.themeColor)
                            }
                            
                            // 尺寸预览
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(themeManager.themeColor, lineWidth: 1)
                                    .frame(
                                        width: width * 0.3,
                                        height: height * 0.3
                                    )
                                
                                Text("\(Int(width)) × \(Int(height))")
                                    .font(.caption)
                                    .foregroundColor(themeManager.secondaryTextColor)
                            }
                            .frame(height: 100)
                        }
                        .padding(.horizontal)
                    }
                    
                    // 动画控制开关
                    Toggle(isOn: $showAnimationControls) {
                        Text("自定义动画")
                            .font(.headline)
                            .foregroundColor(themeManager.primaryTextColor)
                    }
                    .padding(.horizontal)
                    
                    // 动画控制面板
                    if showAnimationControls {
                        VStack(spacing: 12) {
                            // 过渡效果类型选择
                            VStack(alignment: .leading, spacing: 8) {
                                Text("过渡效果类型")
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.primaryTextColor)
                                
                                Picker("过渡效果类型", selection: $selectedTransitionType) {
                                    ForEach(TransitionType.allCases) { type in
                                        Text(type.rawValue).tag(type)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .onChange(of: selectedTransitionType) { _ in
                                    // 根据选择的过渡类型自动设置合适的方向
                                    if selectedTransitionType == .move || selectedTransitionType == .slide {
                                        showAdvancedAnimation = true
                                    }
                                }
                                
                                // 添加当前选中的过渡效果描述
                                Text(selectedTransitionType.description)
                                    .font(.caption)
                                    .foregroundColor(themeManager.secondaryTextColor)
                                    .padding(.top, 4)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                            if showAdvancedAnimation || selectedTransitionType == .move || selectedTransitionType == .slide {
                                // 根据过渡类型显示相应的高级选项
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("高级设置")
                                            .font(.subheadline)
                                            .foregroundColor(themeManager.primaryTextColor)
                                        
                                        Spacer()
                                        
                                        Button(action: { showAdvancedAnimation.toggle() }) {
                                            Label(showAdvancedAnimation ? "收起" : "展开", systemImage: showAdvancedAnimation ? "chevron.up" : "chevron.down")
                                                .font(.caption)
                                                .foregroundColor(themeManager.themeColor)
                                        }
                                    }
                                    
                                    if showAdvancedAnimation {
                                        if selectedTransitionType == .move || selectedTransitionType == .slide {
                                            // 方向选择
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("方向")
                                                    .font(.caption)
                                                    .foregroundColor(themeManager.secondaryTextColor)
                                                
                                                Picker("方向", selection: $selectedDirection) {
                                                    ForEach([AnimationDirection.top, .bottom, .leading, .trailing]) { direction in
                                                        Text(direction.rawValue).tag(direction)
                                                    }
                                                }
                                                .pickerStyle(.segmented)
                                                
                                                // 添加当前选中的方向描述
                                                Text(selectedDirection.description)
                                                    .font(.caption)
                                                    .foregroundColor(themeManager.secondaryTextColor.opacity(0.8))
                                                    .padding(.top, 4)
                                            }
                                        } else if selectedTransitionType == .scale {
                                            // 缩放类型选择
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("缩放方式")
                                                    .font(.caption)
                                                    .foregroundColor(themeManager.secondaryTextColor)
                                                
                                                Picker("缩放方式", selection: $selectedScaleType) {
                                                    ForEach(ScaleType.allCases) { type in
                                                        Text(type.rawValue).tag(type)
                                                    }
                                                }
                                                .pickerStyle(.segmented)
                                                
                                                // 添加当前选中的缩放方式描述
                                                Text(selectedScaleType.description)
                                                    .font(.caption)
                                                    .foregroundColor(themeManager.secondaryTextColor.opacity(0.8))
                                                    .padding(.top, 4)
                                            }
                                        } else if selectedTransitionType == .asymmetric {
                                            Text("进入时使用缩放+淡入，退出时使用淡出")
                                                .font(.caption)
                                                .foregroundColor(themeManager.secondaryTextColor)
                                                .multilineTextAlignment(.center)
                                        }
                                    }
                                }
                            }
                            
                            // 进入动画选择
                            VStack(alignment: .leading, spacing: 8) {
                                Text("进入动画")
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.primaryTextColor)
                                
                                Picker("进入动画", selection: $selectedEntryAnimation) {
                                    ForEach(AnimationType.allCases) { anim in
                                        Text(anim.rawValue).tag(anim)
                                    }
                                }
                                .pickerStyle(.segmented)
                                
                                // 添加当前选中的进入动画描述
                                Text(selectedEntryAnimation.description)
                                    .font(.caption)
                                    .foregroundColor(themeManager.secondaryTextColor)
                                    .padding(.top, 4)
                            }
                            
                            // 退出动画选择
                            VStack(alignment: .leading, spacing: 8) {
                                Text("退出动画")
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.primaryTextColor)
                                
                                Picker("退出动画", selection: $selectedExitAnimation) {
                                    ForEach(AnimationType.allCases) { anim in
                                        Text(anim.rawValue).tag(anim)
                                    }
                                }
                                .pickerStyle(.segmented)
                                
                                // 添加当前选中的退出动画描述
                                Text(selectedExitAnimation.description)
                                    .font(.caption)
                                    .foregroundColor(themeManager.secondaryTextColor)
                                    .padding(.top, 4)
                            }
                            
                            // 动画持续时间
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("持续时间: \(String(format: "%.1f", animationDuration))秒")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.primaryTextColor)
                                    
                                    Spacer()
                                    
                                    Button("重置") {
                                        animationDuration = 0.3
                                    }
                                    .font(.caption)
                                    .foregroundColor(themeManager.themeColor)
                                }
                                
                                Slider(value: $animationDuration, in: 0.1...2.0, step: 0.1)
                                    .accentColor(themeManager.themeColor)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // 在自定义尺寸控制之后添加关闭按钮控制
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("显示关闭按钮", isOn: $showCloseButton)
                            .font(.headline)
                            .foregroundColor(themeManager.primaryTextColor)
                        
                        if showCloseButton {
                            Picker("关闭按钮样式", selection: $selectedButtonStyle) {
                                ForEach(CloseButtonStyleOption.allCases) { style in
                                    Text(style.rawValue).tag(style)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal)
                    
                    // 在关闭按钮控制后添加偏移量控制
                    VStack(alignment: .leading, spacing: 8) {
                        Text("垂直偏移量: \(Int(offsetY))")
                            .font(.headline)
                            .foregroundColor(themeManager.primaryTextColor)
                        
                        Slider(value: $offsetY, in: 0...200, step: 10) {
                            Text("偏移量")
                        }
                        .accentColor(themeManager.themeColor)
                    }
                    .padding(.horizontal)
                    
                    // 显示基础弹窗按钮
                    Button(action: showPopup) {
                        Text("显示弹窗")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(themeManager.themeColor)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    // 添加输入框弹窗按钮
                    Button(action: showInputPopup) {
                        Text("显示输入框弹窗")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(themeManager.themeColor.opacity(0.8))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    // 添加标准方向动画演示
                    VStack(alignment: .leading, spacing: 12) {
                        Text("标准方向动画预览")
                            .font(.headline)
                            .foregroundColor(themeManager.primaryTextColor)
                        
                        Text("使用系统默认的线性动画和方向过渡效果")
                            .font(.caption)
                            .foregroundColor(themeManager.secondaryTextColor)
                        
                        HStack(spacing: 10) {
                            Button(action: { showDirectionalPopup(position: .top) }) {
                                VStack {
                                    Image(systemName: "arrow.down")
                                    Text("顶部")
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(themeManager.themeColor.opacity(0.6))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                            
                            Button(action: { showDirectionalPopup(position: .bottom) }) {
                                VStack {
                                    Image(systemName: "arrow.up")
                                    Text("底部")
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(themeManager.themeColor.opacity(0.6))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                        }
                        
                        HStack(spacing: 10) {
                            Button(action: { showDirectionalPopup(position: .left) }) {
                                VStack {
                                    Image(systemName: "arrow.right")
                                    Text("左侧")
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(themeManager.themeColor.opacity(0.6))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                            
                            Button(action: { showDirectionalPopup(position: .right) }) {
                                VStack {
                                    Image(systemName: "arrow.left")
                                    Text("右侧")
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(themeManager.themeColor.opacity(0.6))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // 底部留白，确保滚动到底部有足够空间
                    Spacer()
                        .frame(height: 30)
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .background(themeManager.backgroundColor)
        }
        
        // 根据用户选择生成过渡效果，分别为进入和退出创建不同的效果
        private func getEntryTransition() -> AnyTransition {
            switch selectedTransitionType {
            case .fade:
                return AnyTransition.opacity
            case .scale:
                switch selectedScaleType {
                case .uniform, .fromCenter:
                    // 明确指定使用.center作为缩放锚点，确保缩放时没有额外的位置偏移
                    return AnyTransition.scale(scale: 0.7, anchor: .center).combined(with: .opacity)
                case .fromTop:
                    return AnyTransition.scale(scale: 0.7, anchor: .top).combined(with: .opacity)
                case .fromBottom:
                    return AnyTransition.scale(scale: 0.7, anchor: .bottom).combined(with: .opacity)
                case .fromLeading:
                    return AnyTransition.scale(scale: 0.7, anchor: .leading).combined(with: .opacity)
                case .fromTrailing:
                    return AnyTransition.scale(scale: 0.7, anchor: .trailing).combined(with: .opacity)
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
                // 确保异步过渡效果也使用中心锚点
                return AnyTransition.asymmetric(
                    insertion: .scale(scale: 0.7, anchor: .center).combined(with: .opacity),
                    removal: .opacity
                )
            }
        }
        
        private func getExitTransition() -> AnyTransition {
            switch selectedTransitionType {
            case .fade:
                return AnyTransition.opacity
            case .scale:
                // 退出时总是使用淡出效果，避免缩放抖动
                return AnyTransition.opacity
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
                return AnyTransition.opacity // 退出时只淡出
            }
        }
        
        // 修改showPopup方法，完全分离进入和退出动画效果
        private func showPopup() {
            // 根据位置和设置决定尺寸
            var popupWidth: CGFloat? = nil
            var popupHeight: CGFloat? = nil
            
            if showSizeControls {
                // 使用自定义尺寸
                popupWidth = width
                popupHeight = height
            } else {
                // 使用默认尺寸逻辑
                switch selectedPositionOption {
                case .left, .right:
                    popupWidth = 250
                case .bottom, .top:
                    popupHeight = 250
                case .center:
                    popupWidth = 280
                    popupHeight = 200
                case .custom:
                    popupWidth = 280
                    popupHeight = 200
                }
            }
            
            // 创建一个自定义ID，用于后续更新弹窗
            let popupID = UUID()
            
            // 创建配置，添加关闭按钮设置和动画设置
            var entryConfig = PopupBaseConfig(
                cornerRadius: 12,
                shadowEnabled: true,
                closeOnTapOutside: true,
                showCloseButton: showCloseButton,
                closeButtonPosition: .topTrailing,
                closeButtonStyle: selectedButtonStyle.toStyle(themeColor: themeManager.themeColor),
                offsetY: offsetY
            )
            
            // 创建退出配置
            var exitConfig: PopupBaseConfig? = nil
            
            // 设置进入动画 - 使用用户选择的进入动画类型
            if showAnimationControls {
                entryConfig.animation = selectedEntryAnimation.toAnimation(duration: animationDuration)
                entryConfig.customTransition = getEntryTransition()
                
                // 创建退出配置
                exitConfig = PopupBaseConfig(
                    cornerRadius: entryConfig.cornerRadius,
                    shadowEnabled: entryConfig.shadowEnabled,
                    closeOnTapOutside: entryConfig.closeOnTapOutside,
                    showCloseButton: entryConfig.showCloseButton,
                    closeButtonPosition: entryConfig.closeButtonPosition,
                    closeButtonStyle: entryConfig.closeButtonStyle,
                    animation: selectedExitAnimation.toAnimation(duration: animationDuration),
                    customTransition: getExitTransition(),
                    offsetY: entryConfig.offsetY
                )
            }
            
            // 将位置选项转换为PopupPosition
            var position: PopupPosition
            switch selectedPositionOption {
            case .center:
                position = .center
            case .top:
                position = .top
            case .bottom:
                position = .bottom
            case .left:
                position = .left
            case .right:
                position = .right
            case .custom:
                // 创建自定义位置，使用比例坐标
                position = .custom(CGPoint(x: customX, y: customY))
            }
            
            // 使用显式的动画包装显示弹窗操作
            withAnimation(entryConfig.animation) {
                // 显示具有进入动画的弹窗
                popupManager.show(
                    content: {
                        VStack(spacing: 16) {
                            Text(getPositionName(selectedPositionOption))
                                .font(.headline)
                                .foregroundColor(themeManager.primaryTextColor)
                            
                            if selectedPositionOption == .custom {
                                Text("位置: X=\(Int(customX * 100))%, Y=\(Int(customY * 100))%")
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.secondaryTextColor)
                                
                                Text("(实际显示位置会自动调整以确保弹窗完全显示在屏幕内)")
                                    .font(.caption)
                                    .foregroundColor(themeManager.secondaryTextColor.opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                            
                            if showSizeControls {
                                Text("尺寸: \(Int(popupWidth ?? 0)) × \(Int(popupHeight ?? 0))")
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.secondaryTextColor)
                            }
                            
                            if showAnimationControls {
                                VStack(spacing: 4) {
                                    Text("过渡效果: \(selectedTransitionType.rawValue)")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.secondaryTextColor)
                                    
                                    // 显示高级设置信息
                                    if showAdvancedAnimation {
                                        if selectedTransitionType == .move || selectedTransitionType == .slide {
                                            Text("方向: \(selectedDirection.rawValue)")
                                                .font(.subheadline)
                                                .foregroundColor(themeManager.secondaryTextColor)
                                        } else if selectedTransitionType == .scale {
                                            Text("缩放方式: \(selectedScaleType.rawValue)")
                                                .font(.subheadline)
                                                .foregroundColor(themeManager.secondaryTextColor)
                                        }
                                    }
                                    
                                    Text("进入动画: \(selectedEntryAnimation.rawValue)")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.secondaryTextColor)
                                    
                                    Text("退出动画: \(selectedExitAnimation.rawValue)")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.secondaryTextColor)
                                    
                                    Text("持续时间: \(String(format: "%.1f", animationDuration))秒")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.secondaryTextColor)
                                    
                                    Text("(注: 进入和退出使用相同方向，体验更加自然)")
                                        .font(.caption)
                                        .foregroundColor(themeManager.secondaryTextColor)
                                        .padding(.top, 4)
                                }
                            }
                            
                            Text("这是一个基础弹窗示例，您可以选择不同的位置和动画来展示。")
                                .font(.subheadline)
                                .foregroundColor(themeManager.secondaryTextColor)
                                .multilineTextAlignment(.center)
                            
                            Button(action: {
                                // 使用与进入相反的退出动画关闭弹窗
                                if let exitAnim = exitConfig?.animation {
                                    withAnimation(exitAnim) {
                                        popupManager.closePopup(id: popupID)
                                    }
                                } else {
                                    withAnimation {
                                        popupManager.closePopup(id: popupID)
                                    }
                                }
                            }) {
                                Text("关闭")
                                    .frame(width: 100, height: 40)
                                    .background(themeManager.themeColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                    },
                    position: position,
                    width: popupWidth,
                    height: popupHeight,
                    config: entryConfig,
                    exitConfig: exitConfig,
                    id: popupID
                )
            }
        }
        
        // 修改showInputPopup方法，完全分离进入和退出动画效果
        private func showInputPopup() {
            // 创建一个自定义ID，用于后续更新弹窗
            let popupID = UUID()
            
            // 初始弹窗配置，开始时不设置偏移
            var entryConfig = PopupBaseConfig(
                cornerRadius: 16,
                shadowEnabled: true,
                closeOnTapOutside: true,
                showCloseButton: showCloseButton,
                closeButtonPosition: .topTrailing,
                closeButtonStyle: selectedButtonStyle.toStyle(themeColor: themeManager.themeColor),
                offsetY: 0 // 初始不偏移
            )
            
            // 创建退出配置
            var exitConfig: PopupBaseConfig? = nil
            
            // 设置进入动画 - 使用用户选择的进入动画类型
            if showAnimationControls {
                entryConfig.animation = selectedEntryAnimation.toAnimation(duration: animationDuration)
                entryConfig.customTransition = getEntryTransition()
                
                // 创建退出配置
                exitConfig = PopupBaseConfig(
                    cornerRadius: entryConfig.cornerRadius,
                    shadowEnabled: entryConfig.shadowEnabled,
                    closeOnTapOutside: entryConfig.closeOnTapOutside,
                    showCloseButton: entryConfig.showCloseButton,
                    closeButtonPosition: entryConfig.closeButtonPosition,
                    closeButtonStyle: entryConfig.closeButtonStyle,
                    animation: selectedExitAnimation.toAnimation(duration: animationDuration),
                    customTransition: getExitTransition(),
                    offsetY: entryConfig.offsetY
                )
            }
            
            // 使用进入动画包装显示操作
            withAnimation(entryConfig.animation) {
                popupManager.show(
                    content: {
                        VStack(spacing: 20) {
                            ScrollView {
                                VStack(spacing: 20) {
                                    ForEach(0..<2) { index in
                                        TextField("输入框 \(index)", text: .constant(""))
                                            .textFieldStyle(.roundedBorder)
                                            .focused($isTextFieldFocused)
                                            .padding(.horizontal)
                                            // 添加以下修饰符以提高键盘交互的稳定性
                                            .submitLabel(.done)
                                            .keyboardType(.default)
                                            .autocapitalization(.none)
                                            .disableAutocorrection(true)
                                    }
                                }
                                .padding(.top, 40)
                                .padding(.bottom, 20)
                            }
                            .simultaneousGesture(
                                TapGesture()
                                    .onEnded { _ in
                                        // 点击ScrollView内部的空白区域不会关闭键盘
                                    }
                            )
                            
                            // 添加一个完成按钮，方便用户关闭键盘
                            Button(action: {
                                isTextFieldFocused = false
                                // 使用短延迟更好地配合键盘动画
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    // 使用与进入相反的退出动画关闭弹窗
                                    if let exitAnim = exitConfig?.animation {
                                        withAnimation(exitAnim) {
                                            popupManager.closePopup(id: popupID)
                                        }
                                    } else {
                                        withAnimation {
                                            popupManager.closePopup(id: popupID)
                                        }
                                    }
                                }
                            }) {
                                Text("完成")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(height: 44)
                                    .frame(maxWidth: .infinity)
                                    .background(themeManager.themeColor)
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal)
                        }
                        .onAppear {
                            // 先等弹窗完全显示
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                // 再聚焦输入框，触发键盘显示
                                isTextFieldFocused = true
                            }
                        }
                        .onDisappear {
                            // 确保弹窗关闭时键盘也会收起
                            isTextFieldFocused = false
                        }
                    },
                    position: .center,
                    width: 300,
                    height: 280, // 增加高度以容纳按钮
                    config: entryConfig,
                    exitConfig: exitConfig,
                    id: popupID // 使用自定义ID
                )
            }
        }
        
        // 显示标准方向弹窗，使用默认的线性动画和滑动效果
        private func showDirectionalPopup(position: PopupPosition) {
            // 创建一个自定义ID
            let popupID = UUID()
            
            // 根据位置确定合适的尺寸
            var popupWidth: CGFloat? = nil
            var popupHeight: CGFloat? = nil
            
            switch position {
            case .top, .bottom:
                popupHeight = 200
            case .left, .right:
                popupWidth = 200
            case .center, .custom:
                popupWidth = 250
                popupHeight = 200
            }
            
            // 创建一个简单的配置，不使用任何自定义设置，让系统使用默认配置
            let config = PopupBaseConfig(
                cornerRadius: 12,
                shadowEnabled: true,
                closeOnTapOutside: true,
                showCloseButton: true
            )
            
            // 显示弹窗，不传递任何自定义动画或过渡效果，让系统使用默认值
            popupManager.show(
                content: {
                    VStack(spacing: 16) {
                        Text(getPositionName(position))
                            .font(.headline)
                            .foregroundColor(themeManager.primaryTextColor)
                        
                        Text("使用系统默认的线性动画和滑动效果")
                            .font(.subheadline)
                            .foregroundColor(themeManager.secondaryTextColor)
                            .multilineTextAlignment(.center)
                        
                        Text("动画过渡效果使用了线性动画和方向性滑动")
                            .font(.caption)
                            .foregroundColor(themeManager.secondaryTextColor)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            popupManager.closePopup(id: popupID)
                        }) {
                            Text("关闭")
                                .frame(width: 100, height: 40)
                                .background(themeManager.themeColor)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                },
                position: position,
                width: popupWidth,
                height: popupHeight,
                config: config,
                id: popupID
            )
        }
        
        // 获取位置名称
        private func getPositionName(_ position: PopupPosition) -> String {
            switch position {
            case .center:
                return "中间弹窗"
            case .top:
                return "顶部弹窗"
            case .bottom:
                return "底部弹窗"
            case .left:
                return "左侧弹窗"
            case .right:
                return "右侧弹窗"
            case .custom(let point):
                return "自定义位置弹窗 (\(Int(point.x * 100))%, \(Int(point.y * 100))%)"
            }
        }
        
        // 获取位置名称 - PositionOption版本
        private func getPositionName(_ position: PositionOption) -> String {
            switch position {
            case .center:
                return "中间弹窗"
            case .top:
                return "顶部弹窗"
            case .bottom:
                return "底部弹窗"
            case .left:
                return "左侧弹窗"
            case .right:
                return "右侧弹窗"
            case .custom:
                return "自定义位置弹窗"
            }
        }
    }
}



// MARK: - 预览
#Preview {
    UIManagerDemos()
        .environment(\.popupManager, PopupManager.shared) // 确保预览使用相同的实例
}
#endif
