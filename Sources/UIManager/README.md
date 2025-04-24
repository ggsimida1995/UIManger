# UIManager 主题使用指南

## 在预览中正确显示主题

如果你在 Xcode 预览中使用 UIManager 主题，但颜色无法正确显示（例如深色模式下仍然显示浅色主题），请按照以下步骤解决：

### 方法一：使用 withUIManagerTheme 修饰器（推荐）

在预览中，使用提供的 `withUIManagerTheme()` 修饰器来确保主题正确显示：

```swift
struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // 浅色模式预览
            MyView()
                .withUIManagerTheme()
                .preferredColorScheme(.light)
            
            // 深色模式预览
            MyView()
                .withUIManagerTheme()
                .preferredColorScheme(.dark)
        }
    }
}
```

### 方法二：手动设置环境对象和主题更新

如果不想使用修饰器，可以手动设置：

```swift
struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MyView()
                .environmentObject(UIManagerThemeViewModel.shared)
                .preferredColorScheme(.light)
                .onAppear {
                    // 根据 ColorScheme 更新主题
                    UIManagerThemeViewModel.shared.updateWithColorScheme(.light)
                }
            
            MyView()
                .environmentObject(UIManagerThemeViewModel.shared)
                .preferredColorScheme(.dark)
                .onAppear {
                    // 根据 ColorScheme 更新主题
                    UIManagerThemeViewModel.shared.updateWithColorScheme(.dark)
                }
        }
    }
}
```

## 在应用中使用主题

在主应用中设置主题管理器：

```swift
@main
struct MyApp: App {
    // 初始化主题管理器
    @StateObject private var themeManager = UIManagerThemeViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .onChange(of: colorScheme) { newColorScheme in
                    themeManager.updateWithColorScheme(newColorScheme)
                }
        }
    }
}
```

在视图中使用主题颜色：

```swift
struct ContentView: View {
    @EnvironmentObject private var themeManager: UIManagerThemeViewModel
    
    var body: some View {
        Text("Hello, World!")
            .foregroundColor(themeManager.primaryTextColor)
            .padding()
            .background(themeManager.backgroundColor)
    }
}
```

## 故障排除

如果预览中的主题仍不正确，请尝试：

1. 清除 Xcode 的衍生数据（Derived Data）
2. 重启 Xcode
3. 确保在视图的 `onAppear` 中调用 `updateWithColorScheme`
4. 检查是否正确设置了 `environmentObject` 