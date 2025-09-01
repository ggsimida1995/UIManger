# SimpleUIManager - Filter 组件

Filter 组件提供了强大的多按钮下拉筛选功能，支持多种筛选条件、下拉面板、蒙层和动画效果，完全符合iOS设计规范。

## 组件列表

### MultiButtonFilterView - 多按钮下拉筛选组件
通用的多按钮下拉筛选组件，支持多个筛选条件、下拉面板、蒙层和动画效果。

## 核心特性

- ✅ **多个按钮并排显示**：支持任意数量的筛选按钮，按钮间有分割线分隔
- ✅ **下拉面板**：点击按钮展开对应的下拉面板，覆盖底部内容
- ✅ **全屏蒙层**：半透明黑色蒙层，点击关闭面板
- ✅ **智能面板管理**：每次只能展开一个面板，展开新面板时自动关闭旧面板
- ✅ **图标支持**：支持SF Symbols图标显示
- ✅ **选中状态**：选中项显示checkmark，支持自定义选中颜色
- ✅ **状态同步**：自动同步选中状态，按钮文字自动更新
- ✅ **平滑动画**：0.35秒的iOS标准动画时长
- ✅ **多种样式**：支持default、compact、large三种样式

## 使用方法

### 基础用法

```swift
import SwiftUI

struct ContentView: View {
    @State private var selectedCategory = "全部商品"
    @State private var selectedSort = "默认排序"
    
    var body: some View {
        MultiButtonFilterView(buttons: [
            FilterButton(
                title: "全部商品",
                options: [
                    FilterOption(title: "全部商品", isSelected: true),
                    FilterOption(title: "新款商品", icon: "star.fill"),
                    FilterOption(title: "活动商品", icon: "flame.fill")
                ]
            ) { option in
                selectedCategory = option.title
                print("选择了分类: \(option.title)")
            },
            FilterButton(
                title: "默认排序",
                options: [
                    FilterOption(title: "默认排序", isSelected: true),
                    FilterOption(title: "价格从低到高", icon: "arrow.up.arrow.down"),
                    FilterOption(title: "价格从高到低", icon: "arrow.down.arrow.up")
                ]
            ) { option in
                selectedSort = option.title
                print("选择了排序: \(option.title)")
            }
        ])
        .padding()
    }
}
```

### 多选项筛选器

```swift
MultiButtonFilterView(
    buttons: [
        FilterButton(
            title: "分类",
            options: [
                FilterOption(title: "全部分类", isSelected: true),
                FilterOption(title: "数码", icon: "iphone"),
                FilterOption(title: "服装", icon: "tshirt"),
                FilterOption(title: "家居", icon: "house")
            ]
        ) { option in
            print("选择了分类: \(option.title)")
        },
        FilterButton(
            title: "品牌",
            options: [
                FilterOption(title: "全部品牌", isSelected: true),
                FilterOption(title: "苹果", icon: "applelogo"),
                FilterOption(title: "三星", icon: "star"),
                FilterOption(title: "华为", icon: "leaf")
            ]
        ) { option in
            print("选择了品牌: \(option.title)")
        },
        FilterButton(
            title: "价格",
            options: [
                FilterOption(title: "全部价格", isSelected: true),
                FilterOption(title: "0-100元"),
                FilterOption(title: "100-500元"),
                FilterOption(title: "500元以上")
            ]
        ) { option in
            print("选择了价格: \(option.title)")
        }
    ],
    buttonStyle: .compact
)
```

### 不同样式

```swift
// 默认样式（红色主题）
MultiButtonFilterView(buttons: buttons, buttonStyle: .default)

// 紧凑样式（蓝色主题）
MultiButtonFilterView(buttons: buttons, buttonStyle: .compact)

// 大尺寸样式（橙色主题）
MultiButtonFilterView(buttons: buttons, buttonStyle: .large)
```

## 数据模型

### FilterOption - 筛选选项
```swift
public struct FilterOption: Identifiable {
    public let id = UUID()
    public let title: String           // 选项标题
    public let icon: String?          // 图标名称（SF Symbols）
    public let isSelected: Bool       // 是否选中
}
```

### FilterButton - 筛选按钮
```swift
public struct FilterButton: Identifiable {
    public let id = UUID()
    public let title: String                          // 按钮标题
    public let options: [FilterOption]                // 选项列表
    public let onOptionSelected: (FilterOption) -> Void // 选择回调
}
```

### FilterButtonStyle - 按钮样式
```swift
public enum FilterButtonStyle {
    case `default`  // 默认样式：红色主题，16px字体，16px内边距
    case compact    // 紧凑样式：蓝色主题，14px字体，12px内边距
    case large      // 大尺寸样式：橙色主题，18px字体，20px内边距
}
```

## 样式说明

### 默认样式 (.default)
- 水平内边距：16px
- 垂直内边距：12px
- 字体大小：16px
- 选中颜色：红色

### 紧凑样式 (.compact)
- 水平内边距：12px
- 垂直内边距：8px
- 字体大小：14px
- 选中颜色：蓝色

### 大尺寸样式 (.large)
- 水平内边距：20px
- 垂直内边距：16px
- 字体大小：18px
- 选中颜色：橙色

## 交互行为

### 面板展开
- 点击按钮展开对应的下拉面板
- 面板从顶部滑入，带有淡入效果
- 展开时按钮文字和图标变为选中颜色

### 面板关闭
- 点击蒙层关闭面板
- 再次点击按钮关闭面板
- 展开新面板时自动关闭旧面板

### 选项选择
- 点击选项执行选择操作
- 自动关闭面板
- 按钮文字更新为选中选项
- 执行回调函数

## 使用场景

### 电商筛选
- 商品分类筛选
- 价格区间筛选
- 品牌筛选
- 排序方式选择

### 内容筛选
- 内容类型筛选
- 时间范围筛选
- 标签筛选
- 状态筛选

### 设置界面
- 功能开关
- 选项配置
- 偏好设置
- 模式选择

## 最佳实践

1. **合理分组**：将相关的筛选条件放在一起
2. **图标使用**：为重要选项添加图标，提升用户体验
3. **默认选择**：为每个筛选器设置合理的默认选项
4. **回调处理**：在回调函数中及时更新UI状态
5. **样式统一**：在整个应用中使用一致的样式

## 示例项目

查看 `MultiButtonFilterDemo.swift` 文件获取完整的演示代码，包含：
- 基础筛选器演示
- 多选项筛选器演示
- 大尺寸筛选器演示
- 电商场景筛选器演示
- 当前选择状态显示
- 功能特性说明
