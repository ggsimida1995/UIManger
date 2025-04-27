#if DEBUG || PREVIEW
#if canImport(UIKit)
import SwiftUI

/// UIManager 组件预览集合入口点
public struct UIManagerDemos: View {
    public init() {
        // 确保初始化环境
    }
    
    public var body: some View {
        NavigationView {
            List {
                // 标题部分
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("UI组件预览")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("选择一个组件类型开始演示")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .listRowInsets(EdgeInsets(top: 20, leading: 16, bottom: 16, trailing: 16))
                    .listRowBackground(Color.clear)
                }
                
                // 组件导航列表
                Section {
                    ForEach(DemoType.allCases, id: \.self) { demo in
                        NavigationLink(destination: getDemoView(for: demo)) {
                            HStack(spacing: 16) {
                                Image(systemName: demo.icon)
                                    .font(.system(size: 24))
                                    .foregroundColor(.blue)
                                    .frame(width: 40, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.blue.opacity(0.1))
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(demo.title)
                                        .font(.headline)
                                    
                                    Text(demo.description)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                } header: {
                    Text("组件")
                }
                
                // 版本信息
                Section {
                    HStack {
                        Text("UIManager版本")
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("v\(UIManager.version)")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("关于")
                }
            }
            .listStyle(InsetGroupedListStyle())
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("UI组件")
            .environmentObject(PopupManager.shared)
            .environmentObject(ToastManager.shared)
            .withUIComponents()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    /// 根据演示类型获取对应的视图
    @ViewBuilder
    private func getDemoView(for demoType: DemoType) -> some View {
        Group {
            switch demoType {
            case .popup:
                PopupDemoScreen()
            case .toast:
                ToastDemoScreen()
            case .loading:
                LoadingDemoScreen()
            case .dialog:
                DialogDemoScreen()
            case .subsection:
                SubsectionDemoScreen()
            case .button:
                ButtonDemo()
            }
        }
        .environmentObject(PopupManager.shared)
        .environmentObject(ToastManager.shared)
        .withUIComponents()
    }
    
    /// 可用演示类型
    enum DemoType: String, CaseIterable {
        case popup
        case toast
        case loading
        case dialog
        case subsection
        case button
        
        var title: String {
            switch self {
            case .popup: return "弹窗"
            case .toast: return "Toast提示"
            case .loading: return "加载动画"
            case .dialog: return "对话框"
            case .subsection: return "分段器"
            case .button: return "按钮"
            }
        }
        
        var description: String {
            switch self {
            case .popup: return "灵活的自定义弹窗系统"
            case .toast: return "轻量级的文本提示组件"
            case .loading: return "各种加载状态显示组件"
            case .dialog: return "提供用户交互的对话框组件"
            case .subsection: return "灵活的分段选择组件"
            case .button: return "丰富的按钮样式组件"
            }
        }
        
        var icon: String {
            switch self {
            case .popup: return "rectangle.on.rectangle"
            case .toast: return "text.bubble.fill"
            case .loading: return "arrow.clockwise.circle"
            case .dialog: return "text.bubble.fill"
            case .subsection: return "list.bullet"
            case .button: return "button.programmable"
            }
        }
    }
}

// MARK: - 独立的演示屏幕

/// 弹窗演示屏幕
struct PopupDemoScreen: View {
    var body: some View {
        PreviewPopupDemo()
            .navigationTitle("弹窗组件")
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }
}

/// Toast演示屏幕
struct ToastDemoScreen: View {
    @EnvironmentObject var toastManager: ToastManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                
                styleSection
                
                customizationSection
            }
            .padding()
        }
        .navigationTitle("Toast提示")
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }
    
    // MARK: - UI组件
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Toast提示组件")
                .font(.title)
                .fontWeight(.bold)
            
            Text("轻量级、非阻断式的简短消息通知")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom)
    }
    
    private var styleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Toast样式")
                .font(.headline)
            
            // 普通提示按钮
            toastButton(
                title: "信息提示",
                icon: "info.circle.fill",
                color: .blue
            ) {
                toastManager.showToast(message: "这是一条信息提示")
            }
            
            // 成功提示按钮
            toastButton(
                title: "成功提示",
                icon: "checkmark.circle.fill",
                color: .green
            ) {
                toastManager.showSuccess(message: "操作已成功完成")
            }
            
            // 警告提示按钮
            toastButton(
                title: "警告提示",
                icon: "exclamationmark.triangle.fill",
                color: .orange
            ) {
                toastManager.showWarning(message: "请注意，这是一个警告")
            }
            
            // 错误提示按钮
            toastButton(
                title: "错误提示",
                icon: "xmark.circle.fill",
                color: .red
            ) {
                toastManager.showError(message: "操作失败，请重试")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private var customizationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("自定义持续时间")
                .font(.headline)
            
            // 长时间显示
            toastButton(
                title: "长时间Toast (5秒)",
                icon: "clock.fill",
                color: .purple
            ) {
                toastManager.showToast(message: "这条Toast会显示5秒钟", duration: 5.0)
            }
            
            // 短时间显示
            toastButton(
                title: "短时间Toast (1秒)",
                icon: "clock",
                color: .blue
            ) {
                toastManager.showToast(message: "这条Toast会很快消失", duration: 1.0)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    // 创建统一样式的Toast按钮
    private func toastButton(
        title: String,
        icon: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .background(
                        Circle()
                            .fill(color)
                    )
                
                Text(title)
                    .font(.system(size: 16))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Color.gray.opacity(0.5))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
            )
        }
    }
}

/// 加载动画演示屏幕
struct LoadingDemoScreen: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("加载指示器演示")
                .font(.title)
            
            Text("此功能正在开发中，敬请期待...")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()
            
            // 示例加载动画
            VStack(spacing: 24) {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
                
                Text("模拟加载中")
                    .foregroundColor(.secondary)
            }
            .frame(width: 200, height: 200)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            
            Button("显示加载动画") {
                // 实际功能将在后续实现
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .navigationTitle("加载动画")
    }
}

/// 对话框演示屏幕
struct DialogDemoScreen: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("对话框演示")
                .font(.title)
            
            Text("此功能正在开发中，敬请期待...")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()
            
            // 对话框示例UI
            VStack(spacing: 24) {
                Image(systemName: "text.bubble.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                
                Text("确认操作")
                    .font(.headline)
                
                Text("您确定要执行此操作吗？")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 12) {
                    Button("取消") {}
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    Button("确认") {}
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(24)
            .frame(width: 280)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
            )
            
            Button("显示对话框示例") {
                // 实际功能将在后续实现
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .navigationTitle("对话框")
    }
}

// MARK: - 预览
#Preview {
    UIManagerDemos()
        .environment(\.popupManager, PopupManager.shared) // 确保预览使用相同的实例
}
#endif
#endif
