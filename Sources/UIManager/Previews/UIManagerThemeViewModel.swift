import SwiftUI

/// 用于预览的主题管理视图模型
public class UIManagerThemeViewModel: ObservableObject {
    @Published public var isDarkMode: Bool = false
    
    // 主题色
    public var themeColor: Color {
        Color.blue
    }
    
    // 背景色
    public var backgroundColor: Color {
        isDarkMode ? Color.black : Color.white
    }
    
    // 主要文本色
    public var primaryTextColor: Color {
        isDarkMode ? Color.white : Color.black
    }
    
    // 次要文本色
    public var secondaryTextColor: Color {
        isDarkMode ? Color.gray : Color.gray
    }
    
    // 切换暗黑模式
    public func toggleDarkMode() {
        isDarkMode.toggle()
    }
} 