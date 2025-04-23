import SwiftUI

/// Toast视图
public struct ToastView: View {
    public var toast: ToastData
    
    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: toast.style.icon)
                .foregroundColor(.white)
            
            Text(toast.message)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(toast.style.themeColor.opacity(0.9))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

/// Toast视图修饰器
public struct ToastModifier: ViewModifier {
    @Binding var toast: ToastData?
    @State private var workItem: DispatchWorkItem?
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    if let toast = toast {
                        VStack {
                            ToastView(toast: toast)
                                .padding(.top, 40)
                                .padding(.horizontal, 16)
                            Spacer()
                        }
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.2), value: toast)
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: toast != nil)
                .zIndex(1500)
            )
            .onChange(of: toast) { newValue in
                if newValue != nil {
                    // 取消上一个计时器
                    workItem?.cancel()
                    
                    // 创建新的计时器
                    let task = DispatchWorkItem {
                        withAnimation {
                            self.toast = nil
                        }
                    }
                    
                    workItem = task
                    DispatchQueue.main.asyncAfter(deadline: .now() + (newValue?.duration ?? 2.0), execute: task)
                }
            }
    }
}

/// 全局Toast视图修饰器
public struct ToastViewModifier: ViewModifier {
    @ObservedObject private var toastManager = ToastManager.shared
    
    public func body(content: Content) -> some View {
        content
            .modifier(ToastModifier(toast: $toastManager.currentToast))
    }
}

/// 扩展View以便使用Toast
public extension View {
    func toast(toast: Binding<ToastData?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
    
    /// 便捷方法：显示默认Toast
    func showToast(message: String, style: ToastStyle = .info, duration: Double = 2.0, in toast: Binding<ToastData?>) {
        toast.wrappedValue = ToastData(message: message, style: style, duration: duration)
    }
} 