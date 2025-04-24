import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// 主题管理视图模型
public class UIManagerThemeViewModel: ObservableObject {
    // 单例实例
    public static let shared = UIManagerThemeViewModel()
    
    @Published public var isDarkMode: Bool = false
    @Published public var followsSystem: Bool = true
    
    // 初始化方法
    private init() {
        // 默认使用系统外观
        updateThemeBasedOnSystemAppearance()
        printThemeStatus()
        #if canImport(UIKit)
        // 监听应用程序激活事件，每次应用程序从后台恢复时更新主题
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateAppearance),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        #endif
    }
    
    #if canImport(UIKit)
    // 应用激活或者回到前台时更新外观
    @objc private func updateAppearance() {
        if followsSystem {
            updateThemeBasedOnSystemAppearance()
        }
    }
    #endif
    
    // 析构函数，用于移除通知观察者
    deinit {
        #if canImport(UIKit)
        NotificationCenter.default.removeObserver(self)
        #endif
    }
    
    // 暗色主题颜色
    let darkBackgroundColor = Color(red: 0.12, green: 0.12, blue: 0.12)        // 1f1f1f
    let darkPrimaryTextColor = Color(red: 0.91, green: 0.91, blue: 0.91)       // e7e7e9
    let darkSecondaryTextColor = Color(red: 0.18, green: 0.18, blue: 0.18)     // 2e2e2e
    
    // 亮色主题颜色
    let lightBackgroundColor = Color(red: 1.0, green: 1.0, blue: 1.0)          // feffff
    let lightPrimaryTextColor = Color(red: 0.2, green: 0.2, blue: 0.2)         // 333333
    let lightSecondaryTextColor = Color(red: 0.61, green: 0.61, blue: 0.61)    // 9c9c9b
    
    // 主题色
    public var themeColor: Color {
        Color.blue
    }
    
    // 获取当前主题的背景色
    public var backgroundColor: Color {
        isDarkMode ? darkBackgroundColor : lightBackgroundColor
    }
    
    // 获取当前主题的主文字颜色
    public var primaryTextColor: Color {
        isDarkMode ? darkPrimaryTextColor : lightPrimaryTextColor
    }
    
    // 获取当前主题的副文字颜色
    public var secondaryTextColor: Color {
        isDarkMode ? darkSecondaryTextColor : lightSecondaryTextColor
    }
    
    // 切换暗黑模式
    public func toggleDarkMode() {
        followsSystem = false
        isDarkMode.toggle()
    }
    
    // 更新主题以匹配系统外观
    public func updateThemeBasedOnSystemAppearance() {
        if followsSystem {
            #if canImport(UIKit)
            if #available(iOS 12.0, *) {
                let appearance = UITraitCollection.current.userInterfaceStyle
                isDarkMode = appearance == .dark
            }
            #elseif os(macOS)
            if #available(macOS 10.14, *) {
                let appearance = NSAppearance.current.bestMatch(from: [.darkAqua, .aqua])
                isDarkMode = appearance == .darkAqua
            }
            #endif
        }
    }
    
    // 使用SwiftUI的ColorScheme更新主题（在视图中调用）
    public func updateWithColorScheme(_ colorScheme: ColorScheme) {
        // 为了支持预览环境，总是使用传入的colorScheme更新主题
        // 这样在Xcode预览中也能正确显示深色/浅色主题
        isDarkMode = colorScheme == .dark
        
        // 在真机环境中，只有followsSystem为true时才应用系统外观
        #if !PREVIEW && !DEBUG
        if !followsSystem {
            // 如果不跟随系统，则保持用户手动设置的isDarkMode值
            isDarkMode = isDarkMode
        }
        #endif
    }
    
    // 开启或关闭跟随系统外观
    public func toggleFollowsSystem() {
        followsSystem.toggle()
        if followsSystem {
            updateThemeBasedOnSystemAppearance()
        }
    }
    
    /// 打印当前主题状态
    public func printThemeStatus() {
        let themeStatus = isDarkMode ? "深色模式" : "浅色模式"
        let followStatus = followsSystem ? "跟随系统" : "手动设置"
        print("当前主题状态: \(themeStatus), 设置模式: \(followStatus)")
        
        #if canImport(UIKit)
        if #available(iOS 12.0, *) {
            let systemAppearance = UITraitCollection.current.userInterfaceStyle == .dark ? "深色" : "浅色"
            print("系统当前外观: \(systemAppearance)")
        }
        #elseif os(macOS)
        if #available(macOS 10.14, *) {
            if let appearance = NSAppearance.current.bestMatch(from: [.darkAqua, .aqua]) {
                let systemAppearance = appearance == .darkAqua ? "深色" : "浅色"
                print("系统当前外观: \(systemAppearance)")
            }
        }
        #endif
    }
}

// MARK: - 预览支持
#if DEBUG || PREVIEW
public struct UIManagerThemeModifier: ViewModifier {
    @ObservedObject var themeManager: UIManagerThemeViewModel
    @Environment(\.colorScheme) var colorScheme
    
    public init(themeManager: UIManagerThemeViewModel = .shared) {
        self.themeManager = themeManager
    }
    
    public func body(content: Content) -> some View {
        content
            .environmentObject(themeManager)
            .onAppear {
                // 自动更新主题以匹配预览环境的colorScheme
                themeManager.updateWithColorScheme(colorScheme)
            }
            .onChange(of: colorScheme) { newColorScheme in
                themeManager.updateWithColorScheme(newColorScheme)
            }
    }
}

public extension View {
    /// 应用UIManager主题到视图中，确保在预览环境中正确显示
    func withUIManagerTheme(_ themeManager: UIManagerThemeViewModel = .shared) -> some View {
        self.modifier(UIManagerThemeModifier(themeManager: themeManager))
    }
}
#endif 