import SwiftUI

struct MultiButtonFilterDemo: View {
    // 定义公共的筛选选项数据
    private let statusSections = [
        ("书源类型", "type", [
            ("阅读", "1"),
            ("听书", "4")
        ]),
        ("搜索状态", "status", [
            ("启用", "1"),
            ("禁用", "0")
        ]),
        ("发现状态", "finderStatus", [
            ("启用", "1"),
            ("禁用", "0")
        ])
    ]
    
    private let detectionSections = [
        ("搜索检测", "searchCheck", [
            ("未检测", "0"),
            ("超时", "1"),
            ("无数据", "2")
        ]),
        ("章节检测", "chapterCheck", [
            ("未检测", "0"),
            ("超时", "1"),
            ("无数据", "2")
        ]),
        ("正文检测", "contentCheck", [
            ("未检测", "0"),
            ("超时", "1"),
            ("无数据", "2")
        ]),
        ("发现检测", "finderCheck", [
            ("未检测", "0"),
            ("超时", "1"),
            ("无数据", "2")
        ])
    ]
    
    private let ruleSections = [
        ("基础", [
            ("有搜索", "search"),
            ("有发现", "finder"),
            ("有详情", "hasBookInfo"),
            ("公共方法", "jsLib"),
            ("有登录", "loginUrl"),
            ("书籍导入", "importUrl")
        ]),
        ("权限", [
            ("我的书源", "mine"),
            ("加密书源", "isEncrypt"),
            ("编辑权限", "editAuth"),
            ("只读权限", "readAuth")
        ]),
        ("搜索", [
            ("搜索前置", "searchPre"),
            ("Http请求", "searchHttp"),
            ("Webview请求", "searchWebview"),
            ("XPath解析", "searchXPath"),
            ("JsonPath解析", "searchJsonPath"),
            ("GET请求", "searchGet"),
            ("POST请求", "searchPost"),
            ("请求规则", "searchRequest"),
            ("响应规则", "searchResponse"),
            ("图片验证码", "searchCover"),
            ("浏览器验证", "searchBrowser")
        ]),
        ("详情", [
            ("详情前置", "infoPre"),
            ("Http请求", "infoHttp"),
            ("Webview请求", "infoWebview"),
            ("XPath解析", "infoXPath"),
            ("JsonPath解析", "infoJsonPath"),
            ("GET请求", "infoGet"),
            ("POST请求", "infoPost"),
            ("请求规则", "infoRequest"),
            ("响应规则", "infoResponse"),
            ("图片验证码", "infoCover"),
            ("浏览器验证", "infoBrowser")
        ]),
        ("章节", [
            ("章节前置", "chapterPre"),
            ("Http请求", "chapterHttp"),
            ("Webview请求", "chapterWebview"),
            ("XPath解析", "chapterXPath"),
            ("JsonPath解析", "chapterJsonPath"),
            ("GET请求", "chapterGet"),
            ("POST请求", "chapterPost"),
            ("请求规则", "chapterRequest"),
            ("响应规则", "chapterResponse"),
            ("图片验证码", "chapterCover"),
            ("浏览器验证", "chapterBrowser")
        ]),
        ("正文", [
            ("正文前置", "contentPre"),
            ("Http请求", "contentHttp"),
            ("Webview请求", "contentWebview"),
            ("XPath解析", "contentXPath"),
            ("JsonPath解析", "contentJsonPath"),
            ("GET请求", "contentGet"),
            ("POST请求", "contentPost"),
            ("请求规则", "contentRequest"),
            ("响应规则", "contentResponse"),
            ("图片验证码", "contentCover"),
            ("浏览器验证", "contentBrowser")
        ])
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 书源筛选器
                VStack(alignment: .leading, spacing: 16) {
                    Text("书源筛选器")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Spacer()
                    MultiButtonFilterView(
                        buttons: [
                            FilterButton(title: "状态", cacheKey: "status_filter") { titleBinding, closePanel, setCacheData, getCacheData in
                                ComplexDropdownPanel(
                                    sections: statusSections.map { section in
                                        DropdownSection(
                                            title: section.0,
                                            items: section.2.map { item in
                                                DropdownItem(title: item.0, key: section.1, val: item.1)
                                            },
                                            selectionMode: .single
                                        )
                                    },
                                    selectedTitle: titleBinding,
                                    onSelectionChange: { updatedSections in
                                        let selectedItems = updatedSections.flatMap { $0.items }.filter { $0.isSelected }
                                        print("📋 状态筛选选择了 \(selectedItems.count) 个选项")
                                        for item in selectedItems {
                                            print("  - [\(item.key)] \(item.title) (值: \(item.val))")
                                        }
                                    },
                                    onConfirm: { selectedItems in
                                        print("✅ 确认状态筛选: \(selectedItems.count) 个选项")
                                        closePanel()
                                    },
                                    onReset: {
                                        print("🔄 重置状态筛选")
                                    },
                                    setCacheData: setCacheData,
                                    getCacheData: getCacheData
                                )
                                .id("status_panel")
                            },
                            FilterButton(title: "检测", cacheKey: "detection_filter") { titleBinding, closePanel, setCacheData, getCacheData in
                                ComplexDropdownPanel(
                                    sections: detectionSections.map { section in
                                        DropdownSection(
                                            title: section.0,
                                            items: section.2.map { item in
                                                DropdownItem(title: item.0, key: section.1, val: item.1)
                                            },
                                            selectionMode: .multiple
                                        )
                                    },
                                    selectedTitle: titleBinding,
                                    onSelectionChange: { updatedSections in
                                        let selectedItems = updatedSections.flatMap { $0.items }.filter { $0.isSelected }
                                        print("📋 检测筛选选择了 \(selectedItems.count) 个选项")
                                        for item in selectedItems {
                                            print("  - [\(item.key)] \(item.title) (值: \(item.val))")
                                        }
                                    },
                                    onConfirm: { selectedItems in
                                        print("✅ 确认检测筛选: \(selectedItems.count) 个选项")
                                        closePanel()
                                    },
                                    onReset: {
                                        print("🔄 重置检测筛选")
                                    },
                                    setCacheData: setCacheData,
                                    getCacheData: getCacheData
                                )
                                .id("detection_panel")
                            },
                            FilterButton(title: "排序", cacheKey: "sorting_filter") { titleBinding, closePanel, setCacheData, getCacheData in
                                DropdownPanel(
                                    options: [
                                        DropdownOption(title: "默认排序", key: "isTop", val: "Desc"),
                                        DropdownOption(title: "名称降序", key: "siteName", val: "Desc"),
                                        DropdownOption(title: "名称升序", key: "siteName", val: "Asc"),
                                        DropdownOption(title: "更新降序", key: "updateTime", val: "Desc"),
                                        DropdownOption(title: "更新升序", key: "updateTime", val: "Asc"),
                                        DropdownOption(title: "添加降序", key: "time", val: "Desc"),
                                        DropdownOption(title: "添加升序", key: "time", val: "Asc")
                                    ],
                                    selectedTitle: titleBinding,
                                    onSelect: { option in
                                        print("选择了排序方式: [\(option.key)] \(option.title) (值: \(option.val))")
                                        closePanel()
                                    },
                                    setCacheData: setCacheData,
                                    getCacheData: getCacheData
                                )
                                .id("sorting_panel")
                            },
                            FilterButton(title: "规则", cacheKey: "rule_filter") { titleBinding, closePanel, setCacheData, getCacheData in
                                ComplexDropdownPanel(
                                    sections: ruleSections.map { section in
                                        DropdownSection(
                                            title: section.0,
                                            items: section.1.map { item in
                                                DropdownItem(title: item.0, key: "tags", val: item.1)
                                            },
                                            selectionMode: .multiple
                                        )
                                    },
                                    selectedTitle: titleBinding,
                                    onSelectionChange: { updatedSections in
                                        let selectedItems = updatedSections.flatMap { $0.items }.filter { $0.isSelected }
                                        print("📋 规则筛选选择了 \(selectedItems.count) 个选项")
                                        for item in selectedItems {
                                            print("  - [\(item.key)] \(item.title) (值: \(item.val))")
                                        }
                                    },
                                    onConfirm: { selectedItems in
                                        print("✅ 确认规则筛选: \(selectedItems.count) 个选项")
                                        closePanel()
                                    },
                                    onReset: {
                                        print("🔄 重置规则筛选")
                                    },
                                    setCacheData: setCacheData,
                                    getCacheData: getCacheData
                                )
                                .id("rule_panel")
                            }
                        ]
                    ) {
                        // 书源内容区域
                        VStack(spacing: 16) {
                            Text("书源列表")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("这里显示根据筛选条件过滤后的书源内容")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            // 模拟书源卡片
                            VStack(alignment: .leading, spacing: 8) {
                                Text("笔趣阁")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                Text("状态: 启用")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                                Text("类型: 阅读")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("检测: 正常")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.secondaryBackgroundColor)
                            .cornerRadius(8)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("书源筛选器演示")
        }
    }
}

#Preview {
    MultiButtonFilterDemo()
}
