import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public extension Color {
    // MARK: - 主题色系
    
    /// 主题色
    static var primaryColor: Color {
        Color(
            light: Color(red: 0/255, green: 122/255, blue: 255/255),      // 浅色模式蓝色
            dark: Color(red: 10/255, green: 132/255, blue: 255/255)       // 深色模式浅蓝色
        )
    }
    
    /// 成功色
    static var successColor: Color {
        Color(
            light: Color(red: 52/255, green: 199/255, blue: 89/255),      // 浅色模式绿色
            dark: Color(red: 52/255, green: 199/255, blue: 89/255)        // 深色模式绿色
        )
    }
    
    // MARK: - 文本色系
    
    /// 主要文本颜色
    static var textColor: Color {
        Color(
            light: Color.black,                                           // 浅色模式黑色
            dark: Color.white                                             // 深色模式白色
        )
    }
    
    /// 次要文本颜色
    static var secondaryTextColor: Color {
        Color(
            light: Color(red: 0.4, green: 0.4, blue: 0.4),              // 浅色模式深灰
            dark: Color(red: 0.7, green: 0.7, blue: 0.7)                // 深色模式浅灰
        )
    }
    
    // MARK: - 背景色系
    
    /// 主要背景色
    static var backgroundColor: Color {
        Color(
            light: Color.white,                                           // 浅色模式白色
            dark: Color(red: 28/255, green: 28/255, blue: 28/255)        // 深色模式深灰
        )
    }
    
    /// 次要背景色
    static var secondaryBackgroundColor: Color {
        Color(
            light: Color(red: 245/255, green: 245/255, blue: 245/255),   // 浅色模式浅灰
            dark: Color(red: 44/255, green: 44/255, blue: 44/255)        // 深色模式中灰
        )
    }
    
    // MARK: - 分割线和边框
    
    /// 分割线颜色
    static var separatorColor: Color {
        Color(
            light: Color(red: 200/255, green: 200/255, blue: 200/255),   // 浅色模式浅灰
            dark: Color(red: 60/255, green: 60/255, blue: 60/255)        // 深色模式深灰
        )
    }
    
    /// 边框颜色
    static var borderColor: Color {
        Color(
            light: Color(red: 220/255, green: 220/255, blue: 220/255),   // 浅色模式浅灰
            dark: Color(red: 70/255, green: 70/255, blue: 70/255)        // 深色模式深灰
        )
    }
    
    // MARK: - 遮罩层
    
    /// 遮罩层颜色
    static var overlayColor: Color {
        Color(
            light: Color.black.opacity(0.3),                             // 浅色模式半透明黑色
            dark: Color.black.opacity(0.5)                               // 深色模式半透明黑色
        )
    }
    
    // MARK: - 按钮颜色
    
    /// 主要按钮文字颜色
    static var primaryButtonText: Color {
        Color(
            light: Color(red: 249/255, green: 99/255, blue: 82/255),     // 浅色模式橙红色
            dark: Color(red: 247/255, green: 97/255, blue: 80/255)       // 深色模式橙红色
        )
    }
    
    /// 次要按钮背景色
    static var secondaryButtonBackground: Color {
        Color(
            light: Color(red: 247/255, green: 247/255, blue: 247/255),   // 浅色模式浅灰
            dark: Color(red: 46/255, green: 46/255, blue: 46/255)        // 深色模式深灰
        )
    }
    
    /// 次要按钮文字颜色
    static var secondaryButtonText: Color {
        Color(
            light: Color(red: 51/255, green: 51/255, blue: 51/255),      // 浅色模式深灰
            dark: Color(red: 228/255, green: 228/255, blue: 230/255)     // 深色模式浅灰
        )
    }
    
    /// 错误颜色
    static var errorColor: Color {
        Color(
            light: Color(red: 255/255, green: 59/255, blue: 48/255),     // 浅色模式红色
            dark: Color(red: 255/255, green: 69/255, blue: 58/255)       // 深色模式红色
        )
    }
    
    /// 警告颜色
    static var warningColor: Color {
        Color(
            light: Color(red: 255/255, green: 149/255, blue: 0/255),     // 浅色模式橙色
            dark: Color(red: 255/255, green: 159/255, blue: 10/255)      // 深色模式橙色
        )
    }
}

// MARK: - 辅助扩展用于支持深浅色模式
private extension Color {
    init(light: Color, dark: Color) {
        #if canImport(UIKit)
        self = Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
        #else
        // macOS 使用 NSColor
        self = light // 在macOS上暂时使用浅色模式颜色
        #endif
    }
}
