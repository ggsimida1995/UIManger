import SwiftUI

struct MultiButtonFilterDemo: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 基础筛选器
                VStack(alignment: .leading, spacing: 16) {
                    Text("基础筛选器")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Spacer()
                    MultiButtonFilterView(
                        buttons: [
                            FilterButton(title: "全部商品", cacheKey: "product_category") { titleBinding, closePanel, setCacheData, getCacheData in
                                DropdownPanel(
                                    options: [
                                        DropdownOption(title: "全部商品", key: "category_all", val: "all"),
                                        DropdownOption(title: "新款商品", key: "category_new", val: "new"),
                                        DropdownOption(title: "活动商品", key: "category_promotion", val: "promotion"),
                                        DropdownOption(title: "热销商品", key: "category_hot", val: "hot")
                                    ],
                                    selectedTitle: titleBinding,
                                    onSelect: { option in
                                        print("选择了商品分类: [\(option.key)] \(option.title) (值: \(option.val))")
                                        closePanel()
                                    },
                                    setCacheData: setCacheData,
                                    getCacheData: getCacheData
                                )
                            },
                            FilterButton(title: "默认排序", cacheKey: "sort_order") { titleBinding, closePanel, setCacheData, getCacheData in
                                DropdownPanel(
                                    options: [
                                        DropdownOption(title: "默认排序", key: "sort_default", val: "default"),
                                        DropdownOption(title: "价格从低到高", key: "sort_price_asc", val: "price_asc"),
                                        DropdownOption(title: "价格从高到低", key: "sort_price_desc", val: "price_desc"),
                                        DropdownOption(title: "销量优先", key: "sort_sales", val: "sales")
                                    ],
                                    selectedTitle: titleBinding,
                                    onSelect: { option in
                                        print("选择了排序方式: [\(option.key)] \(option.title) (值: \(option.val))")
                                        closePanel()
                                    },
                                    setCacheData: setCacheData,
                                    getCacheData: getCacheData
                                )
                            },
                            FilterButton(title: "筛选", cacheKey: "mixed_filter") { titleBinding, closePanel, setCacheData, getCacheData in
                                ComplexDropdownPanel(
                                    sections: [
                                        DropdownSection(title: "价格区间", items: [
                                            DropdownItem(title: "0-100元", key: "price_range", val: "0-100"),
                                            DropdownItem(title: "100-500元", key: "price_range", val: "100-500"),
                                            DropdownItem(title: "500-1000元", key: "price_range", val: "500-1000"),
                                            DropdownItem(title: "1000元以上", key: "price_range", val: "1000+")
                                        ], selectionMode: .single), // 单选模式
                                        DropdownSection(title: "品牌", items: [
                                            DropdownItem(title: "苹果", key: "brand", val: "apple"),
                                            DropdownItem(title: "华为", key: "brand", val: "huawei"),
                                            DropdownItem(title: "小米", key: "brand", val: "xiaomi"),
                                            DropdownItem(title: "OPPO", key: "brand", val: "oppo"),
                                            DropdownItem(title: "vivo", key: "brand", val: "vivo")
                                        ], selectionMode: .single), // 单选模式
                                        DropdownSection(title: "功能特色", items: [
                                            DropdownItem(title: "5G网络", key: "feature", val: "5g"),
                                            DropdownItem(title: "快充技术", key: "feature", val: "fast_charging"),
                                            DropdownItem(title: "无线充电", key: "feature", val: "wireless_charging"),
                                            DropdownItem(title: "防水防尘", key: "feature", val: "waterproof"),
                                            DropdownItem(title: "双卡双待", key: "feature", val: "dual_sim"),
                                            DropdownItem(title: "NFC支付", key: "feature", val: "nfc"),
                                            DropdownItem(title: "指纹识别", key: "feature", val: "fingerprint"),
                                            DropdownItem(title: "面部识别", key: "feature", val: "face_id")
                                        ], selectionMode: .multiple) // 多选模式
                                    ],
                                    selectedTitle: titleBinding,
                                    onSelectionChange: { updatedSections in
                                        // 混合模式：有多选分组时计算项目数，否则计算分组数
                                        let hasMultipleSelection = updatedSections.contains { section in
                                            section.selectionMode == .multiple && section.items.contains { $0.isSelected }
                                        }
                                        
                                        if hasMultipleSelection {
                                            let selectedItems = updatedSections.flatMap { $0.items }.filter { $0.isSelected }.count
                                            print("混合模式选择了 \(selectedItems) 个项目")
                                        } else {
                                            let selectedSections = updatedSections.filter { section in
                                                section.items.contains { $0.isSelected }
                                            }.count
                                            print("混合模式选择了 \(selectedSections) 个分组")
                                        }
                                        
                                        // 循环打印选择的选项内容
                                        let selectedItems = updatedSections.flatMap { $0.items }.filter { $0.isSelected }
                                        print("📋 选中的筛选条件:")
                                        for (index, item) in selectedItems.enumerated() {
                                            print("  \(index + 1). [\(item.key)] \(item.title) (值: \(item.val))")
                                        }
                                        print("总计: \(selectedItems.count) 个选项")
                                    },
                                    onConfirm: { selectedItems in
                                        print("混合模式确定")
                                        print("📋 最终选中的筛选条件:")
                                        for (index, item) in selectedItems.enumerated() {
                                            print("  \(index + 1). [\(item.key)] \(item.title) (值: \(item.val))")
                                        }
                                        print("总计: \(selectedItems.count) 个选项")
                                        
                                        // 这里可以调用筛选接口
                                        // filterProducts(with: selectedItems)
                                        
                                        closePanel()
                                    },
                                    onReset: {
                                        print("混合模式重置筛选条件")
                                    },
                                    setCacheData: setCacheData,
                                    getCacheData: getCacheData
                                )
                                .id("mixed_filter_panel")
                            },
                            FilterButton(title: "单选筛选", cacheKey: "single_filter") { titleBinding, closePanel, setCacheData, getCacheData in
                                ComplexDropdownPanel(
                                    sections: [
                                        DropdownSection(title: "商品分类", items: [
                                            DropdownItem(title: "手机数码", key: "category", val: "digital"),
                                            DropdownItem(title: "电脑办公", key: "category", val: "computer"),
                                            DropdownItem(title: "家用电器", key: "category", val: "appliance"),
                                            DropdownItem(title: "服饰内衣", key: "category", val: "clothing"),
                                            DropdownItem(title: "家居家装", key: "category", val: "furniture")
                                        ]),
                                        DropdownSection(title: "发货地区", items: [
                                            DropdownItem(title: "北京", key: "region", val: "beijing"),
                                            DropdownItem(title: "上海", key: "region", val: "shanghai"),
                                            DropdownItem(title: "广州", key: "region", val: "guangzhou"),
                                            DropdownItem(title: "深圳", key: "region", val: "shenzhen"),
                                            DropdownItem(title: "杭州", key: "region", val: "hangzhou")
                                        ]),
                                        DropdownSection(title: "商家服务", items: [
                                            DropdownItem(title: "京东配送", key: "service", val: "jd_delivery"),
                                            DropdownItem(title: "货到付款", key: "service", val: "cod"),
                                            DropdownItem(title: "仅看有货", key: "service", val: "in_stock"),
                                            DropdownItem(title: "全球购", key: "service", val: "global_buy"),
                                            DropdownItem(title: "京东国际", key: "service", val: "jd_international")
                                        ])
                                    ],
                                    selectedTitle: titleBinding,
                                    onSelectionChange: { updatedSections in
                                        // 全局单选模式：始终计算分组数
                                        let selectedSections = updatedSections.filter { section in
                                            section.items.contains { $0.isSelected }
                                        }.count
                                        print("单选模式选择了 \(selectedSections) 个分组")
                                        
                                        // 循环打印选择的选项内容
                                        let selectedItems = updatedSections.flatMap { $0.items }.filter { $0.isSelected }
                                        print("📋 选中的筛选条件:")
                                        for (index, item) in selectedItems.enumerated() {
                                            print("  \(index + 1). [\(item.key)] \(item.title) (值: \(item.val))")
                                        }
                                        print("总计: \(selectedItems.count) 个选项")
                                    },
                                    onConfirm: { selectedItems in
                                        print("单选模式确定")
                                        print("📋 最终选中的筛选条件:")
                                        for (index, item) in selectedItems.enumerated() {
                                            print("  \(index + 1). [\(item.key)] \(item.title) (值: \(item.val))")
                                        }
                                        print("总计: \(selectedItems.count) 个选项")
                                        
                                        // 这里可以调用筛选接口
                                        // filterProducts(with: selectedItems)
                                        
                                        closePanel()
                                    },
                                    onReset: {
                                        print("单选模式重置筛选条件")
                                    },
                                    setCacheData: setCacheData,
                                    getCacheData: getCacheData,
                                    globalSelectionMode: .single // 全局单选模式
                                )
                                .id("single_filter_panel")
                            }
                        ]
                    ) {
                        // 这里传入的内容不会被挤走
                        VStack(spacing: 20) {
                            // 示例内容
                            VStack(alignment: .leading, spacing: 12) {
                                Text("商品列表")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                ForEach(1...5, id: \.self) { index in
                                    HStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: 60, height: 60)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("商品 \(index)")
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                            Text("价格: ¥\(index * 100)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 8)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            
                            // 更多内容
                            Text("下拉面板紧贴筛选按钮，宽度一致")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("多按钮筛选组件")

        }
    }
}

#Preview {
    MultiButtonFilterDemo()
}
