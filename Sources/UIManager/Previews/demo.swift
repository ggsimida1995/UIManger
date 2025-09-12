import SwiftUI

// 移除@main - 这只是一个演示组件，不应该作为应用入口点
struct LiquidGlassDemoApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                GlassEffectDemoView()
                    .tabItem {
                        Label("玻璃效果", systemImage: "drop")
                    }
                
                AdaptiveNavigationDemo()
                    .tabItem {
                        Label("导航适配", systemImage: "sitemap")
                    }
                
                ToolbarAndDialogDemo()
                    .tabItem {
                        Label("工具栏", systemImage: "wrench.and.screwdriver")
                    }
                
                ListLayoutDemo()
                    .tabItem {
                        Label("列表样式", systemImage: "list.bullet")
                    }
            }
        }
    }
}

// 1. 自定义玻璃效果 Demo
struct GlassEffectDemoView: View {
    @State private var isGlassEnabled = true
    
    var body: some View {
        VStack(spacing: 20) {
            Button("系统按钮（自动适配）") {
                print("系统按钮点击")
            }
            .buttonStyle(.borderedProminent)
            
            Toggle("启用自定义玻璃效果", isOn: $isGlassEnabled)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                Text("自定义玻璃卡片")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("仅在核心功能元素使用玻璃效果")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(20)
            .background(Color.white.opacity(0.05))
            .glassEffect(in: RoundedRectangle(cornerRadius: 16))
            .glassEffect()
            .frame(maxWidth: .infinity, maxHeight: 200)
            
            Spacer()
        }
        .padding()
        .navigationTitle("自定义玻璃效果")
        .background(LinearGradient(
            gradient: Gradient(colors: [.blue.opacity(0.1), .purple.opacity(0.1)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
    }
}

// 2. 自适应导航 Demo
struct AdaptiveNavigationDemo: View {
    @State private var showInspector = false
    @State private var selectedItem: String? = "富士山"
    @State private var splitViewVisibility: NavigationSplitViewVisibility = .automatic
    let landmarks = ["富士山", "东京塔", "京都金阁寺", "北海道旭川"]
    
    var body: some View {
        NavigationSplitView(
            columnVisibility: $splitViewVisibility,
            sidebar: {
                List(landmarks, id: \.self, selection: $selectedItem) { landmark in
                    Text(landmark)
                }
                .navigationTitle("地标列表")
            },
            content: {
                VStack(spacing: 16) {
                    Text(selectedItem ?? "选择左侧地标")
                        .font(.title)
                    Text("Liquid Glass 导航层悬浮于内容之上")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .navigationTitle("地标详情")
                .inspector(isPresented: $showInspector) {
                    VStack {
                        Text("地标信息")
                            .font(.title)
                        Text("名称：\(selectedItem ?? "未选择")")
                    }
                    .padding()
                }
            },
            detail: {
                Text("选择项目查看详情")
                    .foregroundColor(.secondary)
            }
        )
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("显示详情") {
                    showInspector = true
                }
                .disabled(selectedItem == nil)
            }
        }
    }
}

// 3. 工具栏与对话框 Demo（关键修复）
struct ToolbarAndDialogDemo: View {
    @State private var showDialog = false
    @State private var isFavorite = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("工具栏与动作表示例")
                .font(.title)
            Text("通过系统 API 实现工具栏分组与语义化动作表")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
        .navigationTitle("工具栏组件")
        // 修复工具栏报错：使用多个独立 ToolbarItem 替代 ToolbarItemGroup
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { isFavorite.toggle() }) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(isFavorite ? .yellow : .primary)
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showDialog = true }) {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        // 修复 confirmationDialog 闭包报错：使用最简化语法
        .confirmationDialog("操作选项", isPresented: $showDialog) {
            Button("分享内容") { print("分享") }
            Button("保存到本地") { print("保存") }
            Button("举报内容", role: .destructive) { print("举报") }
            Button("取消", role: .cancel) { }
        } message: {
            Text("选择需要执行的操作")
        }
    }
}

// 4. 列表布局 Demo
struct ListLayoutDemo: View {
    let settingSections = [
        SettingSection(
            title: "账号设置",
            items: ["个人信息", "登录密码", "隐私权限"]
        ),
        SettingSection(
            title: "应用功能",
            items: ["通知管理", "主题切换", "数据备份"]
        )
    ]
    
    struct SettingSection {
        let title: String
        let items: [String]
    }
    
    var body: some View {
        List {
            ForEach(settingSections, id: \.title) { section in
                Section(header: Text(section.title)) {
                    ForEach(section.items, id: \.self) { item in
                        HStack {
                            Text(item)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("设置")
    }
}

// 预览配置
struct LiquidGlassDemo_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack { GlassEffectDemoView() }
            AdaptiveNavigationDemo()
            NavigationStack { ToolbarAndDialogDemo() }
            NavigationStack { ListLayoutDemo() }
        }
    }
}
