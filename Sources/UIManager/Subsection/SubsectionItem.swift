import SwiftUI

/// 分段器选项
public struct SubsectionItem: Identifiable {
    public let id = UUID()
    public let title: String
    public let value: Any
    
    public init(title: String, value: Any) {
        self.title = title
        self.value = value
    }
}

/// 分段器配置
public struct SubsectionConfig {
    public var title: String
    public var items: [SubsectionItem]
    public var current: Int
    public var fontSize: CGFloat
    public var bold: Bool
    public var cornerRadius: CGFloat
    public var height: CGFloat
    public var width: CGFloat?
    public var activeTextColor: Color
    public var activeBgColor: Color
    public var inactiveTextColor: Color
    public var inactiveBgColor: Color
    
    public init(
        title: String = "",
        items: [SubsectionItem],
        current: Int = 0,
        fontSize: CGFloat = 14,
        bold: Bool = false,
        cornerRadius: CGFloat = 8,
        height: CGFloat = 30,
        width: CGFloat? = nil,
        activeTextColor: Color? = nil,
        activeBgColor: Color? = nil,
        inactiveTextColor: Color? = nil,
        inactiveBgColor: Color? = nil
    ) {
        self.title = title
        self.items = items
        self.current = current
        self.fontSize = fontSize
        self.bold = bold
        self.cornerRadius = cornerRadius
        self.height = height
        self.width = width
        
        // 根据系统主题设置颜色
        let isDark = UITraitCollection.current.userInterfaceStyle == .dark
        
        // 活跃状态文字颜色（深色和浅色模式相同）
        self.activeTextColor = activeTextColor ?? Color(red: 250/255, green: 97/255, blue: 81/255)  // 红色 #FA6151
        
        // 活跃状态背景颜色
        self.activeBgColor = activeBgColor ?? (isDark ? 
            Color(red: 31/255, green: 31/255, blue: 31/255) :   // 深色模式：#1F1F1F
            Color(red: 255/255, green: 255/255, blue: 255/255)) // 浅色模式：白色
        
        // 非活跃状态文字颜色（深色和浅色模式相同）
        self.inactiveTextColor = inactiveTextColor ?? Color(red: 180/255, green: 180/255, blue: 180/255)  // 浅灰色 #B4B4B4
        
        // 非活跃状态背景颜色
        self.inactiveBgColor = inactiveBgColor ?? (isDark ? 
            Color(red: 21/255, green: 21/255, blue: 21/255) :    // 深色模式：#151515
            Color(red: 248/255, green: 248/255, blue: 248/255))  // 浅色模式：浅灰色
    }
} 