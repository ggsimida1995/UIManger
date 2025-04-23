import SwiftUI
import UIManager

@main
struct DemoApp: App {
    @StateObject private var themeManager = UIManagerDemos.UIManagerThemeViewModel()
    
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