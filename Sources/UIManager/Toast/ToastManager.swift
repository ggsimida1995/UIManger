import SwiftUI

/// Toast 显示样式
public enum ToastStyle {
    case info
    case success
    case error
    case warning
    
    var themeColor: Color {
        switch self {
        case .info:
            return Color.primaryColor
        case .success:
            return Color.successColor
        case .error:
            return Color.errorColor
        case .warning:
            return Color.warningColor
        }
    }
    
    var icon: String {
        switch self {
        case .info:
            return "info.circle.fill"
        case .success:
            return "checkmark.circle.fill"
        case .error:
            return "xmark.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        }
    }
}

/// Toast 数据模型
public struct ToastData: Equatable {
    public var message: String
    public var style: ToastStyle
    public var duration: Double = 2.0
    
    public init(message: String, style: ToastStyle, duration: Double = 2.0) {
        self.message = message
        self.style = style
        self.duration = duration
    }
}

/// Toast管理器 - 全局单例
public class ToastManager: ObservableObject {
    /// 当前显示的Toast
    @Published public var currentToast: ToastData?
    
    /// 单例实例
    public static let shared = ToastManager()
    
    private init() {}
    
    /// 显示一个普通Toast
    public func showToast(message: String, duration: Double = 2.0) {
        DispatchQueue.main.async {
            self.currentToast = ToastData(message: message, style: .info, duration: duration)
        }
    }
    
    /// 显示一个成功Toast
    public func showSuccess(message: String, duration: Double = 2.0) {
        DispatchQueue.main.async {
            self.currentToast = ToastData(message: message, style: .success, duration: duration)
        }
    }
    
    /// 显示一个错误Toast
    public func showError(message: String, duration: Double = 2.0) {
        DispatchQueue.main.async {
            self.currentToast = ToastData(message: message, style: .error, duration: duration)
        }
    }
    
    /// 显示一个警告Toast
    public func showWarning(message: String, duration: Double = 2.0) {
        DispatchQueue.main.async {
            self.currentToast = ToastData(message: message, style: .warning, duration: duration)
        }
    }
    
    /// 隐藏当前显示的 Toast
    public func hideCurrentToast() {
        DispatchQueue.main.async {
            self.currentToast = nil
        }
    }
}

// 创建一个环境键，用于访问ToastManager
struct ToastManagerKey: EnvironmentKey {
    static let defaultValue = ToastManager.shared
}

// 扩展EnvironmentValues，方便在SwiftUI环境中访问ToastManager
public extension EnvironmentValues {
    var toastManager: ToastManager {
        get { self[ToastManagerKey.self] }
        set { self[ToastManagerKey.self] = newValue }
    }
}
