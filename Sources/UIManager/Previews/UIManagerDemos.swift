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
        
        @State private var selectedPosition: PopupPosition = .center
        @State private var inputValue: String = ""
        
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
                    
                    Picker("位置", selection: $selectedPosition) {
                        Text("中间").tag(PopupPosition.center)
                        Text("顶部").tag(PopupPosition.top)
                        Text("底部").tag(PopupPosition.bottom)
                        Text("左侧").tag(PopupPosition.left)
                        Text("右侧").tag(PopupPosition.right)
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal)
                
                // 显示基础弹窗按钮
                Button(action: showPopup) {
                    Text("显示基础弹窗")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(themeManager.themeColor)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                // 显示输入框弹窗按钮
                Button(action: showInputPopup) {
                    Text("显示输入框弹窗")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(themeManager.themeColor)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                // 显示输入的内容
                if !inputValue.isEmpty {
                    Text("输入的内容: \(inputValue)")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
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
            // 根据选择的位置设置合适的尺寸
            let size: PopupSize
            switch selectedPosition {
            case .top, .bottom:
                size = .fullWidth(nil)
            case .left, .right:
                size = .fullHeight(200)
            default:
                size = .flexible
            }
            
            let config = PopupBaseConfig(
                showCloseButton: true,
                closeButtonPosition: .topTrailing
            )
            
            popupManager.show(
                content: {
                    VStack(spacing: 16) {
                        Text(getPositionName(selectedPosition))
                            .font(.headline)
                            .foregroundColor(themeManager.primaryTextColor)
                        
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
                position: selectedPosition,
                size: size,
                config: config
            )
        }
        
        // 显示输入框弹窗
        private func showInputPopup() {
            popupManager.showStandardInput(
                title: "请输入内容",
                message: "这是一个输入框弹窗示例，支持键盘适配",
                placeholder: "请在此输入...",
                initialText: inputValue,
                keyboardType: .default,
                submitLabel: .done,
                onCancel: {
                    toastManager.showToast(message: "已取消输入")
                },
                onSubmit: { text in
                    if !text.isEmpty {
                        inputValue = text
                        toastManager.showSuccess(message: "输入成功")
                    } else {
                        toastManager.showError(message: "输入内容不能为空")
                    }
                }
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
            default:
                return "弹窗"
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
