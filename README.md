# UIManager

UIManager 是一个用于 SwiftUI 的轻量级用户界面组件管理库，它集成了弹窗和提示系统，可以帮助您更轻松地构建现代化、美观的用户界面。

## 功能特性

- **全新设计的界面**：现代化、美观的用户界面，支持亮色/暗色模式
- **Popup 弹窗系统**：
  - 支持多种位置：中心、顶部、底部、左侧、右侧以及自定义位置
  - 强大的动画支持：缩放、滑动、淡入淡出等多种过渡效果
  - 完全自定义的尺寸、圆角、阴影和内容
  - 支持关闭按钮自定义和点击外部关闭
- **Toast 提示系统**：
  - 支持信息、成功、警告和错误四种类型的轻量级提示
  - 可自定义持续时间和样式
- **单例管理器**：使用全局单例管理所有UI组件，避免状态混乱
- **完整的环境集成**：通过SwiftUI环境变量轻松访问所有管理器
- **链式API**：简洁明了的API设计，易于使用和集成

## 最新更新 (v1.0.0)

- 重新设计UI组件预览界面，支持单独导航到各个演示页面
- 优化弹窗背景色，提高文本可见性，支持深色/浅色模式
- 增强弹窗内容的样式和布局，提供更好的用户体验
- 新增动画和过渡效果的自定义选项
- 改进组件API，使其更加易用和灵活
- 优化项目结构，提高代码质量和可维护性

## 项目结构

```
UIManager/
├── Sources/
│   └── UIManager/
│       ├── UIManager.swift              # 核心管理类
│       ├── Extensions/                  # 扩展功能
│       │   └── View+Extensions.swift    # View扩展
│       ├── Popup/                       # 弹窗相关组件
│       │   ├── PopupManager.swift       # 弹窗管理器
│       │   ├── PopupTypes.swift         # 弹窗类型和配置
│       │   └── PopupViews.swift         # 弹窗视图
│       ├── Toast/                       # Toast相关组件
│       │   ├── ToastManager.swift       # Toast管理器
│       │   └── ToastView.swift          # Toast视图
│       └── Previews/                    # 预览和演示组件
│           ├── UIManagerDemos.swift     # 组件演示入口
│           ├── UIManagerThemeViewModel.swift # 主题管理器
│           └── PopupDemo/               # 弹窗演示
│               ├── PreviewPopupDemo.swift   # 弹窗演示视图
│               ├── PopupDemoHelpers.swift   # 弹窗演示辅助方法
│               ├── PopupDemoModels.swift    # 弹窗演示模型
│               └── PopupDemoAnimations.swift # 弹窗动画
└── DemoApp.swift                         # 示例应用入口
```

## 要求

- iOS 15.0+
- Swift 5.5+
- Xcode 13.0+

## 安装

### Swift Package Manager

在 Xcode 中，选择 File > Swift Packages > Add Package Dependency，输入仓库 URL：

```
https://github.com/ggsimida1995/UiManager.git
```

或者，在您的 `Package.swift` 文件中添加：

```swift
dependencies: [
    .package(url: "https://github.com/ggsimida1995/UiManager.git", from: "1.0.0")
]
```

## 快速开始

### 初始化

在 SwiftUI App 中初始化 UIManager：

```swift
@main
struct MyApp: App {
    init() {
        // 初始化 UIManager
        UIManager.initialize()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withUIComponents() // 同时应用 Toast 和 Popup 修饰器
        }
    }
}
```

### 显示 Toast

```swift
struct ContentView: View {
    @Environment(\.toastManager) var toastManager
    
    var body: some View {
        VStack(spacing: 20) {
            Button("显示信息提示") {
                toastManager.showToast(message: "这是一条信息提示")
            }
            
            Button("显示成功提示") {
                toastManager.showSuccess(message: "操作成功完成")
            }
            
            Button("显示警告提示") {
                toastManager.showWarning(message: "请注意，这是一个警告")
            }
            
            Button("显示错误提示") {
                toastManager.showError(message: "发生错误，请重试")
            }
            
            Button("显示自定义时长提示") {
                toastManager.showToast(message: "这条提示会显示5秒", duration: 5.0)
            }
        }
        .padding()
    }
}

// 便捷扩展方法
extension View {
    func showToast(_ message: String, duration: Double = 2.0) {
        ToastManager.shared.showToast(message: message, duration: duration)
    }
}
```

### 显示弹窗

```swift
struct ContentView: View {
    @Environment(\.popupManager) var popupManager
    
    var body: some View {
        VStack(spacing: 20) {
            // 基本居中弹窗
            Button("显示中心弹窗") {
                popupManager.show {
                    VStack {
                        Text("这是一个居中弹窗")
                            .font(.headline)
                            .padding()
                        
                        Button("关闭") {
                            // 获取最上方弹窗ID并关闭
                            if let popup = popupManager.popup(at: popupManager.popupCount - 1) {
                                popupManager.closePopup(id: popup.id)
                            }
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                }
            }
            
            // 顶部弹窗
            Button("显示顶部弹窗") {
                popupManager.show(
                    content: {
                        Text("顶部提示信息")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                    },
                    position: .top
                )
            }
            
            // 底部弹窗，带关闭按钮
            Button("显示底部弹窗") {
                let config = PopupBaseConfig(
                    shadowEnabled: true,
                    showCloseButton: true,
                    closeButtonPosition: .topTrailing
                )
                
                popupManager.show(
                    content: {
                        VStack {
                            Text("底部操作菜单")
                                .font(.headline)
                                .padding(.top)
                            
                            Divider()
                            
                            Button("选项1") {
                                // 处理操作
                            }
                            .padding()
                            
                            Button("选项2") {
                                // 处理操作
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    },
                    position: .bottom,
                    config: config
                )
            }
        }
        .padding()
    }
}
```

### 高级弹窗配置

```swift
// 创建自定义配置
let config = PopupBaseConfig(
    backgroundColor: Color.black.opacity(0.8),
    cornerRadius: 16,
    shadowEnabled: true,
    closeOnTapOutside: true,
    showCloseButton: true,
    closeButtonPosition: .topTrailing,
    closeButtonStyle: .circular,
    animation: .spring(response: 0.3, dampingFraction: 0.8),
    offsetY: 0,
    onClose: {
        print("弹窗已关闭")
    }
)

// 使用自定义过渡动画
let transition = AnyTransition.asymmetric(
    insertion: .scale(scale: 0.8, anchor: .center).combined(with: .opacity),
    removal: .scale(scale: 0.8, anchor: .center).combined(with: .opacity)
)

let customConfig = PopupBaseConfig(
    backgroundColor: Color.white.opacity(0.95),
    cornerRadius: 16,
    animation: .easeInOut(duration: 0.5),
    customTransition: transition
)

// 显示弹窗
popupManager.show(
    content: {
        // 弹窗内容...
    },
    position: .center,
    width: 300,
    height: 400,
    config: customConfig
)
```

## 组件预览

UIManager提供了完整的组件预览和演示界面，帮助您了解各种组件的效果和使用方法。您可以通过以下方式访问：

```swift
struct DemoView: View {
    var body: some View {
        UIManagerDemos()
    }
}
```

## 自定义主题

UIManager支持自定义主题，可以轻松适配您的应用风格：

```swift
// 创建自定义主题
let customTheme = UIManagerThemeViewModel()
customTheme.isDarkMode = true // 强制使用暗色模式

// 在视图中使用
YourView()
    .environmentObject(customTheme)
    .withUIComponents()
```

## 许可证

UIManager 使用 MIT 许可证。详情请参阅 [LICENSE](LICENSE) 文件。
