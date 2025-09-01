import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// 说明：iOS 没有“系统自带 Toast”控件，系统提供的是 Alert / ConfirmationDialog。
/// 这个 Demo 展示系统原生的 Alert 和 ConfirmationDialog 作为对比参考。
public struct SystemToastDemo: View {
    @State private var showAlert: Bool = false
    @State private var showDialog: Bool = false

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("系统默认提示 Demo")
                .font(.headline)

            Text("iOS 无内置 Toast 控件。系统提供的原生方案是 Alert 和 ConfirmationDialog。")
                .font(.footnote)
                .foregroundColor(.secondary)

            HStack(spacing: 12) {
                Button("显示系统 Alert") { showAlert = true }
                    .buttonStyle(.borderedProminent)

                Button("显示 ConfirmationDialog") { showDialog = true }
                    .buttonStyle(.bordered)

#if canImport(UIKit)
                Button("触发系统触感反馈") {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                }
                .buttonStyle(.bordered)
#endif
            }

            Spacer()
        }
        .padding()
        .alert("操作成功", isPresented: $showAlert, actions: {
            Button("确定", role: .cancel) {}
        }, message: {
            Text("这是系统 Alert，用于提示与确认。")
        })
        .confirmationDialog("更多操作", isPresented: $showDialog, titleVisibility: .automatic) {
            Button("操作一") {}
            Button("操作二") {}
            Button("取消", role: .cancel) {}
        } message: {
            Text("这是系统 ConfirmationDialog（原 ActionSheet）。")
        }
    }
}

#if DEBUG
#Preview("系统默认提示 Demo") {
    SystemToastDemo()
}
#endif


