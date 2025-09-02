# UIManager

UIManager 是一个用于 SwiftUI 的现代化、轻量级用户界面组件库，提供了完整的筛选器、弹窗、Toast 提示等组件，以及与系统组件的对比演示。

## 功能特性

- **🔍 筛选组件系统**：
  - 多按钮筛选器，支持复杂下拉面板
  - 简单下拉面板，支持单选和多选
  - 缓存机制，记住用户选择
  - 自定义颜色系统，支持深浅色模式
- **📱 弹窗系统**：
  - 简单弹窗管理器，支持多种动画效果
  - 自定义内容和样式
  - 统一的颜色主题
- **🍞 Toast 提示系统**：
  - 支持信息、成功、警告和错误四种类型
  - 自动消失和手动控制
  - 统一的视觉设计
- **🔄 系统组件对比**：
  - 系统原生输入弹窗演示
  - 系统菜单组件演示
  - 系统分段器演示
  - 系统Toast对比演示
- **🎨 统一颜色系统**：
  - 完整的深浅色模式适配
  - 跨平台兼容（iOS/macOS）
  - 语义化颜色命名

## 最新更新 (v2.0.0)

- 🔄 **重构架构**：完全重写为 UIManager，移除复杂的旧组件
- 🔍 **新增筛选组件**：多按钮筛选器，支持复杂下拉面板和缓存
- 📱 **简化弹窗系统**：保留核心功能，提升易用性
- 🍞 **优化Toast系统**：统一视觉设计，支持多种类型
- 🔄 **系统组件对比**：新增系统原生组件演示，便于选择合适方案
- 🎨 **颜色系统升级**：完整的深浅色模式适配，跨平台兼容
- 📦 **项目结构优化**：清理冗余代码，提升维护性

## 颜色系统

UIManager 提供了一套完整的颜色系统，所有颜色都会根据系统的深色/浅色模式自动切换：

```swift
// 基础颜色
Color.backgroundColor        // 背景色
Color.secondaryBackgroundColor  // 次要背景色
Color.textColor             // 文本颜色
Color.secondaryTextColor    // 次要文本颜色
Color.borderColor          // 边框颜色
Color.accentColor          // 强调色
Color.overlayColor         // 遮罩层颜色

// 状态颜色
Color.successColor         // 成功状态颜色
Color.warningColor         // 警告状态颜色
Color.errorColor           // 错误状态颜色
Color.infoColor            // 信息状态颜色
```

## 项目结构

```
UIManager/
├── Sources/
│   └── UIManager/
│       ├── UIManager.swift              # 核心管理类
│       ├── Extensions/                  # 扩展功能
│       │   └── Color+UIManager.swift    # 颜色系统
│       ├── Filter/                      # 筛选组件
│       │   ├── MultiButtonFilterView.swift    # 多按钮筛选器
│       │   ├── ComplexDropdownPanel.swift     # 复杂下拉面板
│       │   └── DropdownPanel.swift            # 下拉面板
│       ├── Popup/                       # 弹窗组件
│       │   ├── PopupManager.swift       # 弹窗管理器
│       │   └── PopupView.swift          # 弹窗视图
│       ├── Toast/                       # Toast组件
│       │   ├── ToastManager.swift       # Toast管理器
│       │   └── ToastView.swift          # Toast视图
│       └── Previews/                    # 演示组件
│           ├── UIManagerDemos.swift     # 主演示入口
│           ├── MultiButtonFilterDemo.swift    # 筛选器演示
│           ├── PopupPreview.swift       # 弹窗演示
│           ├── ToastDemo.swift          # Toast演示
│           ├── SystemInputAlertDemo.swift     # 系统输入演示
│           ├── SystemLikeMenuDemo.swift       # 系统菜单演示
│           ├── SystemSegmentedDemo.swift      # 系统分段器演示
│           └── SystemToastDemo.swift          # 系统Toast演示
└── DemoApp.swift                         # 示例应用入口
```

## 要求

- iOS 16.0+
- macOS 13.0+
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
    .package(url: "https://github.com/ggsimida1995/UiManager.git", from: "2.0.0")
]
```

## 快速开始

### 初始化

在 SwiftUI App 中初始化 UIManager：

```swift
import UIManager

@main
struct MyApp: App {
    init() {
        // 初始化 UIManager
        UIManager.initialize()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withUI() // 应用 Toast 和 Popup 修饰器
        }
    }
}
```

### 显示 Toast

```swift
struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("显示信息提示") {
                UIManager.toast.showToast(message: "这是一条信息提示")
            }
            
            Button("显示成功提示") {
                UIManager.toast.showSuccess(message: "操作成功完成")
            }
            
            Button("显示警告提示") {
                UIManager.toast.showWarning(message: "请注意，这是一个警告")
            }
            
            Button("显示错误提示") {
                UIManager.toast.showError(message: "发生错误，请重试")
            }
            
            Button("显示自定义时长提示") {
                UIManager.toast.showToast(message: "这条提示会显示5秒", duration: 5.0)
            }
        }
        .padding()
    }
}
```

### 显示弹窗

```swift
struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            // 基本弹窗
            Button("显示弹窗") {
                UIManager.popup.show {
                    VStack {
                        Text("这是一个弹窗")
                            .font(.headline)
                            .padding()
                        
                        Button("关闭") {
                            UIManager.popup.closeAll()
                        }
                        .padding()
                        .background(Color.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                }
            }
        }
        .padding()
    }
}
```

### 使用筛选组件

```swift
struct ContentView: View {
    var body: some View {
        MultiButtonFilterView(
            buttons: [
                FilterButton(title: "分类") { titleBinding, closePanel, setCacheData, getCacheData in
                    DropdownPanel(
                        options: [
                            DropdownOption(title: "全部", key: "all", val: "all"),
                            DropdownOption(title: "新品", key: "new", val: "new")
                        ],
                        selectedTitle: titleBinding,
                        onSelect: { option in
                            print("选择了：\(option.title)")
                            closePanel()
                        },
                        setCacheData: setCacheData,
                        getCacheData: getCacheData
                    )
                }
            ]
        ) {
            // 内容区域
            Text("这里是筛选后的内容")
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
