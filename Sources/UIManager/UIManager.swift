import SwiftUI

/// UIManager - UI管理工具
/// 包含弹窗、Toast、筛选器等组件
public struct UIManager {
    // 版本号
    public static let version = "2.0.0"
    
    // 初始化状态
    private static var isInitialized = false
    
    // 弹窗管理器实例
    public static var popup: PopupManager {
        // 确保在使用前已初始化
        if !isInitialized {
            initialize()
        }
        return PopupManager.shared
    }
    
    // Toast管理器实例
    public static var toast: ToastManager {
        // 确保在使用前已初始化
        if !isInitialized {
            initialize()
        }
        return ToastManager.shared
    }
    
    /// 初始化 UIManager
    public static func initialize() {
        guard !isInitialized else {
            print("UIManager 已经初始化过了")
            return
        }
        
        isInitialized = true
        print("UIManager v\(version) 已初始化")
        print("包含组件: 弹窗、Toast、筛选器、系统组件演示")
    }
    
    /// 清理所有当前显示的弹窗和Toast
    public static func clearAll() {
        popup.closeAll()
        toast.hideCurrentToast()
    }
    
    /// 检查是否已初始化
    public static var initialized: Bool {
        return isInitialized
    }
}

// MARK: - View 扩展
public extension View {
    /// 应用UI组件修饰器（包含弹窗和Toast）
    func withUI() -> some View {
        // 确保在使用前已初始化
        if !UIManager.initialized {
            UIManager.initialize()
        }
        return self.environment(\.popup, PopupManager.shared)
            .environment(\.toastManager, ToastManager.shared)
            .overlay(
                PopupContainer()
                    .allowsHitTesting(false) // 防止弹窗容器拦截触摸事件
            )
            .modifier(ToastViewModifier())
    }
}

// MARK: - SwiftUI App 扩展
public extension SwiftUI.App {
    /// 在 App 启动时初始化 UIManager
    func initializeUIManager() -> some SwiftUI.App {
        UIManager.initialize()
        return self
    }
}
