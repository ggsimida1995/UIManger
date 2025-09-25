import SwiftUI

/// 简化筛选组件演示
public struct SimpleFilterDemo: View {
    public init() {}
    
    public var body: some View {
        SimpleFilterView(
            buttons: [
                // 方式1：简单下拉列表 - 单选，点击即选中
                .dropdown(
                    title: "状态", 
                    options: [
                        DropdownOption(title: "全部", key: "all", val: "all"),
                        DropdownOption(title: "启用", key: "enabled", val: "enabled"),
                        DropdownOption(title: "禁用", key: "disabled", val: "disabled")
                    ],
                    onConfirm: { selectedOption in
                        print("下拉选择: \(selectedOption.title) (key: \(selectedOption.key), val: \(selectedOption.val))")
                    }
                ),
                
                // 方式2a：第一个分组面板
                .sections(
                    title: "类型筛选",
                    sections: [
                        DropdownSection(
                            title: "内容类型",
                            items: [
                                DropdownItem(title: "阅读", key: "type", val: "read"),
                                DropdownItem(title: "听书", key: "type", val: "audio"),
                                DropdownItem(title: "漫画", key: "type", val: "comic")
                            ],
                            selectionMode: .multiple
                        )
                    ],
                    onConfirm: { selectedItems in
                        print("类型筛选确认: 选中了 \(selectedItems.count) 个项目")
                        for item in selectedItems {
                            print("  - \(item.title) (key: \(item.key), val: \(item.val))")
                        }
                    },
                    onReset: {
                        print("类型筛选重置: 清空所有选择")
                    }
                ),
                
                // 方式2b：第二个分组面板 - 测试相邻sections切换
                .sections(
                    title: "等级筛选",
                    sections: [
                        DropdownSection(
                            title: "难度等级", 
                            items: [
                                DropdownItem(title: "初级", key: "level", val: "basic"),
                                DropdownItem(title: "中级", key: "level", val: "intermediate"),
                                DropdownItem(title: "高级", key: "level", val: "advanced")
                            ],
                            selectionMode: .single
                        )
                    ],
                    onConfirm: { selectedItems in
                        print("等级筛选确认: 选中了 \(selectedItems.count) 个项目")
                        for item in selectedItems {
                            print("  - \(item.title) (key: \(item.key), val: \(item.val))")
                        }
                    },
                    onReset: {
                        print("等级筛选重置: 清空所有选择")
                    }
                )
            ]
        ) {
            // 主要内容区域
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(0..<20, id: \.self) { index in
                        HStack {
                            Text("项目 \(index + 1)")
                                .font(.headline)
                            Spacer()
                            Text("状态")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                        .padding()
                        .background(Color.backgroundColor)
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationView {
        SimpleFilterDemo()
    }
}
#endif
