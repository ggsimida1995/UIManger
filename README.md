# UIManager

UIManager 是一个用于 SwiftUI 的轻量级用户界面组件管理库，它集成了弹窗和提示系统，可以帮助您更轻松地构建现代化、美观的用户界面。

## 功能特性

- **Toast 提示系统**：提供信息、成功和错误三种类型的轻量级提示
- **弹窗系统**：灵活的弹窗系统，支持多种位置和样式
- **侧边栏菜单**：支持从左侧或右侧滑出的菜单
- **底部操作表**：类似于 iOS 原生的动作表
- **统一的 API**：简洁明了的 API 设计，易于使用
- **完整的自定义选项**：可以自定义外观、动画和行为

## 最新更新

- 优化项目结构，移除未使用的组件文件
- 改进内部实现，提高性能和稳定性
- 更新示例代码，更好地展示组件用法

## 项目结构

```
UIManager/
├── Sources/
│   └── UIManager/
│       ├── UIManager.swift          # 核心管理类
│       ├── Popup/                   # 弹窗相关组件
│       │   ├── PopupManager.swift   # 弹窗管理器
│       │   └── PopupViews.swift     # 基础弹窗视图
│       ├── Toast/                   # Toast相关组件
│       │   ├── ToastManager.swift   # Toast管理器
│       │   └── ToastView.swift      # Toast视图
│       └── Previews/                # 预览和演示组件
│           └── UIManagerDemos.swift # 完整组件演示
└── DemoApp.swift                    # 示例应用入口
```

## 要求

- iOS 16.0+
- Swift 5.7+
- Xcode 14.0+

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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withUIComponents() // 同时应用 Toast 和 Popup 修饰器
        }
    }
    
    init() {
        // 初始化 UIManager
        UIManager.initialize()
    }
}
```

### 显示 Toast

```swift
struct ContentView: View {
    var body: some View {
        VStack {
            Button("显示普通提示") {
                self.uiToast("这是一条普通提示")
            }
            
            Button("显示成功提示") {
                self.uiSuccess("操作成功完成")
            }
            
            Button("显示错误提示") {
                self.uiError("发生错误，请重试")
            }
        }
    }
}
```

### 显示弹窗

```swift
Button("显示中心弹窗") {
    self.uiPopup {
        VStack {
            Text("这是一个自定义弹窗")
                .font(.headline)
            
            Text("您可以在这里放置任何内容")
                .padding()
            
            Button("关闭") {
                self.uiCloseAllPopups()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}
```

### 显示底部菜单

```swift
Button("显示底部菜单") {
    self.uiBottomSheet {
        VStack {
            Text("底部菜单")
                .font(.headline)
            
            Divider()
            
            Button("选项 1") {
                self.uiSuccess("选择了选项 1")
                self.uiCloseAllPopups()
            }
            
            Button("选项 2") {
                self.uiSuccess("选择了选项 2")
                self.uiCloseAllPopups()
            }
            
            Button("取消") {
                self.uiCloseAllPopups()
            }
            .padding(.top)
        }
        .padding()
    }
}
```

### 显示侧边栏

```swift
Button("显示侧边栏") {
    self.uiSidebar {
        VStack(alignment: .leading) {
            Text("侧边栏菜单")
                .font(.headline)
            
            Divider()
            
            ForEach(1...5, id: \.self) { index in
                Button("菜单项 \(index)") {
                    self.uiSuccess("选择了菜单项 \(index)")
                    self.uiCloseAllPopups()
                }
                .padding(.vertical, 8)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
```

## 许可证

UIManager 使用 MIT 许可证。详情请参阅 [LICENSE](LICENSE) 文件。
