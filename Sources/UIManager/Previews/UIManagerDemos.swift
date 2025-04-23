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
        
        @State private var selectedPositionOption: PositionOption = .center
        @State private var width: CGFloat = 250
        @State private var height: CGFloat = 250
        @State private var showSizeControls: Bool = false
        @State private var customX: CGFloat = 0.5  // 自定义X坐标比例(0-1)
        @State private var customY: CGFloat = 0.5  // 自定义Y坐标比例(0-1)
        
        // 输入框相关状态
        @State private var text = ""
        @FocusState private var isTextFieldFocused: Bool
        
        
        var body: some View {
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
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(themeManager.backgroundColor)
        }
        
        // 显示基础弹窗
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
            
            let config = PopupBaseConfig(
                showCloseButton: true,
                closeButtonPosition: .topTrailing
            )
            
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
                        
                        Text("这是一个基础弹窗示例，您可以选择不同的位置来展示。")
                            .font(.subheadline)
                            .foregroundColor(themeManager.secondaryTextColor)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            popupManager.closeAllPopups()
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
                config: config
            )
        }
        
        // 显示输入框弹窗
        private func showInputPopup() {
            let config = PopupBaseConfig(
                cornerRadius: 16,
                showCloseButton: true,
                closeButtonPosition: .topTrailing
            )
            
            popupManager.show(
                content: {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(0..<2) { index in
                                TextField("输入框 \(index)", text: .constant(""))
                                    .textFieldStyle(.roundedBorder)
                                    .focused($isTextFieldFocused)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top, 40)
                    }
                    .safeAreaInset(edge: .bottom) {  // 🔥 用 safeAreaInset 动态空出键盘高度
                        Color.clear.frame(height: 0)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            isTextFieldFocused = true
                        }
                    }
                },
                position: .center,
                width: 300,
                height: 150,
                config: config
            )
        }
        
        // 获取位置名称
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
