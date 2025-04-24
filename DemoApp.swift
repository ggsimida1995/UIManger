import SwiftUI
import UIManager

@main
struct DemoApp: App {
    // 使用共享的主题管理器实例
    @StateObject private var themeManager = UIManagerThemeViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            UIManagerDemos()
                .environmentObject(themeManager)
                .accentColor(themeManager.themeColor)
        }
    }
    
    init() {
        UIManager.initialize()
    }
} 