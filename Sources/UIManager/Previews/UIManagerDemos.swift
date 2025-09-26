import SwiftUI

/// UIManager 所有组件的演示主界面
public struct UIManagerDemos: View {
    public init() {}
    
    public var body: some View {
        NavigationView {
            List {
                Section("筛选组件") {
                    NavigationLink("简化筛选器", destination: SimpleFilterDemo())
                }
                
                Section("弹窗组件") {
                    NavigationLink("弹窗演示", destination: PopupDemo().withUI())
                }
                
                Section("Toast 提示") {
                    NavigationLink("Toast 演示", destination: ToastDemo())
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
