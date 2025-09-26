import SwiftUI

/// UIManager - UI管理工具
/// 包含弹窗、Toast、筛选器等组件
public struct UIManager {
    // 版本号
    public static let version = "2.0.0"
    
    // 弹窗管理器实例
    public static var popup: PopupManager {
        return PopupManager.shared
    }
    
    // Toast管理器实例
    public static var toast: ToastManager {
        return ToastManager.shared
    }
    
    /// 清理所有当前显示的弹窗和Toast
    public static func clearAll() {
        popup.closeAll()
        toast.hideCurrentToast()
    }
}

// MARK: - View 扩展
public extension View {
    /// 应用弹窗修饰器
    func withPopup() -> some View {
        return self.environment(\.popup, PopupManager.shared)
            .overlay(
                PopupContainer()
                    .allowsHitTesting(true) // 允许弹窗容器接收触摸事件，拦截蒙层点击
            )
    }
    
    /// 应用Toast修饰器
    func withToast() -> some View {
        return self.environment(\.toastManager, ToastManager.shared)
            .modifier(ToastViewModifier())
    }
    
    /// 应用UI组件修饰器（包含弹窗和Toast）
    func withUI() -> some View {
        return self.withPopup()
            .withToast()
    }
}

