# 弹窗组件 (Popup)

## 概述

弹窗组件是UIManager的核心组件，专注于简单易用的单一弹窗显示，支持顶部、中心、底部三种位置，并提供高度控制功能。

## 文件结构

```
Sources/UIManager/Popup/
├── README.md                 # 详细使用文档
├── Popup.swift               # 公共导出文件
├── PopupManager.swift        # 弹窗管理器
├── PopupModels.swift         # 数据模型
└── PopupView.swift           # 视图组件

Sources/UIManager/Previews/
└── PopupDemo.swift           # 演示文件
```

## 主要特性

- ✅ **简化设计**：每个位置只支持一个弹窗
- ✅ **三种位置**：顶部、中心、底部
- ✅ **高度控制**：可自定义弹窗高度
- ✅ **弹簧动画**：流畅的弹簧动画效果
- ✅ **层级管理**：底部弹窗层级最高

## 基本用法

### 1. 初始化

```swift
import UIManager

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withUI() // 添加弹窗支持
        }
    }
}
```

### 2. 显示弹窗

```swift
struct ContentView: View {
    @Environment(\.popup) var popup
    
    var body: some View {
        VStack {
            Button("显示顶部弹窗") {
                popup.show(
                    content: {
                        VStack {
                            Text("顶部弹窗")
                            Button("关闭") {
                                popup.close(position: .top)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    },
                    position: .top
                )
            }
        }
    }
}
```

### 3. 控制弹窗高度

```swift
popup.show(
    content: { /* 内容 */ },
    position: .bottom,
    height: 200 // 固定高度200pt
)
```


## API 参考

### PopupManager

#### 显示弹窗
- `show(content:position:height:id:)` - 显示弹窗
- `close(position:)` - 关闭指定位置的弹窗
- `closeAll()` - 关闭所有弹窗

#### 状态查询
- `hasActivePopups` - 是否有活跃的弹窗
- `count` - 当前弹窗数量

### PopupPosition

```swift
enum PopupPosition {
    case top    // 顶部弹窗
    case center // 中心弹窗
    case bottom // 底部弹窗 (层级最高)
}
```

## 与原版弹窗的对比

| 特性 | 原版弹窗 | 简化弹窗 |
|------|----------|----------|
| 多弹窗支持 | ✅ | ❌ |
| 层级管理 | 复杂 | 简单 |
| 拼接功能 | ✅ | ❌ |
| 高度控制 | ✅ | ✅ |
| 动画效果 | 弹簧 | 弹簧 |
| 使用难度 | 复杂 | 简单 |

## 示例演示

运行 `PopupDemo` 查看完整的使用示例，包括：

- 基本弹窗显示
- 高度控制演示
- 切换功能演示
- 各种位置的弹窗

## 注意事项

1. **每个位置只支持一个弹窗**：如果在同一位置显示新弹窗，会替换当前弹窗
2. **底部弹窗层级最高**：底部弹窗会显示在其他弹窗之上
3. **自动蒙层管理**：有弹窗显示时自动显示蒙层，点击蒙层关闭所有弹窗
4. **弹簧动画**：所有弹窗使用统一的弹簧动画效果
