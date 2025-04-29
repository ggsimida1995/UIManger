#if DEBUG || PREVIEW
#if canImport(UIKit)
import SwiftUI
//import UIManager

/// UIManager 组件预览集合入口点
public struct UIManagerDemos: View {
    @State private var selectedDemo: DemoType? = .popup
    
    public init() {
        // 确保初始化环境
    }
    
    public var body: some View {
        NavigationStack {
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
                    ForEach(DemoType.allCases) { demo in
                        NavigationLink(value: demo) {
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
            .navigationDestination(for: DemoType.self) { demo in
                demoView(for: demo)
            }
            .environmentObject(PopupManager.shared)
            .environmentObject(ToastManager.shared)
            
        }
    }
    
    @ViewBuilder
    private func demoView(for demo: DemoType) -> some View {
        switch demo {
        case .popup:
            PreviewPopupDemo()
            .withUIComponents()
        case .toast:
            ToastDemoScreen()
            .withUIComponents()
        case .subsection:
            SubsectionDemoScreen()
        case .button:
            ButtonDemo()
        case .inputPopup:
            InputPopupDemo()
        }
    }
    
    /// 可用演示类型
    enum DemoType: String, CaseIterable, Identifiable {
        case popup = "弹窗演示"
        case toast = "Toast演示"
        case subsection = "分段器演示"
        case button = "按钮演示"
        case inputPopup = "输入框弹窗演示"
        
        var id: String { rawValue }
        
        var title: String {
            switch self {
            case .popup: return "弹窗"
            case .toast: return "Toast提示"
            case .subsection: return "分段器"
            case .button: return "按钮"
            case .inputPopup: return "输入框弹窗"
            }
        }
        
        var description: String {
            switch self {
            case .popup: return "灵活的自定义弹窗系统"
            case .toast: return "轻量级的文本提示组件"
            case .subsection: return "灵活的分段选择组件"
            case .button: return "丰富的按钮样式组件"
            case .inputPopup: return "支持多种输入类型的弹窗组件"
            }
        }
        
        var icon: String {
            switch self {
            case .popup: return "rectangle.on.rectangle"
            case .toast: return "text.bubble.fill"
            case .subsection: return "list.bullet"
            case .button: return "button.programmable"
            case .inputPopup: return "text.cursor"
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


// MARK: - 预览
struct UIManagerDemos_Previews: PreviewProvider {
    static var previews: some View {
        UIManagerDemos()
            .environmentObject(PopupManager.shared)
            .environmentObject(ToastManager.shared)
    }
}
#endif
#endif
