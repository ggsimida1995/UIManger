#if DEBUG || PREVIEW
import SwiftUI
import UIManager

// 弹出窗口演示组件
public struct PreviewPopupDemo: View {
    @EnvironmentObject var popupManager: PopupManager
    
    // 状态属性
    @State var selectedPositionOption: PositionOption = .center
    @State var width: CGFloat = 250
    @State var height: CGFloat = 250
    @State var showSizeControls: Bool = false
    @State var showCloseButton: Bool = false  // 是否显示关闭按钮
    @State var offsetY: CGFloat = 0 // 垂直偏移量
    
    // 更新动画相关状态
    @State var selectedEntryAnimation: AnimationType = .spring
    @State var selectedExitAnimation: AnimationType = .spring
    @State var selectedTransitionType: TransitionType = .fade
    @State var selectedDirection: AnimationDirection = .top
    @State var selectedScaleType: ScaleType = .uniform
    @State var animationDuration: Double = 0.3
    @State var showAnimationControls: Bool = false
    @State var showAdvancedAnimation: Bool = false
    
    // 关闭按钮样式选项
    @State var selectedButtonStyle: CloseButtonStyleOption = .circular
    
    // 输入框相关状态
    @State var text = ""
    @FocusState var isTextFieldFocused: Bool
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Popup 基础组件演示")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.vertical, 10)
                
                // 位置选择器
                VStack(alignment: .leading, spacing: 8) {
                    Text("选择弹窗位置")
                        .font(.headline)
                    
                    Picker("位置", selection: $selectedPositionOption) {
                        Text("中间").tag(PositionOption.center)
                        Text("顶部").tag(PositionOption.top)
                        Text("底部").tag(PositionOption.bottom)
                        Text("左侧").tag(PositionOption.left)
                        Text("右侧").tag(PositionOption.right)
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal)
                
                // 尺寸控制开关
                Toggle(isOn: $showSizeControls) {
                    Text("自定义尺寸")
                        .font(.headline)
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
                                
                                Spacer()
                                
                                Button("重置") {
                                    width = 250
                                }
                                .font(.caption)
                                .foregroundColor(.blue)
                            }
                            
                            Slider(value: $width, in: 100...350, step: 10)
                                .accentColor(.blue)
                        }
                        
