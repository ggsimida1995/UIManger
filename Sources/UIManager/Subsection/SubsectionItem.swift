import SwiftUI
import UIKit

/// 颜色模式配置
/// 支持自适应暗黑/浅色模式
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
        self.activeTextColor = activeTextColor ?? Color.primaryButtonText
        self.activeBgColor = activeBgColor ?? Color.backgroundColor
        self.inactiveTextColor = inactiveTextColor ?? Color.secondaryTextColor
        self.inactiveBgColor = inactiveBgColor ?? Color.secondaryBackgroundColor
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
    public var colorConfig: ColorMode
    
    public init(
        title: String = "",
        items: [SubsectionItem],
        current: Int = 0,
        fontSize: CGFloat = 14,
        bold: Bool = false,
        cornerRadius: CGFloat = 5,
        height: CGFloat = 30,
        width: CGFloat? = nil,
        colorConfig: ColorMode? = nil
    ) {
        self.title = title
        self.items = items
        self.current = current
        self.fontSize = fontSize
        self.bold = bold
        self.cornerRadius = cornerRadius
        self.height = height
        self.width = width
        self.colorConfig = colorConfig ?? ColorMode()
    }
} 
