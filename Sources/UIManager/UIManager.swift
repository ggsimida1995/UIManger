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
    
    /// 初始化 UIManager
    public static func initialize() {
        print("UIManager v\(version) 已初始化")
        print("包含组件: 弹窗、Toast、筛选器、系统组件演示")
    }
    
    /// 清理所有当前显示的弹窗和Toast
    public static func clearAll() {
        popup.closeAll()
        toast.hideCurrentToast()
    }
}

// MARK: - View 扩展
public extension View {
    /// 应用UI组件修饰器（包含弹窗和Toast）
    func withUI() -> some View {
        self.withPopups()
            .withToast()
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