                        // 高度滑块
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("高度: \(Int(height))")
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Button("重置") {
                                    height = 250
                                }
                                .font(.caption)
                                .foregroundColor(.blue)
                            }
                            
                            Slider(value: $height, in: 100...350, step: 10)
                                .accentColor(.blue)
                        }
                        
                        // 尺寸预览
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                                .frame(
                                    width: width * 0.3,
                                    height: height * 0.3
                                )
                            
                            Text("\(Int(width)) × \(Int(height))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(height: 100)
                    }
                    .padding(.horizontal)
                }
                
                // 动画控制开关
                Toggle(isOn: $showAnimationControls) {
                    Text("自定义动画")
                        .font(.headline)
                }
                .padding(.horizontal)
                
                // 动画控制面板
                if showAnimationControls {
                    VStack(spacing: 12) {
                        // 过渡效果类型选择
                        VStack(alignment: .leading, spacing: 8) {
                            Text("过渡效果类型")
                                .font(.subheadline)
                            
                            Picker("过渡效果类型", selection: $selectedTransitionType) {
                                ForEach(TransitionType.allCases) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(.segmented)
                            
                            // 添加当前选中的过渡效果描述
                            Text(selectedTransitionType.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.top, 4)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        if selectedTransitionType == .scale || selectedTransitionType == .move || selectedTransitionType == .slide {
                            // 根据过渡类型显示相应的高级选项
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("高级设置")
                                        .font(.subheadline)
                                    
                                    Spacer()
                                    
                                    Button(action: { showAdvancedAnimation.toggle() }) {
                                        Label(showAdvancedAnimation ? "收起" : "展开", systemImage: showAdvancedAnimation ? "chevron.up" : "chevron.down")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }
                                
                                if showAdvancedAnimation {
                                    if selectedTransitionType == .move || selectedTransitionType == .slide {
                                        // 方向选择
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("方向")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            
                                            Picker("方向", selection: $selectedDirection) {
                                                ForEach([AnimationDirection.top, .bottom, .leading, .trailing]) { direction in
                                                    Text(direction.rawValue).tag(direction)
                                                }
                                            }
                                            .pickerStyle(.segmented)
                                            
                                            // 添加当前选中的方向描述
                                            Text(selectedDirection.description)
                                                .font(.caption)
                                                .foregroundColor(.secondary.opacity(0.8))
                                                .padding(.top, 4)
                                        }
                                    } else if selectedTransitionType == .scale {
                                        // 缩放类型选择
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("缩放方式")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            
                                            Picker("缩放方式", selection: $selectedScaleType) {
                                                ForEach(ScaleType.allCases) { type in
                                                    Text(type.rawValue).tag(type)
                                                }
                                            }
                                            .pickerStyle(.segmented)
                                            
                                            // 添加当前选中的缩放方式描述
                                            Text(selectedScaleType.description)
                                                .font(.caption)
                                                .foregroundColor(.secondary.opacity(0.8))
                                                .padding(.top, 4)
                                        }
                                    } else if selectedTransitionType == .asymmetric {
                                        Text("进入时从零大小缩放到正常大小并淡入，退出时从正常大小缩小到零并淡出")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }
                        }
                        
                        // 进入动画选择
                        VStack(alignment: .leading, spacing: 8) {
                            Text("进入动画")
                                .font(.subheadline)
                            
                            Picker("进入动画", selection: $selectedEntryAnimation) {
                                ForEach(AnimationType.allCases) { anim in
                                    Text(anim.rawValue).tag(anim)
                                }
                            }
                            .pickerStyle(.segmented)
                            
                            // 添加当前选中的进入动画描述
                            Text(selectedEntryAnimation.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.top, 4)
                        }
                        
                        // 退出动画选择
                        VStack(alignment: .leading, spacing: 8) {
                            Text("退出动画")
                                .font(.subheadline)
                            
                            Picker("退出动画", selection: $selectedExitAnimation) {
                                ForEach(AnimationType.allCases) { anim in
                                    Text(anim.rawValue).tag(anim)
                                }
                            }
                            .pickerStyle(.segmented)
                            
                            // 添加当前选中的退出动画描述
                            Text(selectedExitAnimation.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.top, 4)
                        }
                        
                        // 动画持续时间
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("持续时间: \(String(format: "%.1f", animationDuration))秒")
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Button("重置") {
                                    animationDuration = 0.3
                                }
                                .font(.caption)
                                .foregroundColor(.blue)
                            }
                            
                            Slider(value: $animationDuration, in: 0.1...2.0, step: 0.1)
                                .accentColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // 在自定义尺寸控制之后添加关闭按钮控制
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("显示关闭按钮", isOn: $showCloseButton)
                        .font(.headline)
                    
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
                    
                    Slider(value: $offsetY, in: 0...200, step: 10) {
                        Text("偏移量")
                    }
                    .accentColor(.blue)
                }
                .padding(.horizontal)
                
                // 显示基础弹窗按钮
                Button(action: showPopup) {
                    Text("显示弹窗")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.blue)
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
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                // 添加标准方向动画演示
                VStack(alignment: .leading, spacing: 12) {
                    Text("标准方向动画预览")
                        .font(.headline)
                    
                    Text("使用系统默认的过渡效果")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 10) {
                        Button(action: { showDirectionalPopup(position: .top) }) {
                            VStack {
                                Image(systemName: "arrow.down")
                                Text("顶部")
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.blue.opacity(0.6))
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
                            .background(Color.blue.opacity(0.6))
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
                            .background(Color.blue.opacity(0.6))
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
                            .background(Color.blue.opacity(0.6))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
                
                // 添加绝对位置弹窗演示
                VStack(alignment: .leading, spacing: 12) {
                    Text("绝对位置弹窗预览")
                        .font(.headline)
                    
                    Text("使用距离边缘的绝对像素距离定位弹窗")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // 贴边弹窗
                    HStack(spacing: 10) {
                        Button(action: { showAbsolutePositionPopup(left: 0) }) {
                            VStack {
                                Image(systemName: "rectangle.leadinghalf.inset.filled")
                                Text("贴左边")
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.blue.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        
                        Button(action: { showAbsolutePositionPopup(right: 0) }) {
                            VStack {
                                Image(systemName: "rectangle.trailinghalf.inset.filled")
                                Text("贴右边")
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.blue.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    
                    HStack(spacing: 10) {
                        Button(action: { showAbsolutePositionPopup(top: 0) }) {
                            VStack {
                                Image(systemName: "rectangle.tophalf.inset.filled")
                                Text("贴顶部")
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.blue.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        
                        Button(action: { showAbsolutePositionPopup(bottom: 0) }) {
                            VStack {
                                Image(systemName: "rectangle.bottomhalf.inset.filled")
                                Text("贴底部")
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.blue.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    
                    // 添加角落贴边弹窗
                    HStack(spacing: 10) {
                        Button(action: { showAbsolutePositionPopup(left: 0, top: 0) }) {
                            VStack {
                                Image(systemName: "arrow.up.left.square")
                                Text("左上角")
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.blue.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        
                        Button(action: { showAbsolutePositionPopup(left: nil, top: 0, right: 0, bottom: nil) }) {
                            VStack {
                                Image(systemName: "arrow.up.right.square")
                                Text("右上角")
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.blue.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    
                    HStack(spacing: 10) {
                        Button(action: { showAbsolutePositionPopup(left: 0, top: nil, right: nil, bottom: 0) }) {
                            VStack {
                                Image(systemName: "arrow.down.left.square")
                                Text("左下角")
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.blue.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        
                        Button(action: { showAbsolutePositionPopup(left: nil, top: nil, right: 0, bottom: 0) }) {
                            VStack {
                                Image(systemName: "arrow.down.right.square")
                                Text("右下角")
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.blue.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
                
                // 底部留白
                Spacer()
                    .frame(height: 30)
            }
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
        }
    }
} #endif
