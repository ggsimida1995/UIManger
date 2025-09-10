import SwiftUI

/// Toast视图
public struct ToastView: View {
    public var toast: ToastData
    
    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: toast.style.icon)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
            
            Text(toast.message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(toast.style.themeColor)
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
        )
        .transition(.asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .opacity.combined(with: .scale(scale: 0.95))
        ))
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
                                .padding(.top, 50)
                                .padding(.horizontal, 20)
                            Spacer()
                        }
                        .transition(.opacity)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: toast)
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: toast != nil)
                .zIndex(2000)
            )
            .onChange(of: toast) { _ , newValue in
                if newValue != nil {
                    // 取消上一个计时器
                    workItem?.cancel()
                    
                    // 创建新的计时器
                    let task = DispatchWorkItem {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
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
