import SwiftUI

/// 分段器颜色配置
public struct SubsectionColorConfig {
    public struct ColorMode {
        public var activeTextColor: Color
        public var activeBgColor: Color
        public var inactiveTextColor: Color
        public var inactiveBgColor: Color
        
        public init(
            activeTextColor: Color? = nil,
            activeBgColor: Color? = nil,
            inactiveTextColor: Color? = nil,
            inactiveBgColor: Color? = nil
        ) {
            self.activeTextColor = activeTextColor ?? Color(red: 250/255, green: 97/255, blue: 81/255)  // 红色 #FA6151
            self.activeBgColor = activeBgColor ?? Color(.secondarySystemBackground)
            self.inactiveTextColor = inactiveTextColor ?? Color(.secondaryLabel)
            self.inactiveBgColor = inactiveBgColor ?? Color(.systemBackground)
        }
    }
    
    public var lightMode: ColorMode
    public var darkMode: ColorMode
    
    public init(
        lightMode: ColorMode? = nil,
        darkMode: ColorMode? = nil
    ) {
          self.lightMode = lightMode ?? ColorMode(
            activeTextColor: Color(red: 250/255, green: 97/255, blue: 81/255),  // 红色 #FA6151
            activeBgColor:  Color(red: 255/255, green: 255/255, blue: 255/255),  // 白色 #FFFFFF
            inactiveTextColor:  Color(red: 149/255, green: 149/255, blue: 149/255),  // 灰色 #959595
            inactiveBgColor: Color(red: 248/255, green: 248/255, blue: 248/255)  // 浅灰色 #F8F8F8
        )
        
        self.darkMode = darkMode ?? ColorMode(
            activeTextColor: Color(red: 250/255, green: 97/255, blue: 81/255),  // 红色 #FA6151
            activeBgColor:  Color(red: 31/255, green: 31/255, blue: 31/255),  // 深色 #1F1F1F
            inactiveTextColor:  Color(red: 149/255, green: 149/255, blue: 149/255),  // #959595
            inactiveBgColor: Color(red: 21/255, green: 21/255, blue: 21/255)  // 深灰色 #151515
        )
    }
}

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
    public var colorConfig: SubsectionColorConfig
    
    public init(
        title: String = "",
        items: [SubsectionItem],
        current: Int = 0,
        fontSize: CGFloat = 14,
        bold: Bool = false,
        cornerRadius: CGFloat = 8,
        height: CGFloat = 30,
        width: CGFloat? = nil,
        colorConfig: SubsectionColorConfig? = nil
    ) {
        self.title = title
        self.items = items
        self.current = current
        self.fontSize = fontSize
        self.bold = bold
        self.cornerRadius = cornerRadius
        self.height = height
        self.width = width
        self.colorConfig = colorConfig ?? SubsectionColorConfig()
    }
} 