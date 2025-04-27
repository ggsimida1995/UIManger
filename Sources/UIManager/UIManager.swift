import SwiftUI

/// UIManager 是一个集成弹窗和提示系统的UI管理工具
public struct UIManager {
    // 版本号
    public static let version = "1.0.0"
    
    // 内部单例实例
    private static let shared = UIManager()
    
    // Toast管理器实例
    public static var toastManager: ToastManager {
        return ToastManager.shared
    }
    
    // 弹窗管理器实例
    public static var popupManager: PopupManager {
        return PopupManager.shared
    }
    
    /// 初始化 UIManager（在 App 启动时调用）
    public static func initialize() {
        // 未来可能会添加初始化代码
        print("UIManager v\(version) 已初始化")
    }
    
    /// 清理所有当前显示的 UI 组件
    public static func clearAll() {
        popupManager.closeAllPopups()
        toastManager.hideCurrentToast()
    }

    /// 通过uuid关闭指定的弹窗
    public static func closePopup(id: UUID) {
        popupManager.closePopup(id: id)
    }
}

// MARK: - View 扩展
public extension View {
    /// 应用所有 UI 组件修饰器
    func withUIComponents() -> some View {
        self.withPopups().withToast()
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
