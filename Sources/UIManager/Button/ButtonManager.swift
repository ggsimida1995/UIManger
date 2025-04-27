import SwiftUI

/// 按钮类型
public enum ButtonType {
    case info
    case primary
    case error
    case warning
    case success
    
    var themeColor: Color {
        switch self {
        case .info:
            return .blue.opacity(0.8)
        case .primary:
            return .blue
        case .error:
            return .red
        case .warning:
            return .orange
        case .success:
            return .green
        }
    }
    
    var textColor: Color {
        switch self {
        case .info, .primary, .error, .warning, .success:
            return .white
        }
    }
}

/// 按钮形状
public enum ButtonShape {
    case normal
    case circle
    
    var cornerRadius: CGFloat {
        switch self {
        case .normal:
            return 8
        case .circle:
            return 999
        }
    }
}

/// 按钮尺寸
public enum ButtonSize {
    case mini
    case normal
    case large
    
    var height: CGFloat {
        switch self {
        case .mini:
            return 28
        case .normal:
            return 44
        case .large:
            return 56
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .mini:
            return 12
        case .normal:
            return 16
        case .large:
            return 18
        }
    }
}

/// 按钮数据模型
public struct ButtonData: Equatable {
    public var title: String
    public var type: ButtonType
    public var plain: Bool
    public var hairline: Bool
    public var disabled: Bool
    public var loading: Bool
    public var loadingText: String?
    public var icon: String?
    public var shape: ButtonShape
    public var color: LinearGradient?
    public var size: ButtonSize
    public var action: () -> Void
    
    public init(
        title: String,
        type: ButtonType = .info,
        plain: Bool = false,
        hairline: Bool = true,
        disabled: Bool = false,
        loading: Bool = false,
        loadingText: String? = nil,
        icon: String? = nil,
        shape: ButtonShape = .normal,
        color: LinearGradient? = nil,
        size: ButtonSize = .normal,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.type = type
        self.plain = plain
        self.hairline = hairline
        self.disabled = disabled
        self.loading = loading
        self.loadingText = loadingText
        self.icon = icon
        self.shape = shape
        self.color = color
        self.size = size
        self.action = action
    }
    
    // 实现Equatable协议，忽略action闭包
    public static func == (lhs: ButtonData, rhs: ButtonData) -> Bool {
        return lhs.title == rhs.title &&
            lhs.type == rhs.type &&
            lhs.plain == rhs.plain &&
            lhs.hairline == rhs.hairline &&
            lhs.disabled == rhs.disabled &&
            lhs.loading == rhs.loading &&
            lhs.loadingText == rhs.loadingText &&
            lhs.icon == rhs.icon &&
            lhs.shape == rhs.shape &&
            lhs.size == rhs.size
    }
}

/// 按钮管理器 - 全局单例
public class ButtonManager: ObservableObject {
    /// 当前按钮状态
    @Published public var currentButton: ButtonData?
    
    /// 单例实例
    public static let shared = ButtonManager()
    
    private init() {}
    
    /// 创建信息按钮
    public func createInfoButton(title: String, action: @escaping () -> Void) {
        currentButton = ButtonData(title: title, type: .info, action: action)
    }
    
    /// 创建主要按钮
    public func createPrimaryButton(title: String, action: @escaping () -> Void) {
        currentButton = ButtonData(title: title, type: .primary, action: action)
    }
    
    /// 创建成功按钮
    public func createSuccessButton(title: String, action: @escaping () -> Void) {
        currentButton = ButtonData(title: title, type: .success, action: action)
    }
    
    /// 创建警告按钮
    public func createWarningButton(title: String, action: @escaping () -> Void) {
        currentButton = ButtonData(title: title, type: .warning, action: action)
    }
    
    /// 创建错误按钮
    public func createErrorButton(title: String, action: @escaping () -> Void) {
        currentButton = ButtonData(title: title, type: .error, action: action)
    }
}

// 创建一个环境键，用于访问ButtonManager
struct ButtonManagerKey: EnvironmentKey {
    static let defaultValue = ButtonManager.shared
}

// 扩展EnvironmentValues，方便在SwiftUI环境中访问ButtonManager
public extension EnvironmentValues {
    var buttonManager: ButtonManager {
        get { self[ButtonManagerKey.self] }
        set { self[ButtonManagerKey.self] = newValue }
    }
}

// 扩展View，添加方便的方法用于创建按钮
public extension View {
    /// 便捷方法：创建信息按钮
    func uiInfoButton(_ title: String, action: @escaping () -> Void) {
        ButtonManager.shared.createInfoButton(title: title, action: action)
    }
    
    /// 便捷方法：创建主要按钮
    func uiPrimaryButton(_ title: String, action: @escaping () -> Void) {
        ButtonManager.shared.createPrimaryButton(title: title, action: action)
    }
    
    /// 便捷方法：创建成功按钮
    func uiSuccessButton(_ title: String, action: @escaping () -> Void) {
        ButtonManager.shared.createSuccessButton(title: title, action: action)
    }
    
    /// 便捷方法：创建警告按钮
    func uiWarningButton(_ title: String, action: @escaping () -> Void) {
        ButtonManager.shared.createWarningButton(title: title, action: action)
    }
    
    /// 便捷方法：创建错误按钮
    func uiErrorButton(_ title: String, action: @escaping () -> Void) {
        ButtonManager.shared.createErrorButton(title: title, action: action)
    }
} 