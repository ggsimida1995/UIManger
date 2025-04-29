import SwiftUI

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