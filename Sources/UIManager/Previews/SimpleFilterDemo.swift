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
                    ]
                ),
                
                // 方式2：分组面板 - 支持单选/多选，需要确定按钮
                .sections(
                    title: "筛选",
                    sections: [
                        DropdownSection(
                            title: "类型",
                            items: [
                                DropdownItem(title: "阅读", key: "read", val: "read"),
                                DropdownItem(title: "听书", key: "audio", val: "audio"),
                                DropdownItem(title: "漫画", key: "comic", val: "comic")
                            ],
                            selectionMode: .multiple
                        ),
                        DropdownSection(
                            title: "等级", 
                            items: [
                                DropdownItem(title: "初级", key: "basic", val: "basic"),
                                DropdownItem(title: "中级", key: "intermediate", val: "intermediate"),
                                DropdownItem(title: "高级", key: "advanced", val: "advanced")
                            ],
                            selectionMode: .single
                        )
                    ]
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
