import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public extension Color {
    // MARK: - 主题色系
    
    /// 主题色
    static var primaryColor: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)  // 深色模式蓝色
            : UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)  // 浅色模式蓝色
        })
    }
    
    /// 次要主题色
    static var secondaryColor: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 10/255, green: 132/255, blue: 255/255, alpha: 1)  // 深色模式浅蓝色
            : UIColor(red: 10/255, green: 132/255, blue: 255/255, alpha: 1)  // 浅色模式浅蓝色
        })
    }
    
    // MARK: - 功能色系
    
    /// 成功色
    static var successColor: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1)  // 深色模式绿色
            : UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1)  // 浅色模式绿色
        })
    }
    
    /// 警告色
    static var warningColor: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)  // 深色模式黄色
            : UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)  // 浅色模式黄色
        })
    }
    
    /// 错误色
    static var errorColor: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)  // 深色模式红色
            : UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)  // 浅色模式红色
        })
    }
    
    // MARK: - 文本色系
    
    /// 主要文本颜色
    static var textColor: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor.black
        })
    }
    
    /// 次要文本颜色
    static var secondaryTextColor: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor.gray
            : UIColor.darkGray
        })
    }
    
    /// 占位符文本颜色
    static var placeholderTextColor: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
            : UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
        })
    }
    
    // MARK: - 背景色系
    
    /// 主要背景色
    static var backgroundColor: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)  // 深色模式背景
            : UIColor.white  // 浅色模式背景
        })
    }
    
    /// 次要背景色
    static var secondaryBackgroundColor: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1)  // 深色模式次要背景
            : UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)  // 浅色模式次要背景
        })
    }
    
    // MARK: - 分割线和边框
    
    /// 分割线颜色
    static var separatorColor: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)  // 深色模式分割线
            : UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)  // 浅色模式分割线
        })
    }
    
    /// 边框颜色
    static var borderColor: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)  // 深色模式边框
            : UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)  // 浅色模式边框
        })
    }
    
    // MARK: - 遮罩层
    
    /// 遮罩层颜色
    static var overlayColor: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor.black.withAlphaComponent(0.5)  // 深色模式遮罩
            : UIColor.black.withAlphaComponent(0.3)  // 浅色模式遮罩
        })
    }
    
    static var customBackground: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)  // 深灰 #1C1C1C
            : UIColor.white
        })
    }
    
    // MARK: - 按钮颜色
    
    /// 主要按钮背景色
    static var primaryButtonBackground: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 50/255.0, green: 35/255.0, blue: 34/255.0, alpha: 1.0)  // 深色模式
                : UIColor(red: 255/255.0, green: 239/255.0, blue: 238/255.0, alpha: 1.0)  // 浅色模式
        })
    }
    
    /// 主要按钮文字颜色
    static var primaryButtonText: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 247/255.0, green: 97/255.0, blue: 80/255.0, alpha: 1.0)  // 深色模式
                : UIColor(red: 249/255.0, green: 99/255.0, blue: 82/255.0, alpha: 1.0)  // 浅色模式
        })
    }
    
    /// 次要按钮背景色
    static var secondaryButtonBackground: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 46/255.0, green: 46/255.0, blue: 46/255.0, alpha: 1.0)  // 深色模式
                : UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)  // 浅色模式
        })
    }
    
    /// 次要按钮文字颜色
    static var secondaryButtonText: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 228/255.0, green: 228/255.0, blue: 230/255.0, alpha: 1.0)  // 深色模式
                : UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)  // 浅色模式
        })
    }
} 
