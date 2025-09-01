import SwiftUI

/// UIManager Toast 演示
public struct ToastDemo: View {
    @Environment(\.toastManager) private var toastManager
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            Text("UIManager Toast 演示")
                .font(.headline)
            
            VStack(spacing: 16) {
                Button("显示信息 Toast") {
                    toastManager.showToast(message: "这是一个信息提示")
                }
                .buttonStyle(.bordered)
                
                Button("显示成功 Toast") {
                    toastManager.showSuccess(message: "操作成功完成！")
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                
                Button("显示错误 Toast") {
                    toastManager.showError(message: "操作失败，请重试")
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                
                Button("显示警告 Toast") {
                    toastManager.showWarning(message: "请注意安全设置")
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                
                Button("显示长文本 Toast") {
                    toastManager.showToast(message: "这是一个比较长的提示信息，用来测试多行文本的显示效果", duration: 3.0)
                }
                .buttonStyle(.bordered)
                
                Button("隐藏当前 Toast") {
                    toastManager.hideCurrentToast()
                }
                .buttonStyle(.bordered)
                .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .withToast() // 添加 Toast 支持
    }
}

#if DEBUG
#Preview("Toast Demo") {
    ToastDemo()
}
#endif
