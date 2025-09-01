import SwiftUI
import UIManager

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            UIManagerDemos()
        }
    }
    
    init() {
        UIManager.initialize()
    }
} 