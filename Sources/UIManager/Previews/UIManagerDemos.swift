import SwiftUI

/// UIManager 所有组件的演示主界面
public struct UIManagerDemos: View {
    public init() {}
    
    public var body: some View {
        NavigationView {
            List {
                Section("筛选组件") {
                    NavigationLink("多按钮筛选器", destination: MultiButtonFilterDemo())
                }
                
                Section("弹窗组件") {
                    NavigationLink("弹窗演示", destination: PopupPreview())
                   
                }
                
                Section("Toast 提示") {
                    NavigationLink("Toast 演示", destination: ToastDemo())
                }
                
                Section("系统组件对比") {
                    NavigationLink("系统输入弹窗", destination: SystemInputAlertDemo())
                    NavigationLink("系统菜单", destination: SystemLikeMenuDemo())
                    NavigationLink("系统分段器", destination: SystemSegmentedDemo())
                    NavigationLink("系统Toast对比", destination: SystemToastDemo())
                }
            }
            .navigationTitle("UIManager")
        }
    }
}

#if DEBUG
#Preview("UIManager Demos") {
    UIManagerDemos()
}
#endif
