import SwiftUI

/// 弹窗预览视图
public struct PopupPreview: View {
    @Environment(\.popup) var popup
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("弹窗预览")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 16) {
                        // 基本弹窗
                        GroupBox("基本弹窗") {
                            VStack(spacing: 12) {
                                Button("中心弹窗") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 16) {
                                                Text("中心弹窗")
                                                    .font(.headline)
                                                Text("这是一个居中显示的弹窗")
                                                    .foregroundColor(.secondary)
                                                Button("关闭") {
                                                    // 弹窗会自动处理关闭
                                                }
                                                .buttonStyle(.borderedProminent)
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.95))
                                            .cornerRadius(12)
                                        },
                                        position: .center
                                    )
                                }
                                .buttonStyle(.bordered)
                                
                                Button("顶部弹窗") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 16) {
                                                Text("顶部弹窗")
                                                    .font(.headline)
                                                Text("从顶部滑入的弹窗")
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.95))
                                            .cornerRadius(12)
                                        },
                                        position: .top
                                    )
                                }
                                .buttonStyle(.bordered)
                                
                                Button("底部弹窗") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 16) {
                                                Text("底部弹窗")
                                                    .font(.headline)
                                                Text("从底部滑入的弹窗")
                                                    .foregroundColor(.secondary)
                                                
                                                HStack(spacing: 12) {
                                                    Button("选项1") {
                                                        print("选择了选项1")
                                                    }
                                                    .buttonStyle(.borderedProminent)
                                                    
                                                    Button("选项2") {
                                                        print("选择了选项2")
                                                    }
                                                    .buttonStyle(.bordered)
                                                }
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.95))
                                            .cornerRadius(12)
                                        },
                                        position: .bottom
                                    )
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding()
                        }
                        
                        // 多弹窗演示
                        GroupBox("多弹窗演示") {
                            VStack(spacing: 12) {
                                Button("显示多个弹窗") {
                                    // 显示顶部弹窗
                                    popup.show(
                                        content: {
                                            VStack {
                                                Text("顶部弹窗 1")
                                                    .font(.headline)
                                                Text("这是第一个顶部弹窗")
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.95))
                                            .cornerRadius(12)
                                        },
                                        position: .top,
                                        id: "top1"
                                    )
                                    
                                    // 显示第二个顶部弹窗
                                        popup.show(
                                            content: {
                                                VStack {
                                                    Text("顶部弹窗 2")
                                                        .font(.headline)
                                                    Text("这是第二个顶部弹窗")
                                                        .foregroundColor(.secondary)
                                                }
                                                .padding()
                                                .background(Color.white.opacity(0.95))
                                                .cornerRadius(12)
                                            },
                                            position: .top,
                                            id: "top2"
                                        )
                                    
                                   
                                    
                                    // 显示底部弹窗
                                        popup.show(
                                            content: {
                                                VStack {
                                                    Text("底部弹窗 1")
                                                        .font(.headline)
                                                    Text("多个弹窗会自动融合")
                                                        .foregroundColor(.secondary)
                                                }
                                                .padding()
                                                .background(Color.white.opacity(0.95))
                                                .cornerRadius(12)
                                            },
                                            position: .bottom,
                                            id: "bottom1"
                                        )
                                    
                                    // 显示第二个底部弹窗
                                        popup.show(
                                            content: {
                                                VStack {
                                                    Text("底部弹窗 2")
                                                        .font(.headline)
                                                    Text("玻璃效果融合演示")
                                                        .foregroundColor(.secondary)
                                                }
                                                .padding()
                                                .background(Color.white.opacity(0.95))
                                                .cornerRadius(12)
                                            },
                                            position: .bottom,
                                            id: "bottom2"
                                        )
                                }
                                .buttonStyle(.borderedProminent)
                                
                                Button("测试弹窗融合") {
                                    // 快速显示多个相邻弹窗，观察融合效果
                                    popup.show(
                                        content: {
                                            VStack {
                                                Text("融合测试 1")
                                                    .font(.headline)
                                                Text("观察玻璃效果融合")
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.95))
                                            .cornerRadius(12)
                                        },
                                        position: .bottom,
                                        id: "merge1"
                                    )
                                    
                                    popup.show(
                                        content: {
                                            VStack {
                                                Text("融合测试 2")
                                                    .font(.headline)
                                                Text("应该与上方融合")
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.95))
                                            .cornerRadius(12)
                                        },
                                        position: .bottom,
                                        id: "merge2"
                                    )
                                    
                                    popup.show(
                                        content: {
                                            VStack {
                                                Text("融合测试 3")
                                                    .font(.headline)
                                                Text("三个弹窗融合效果")
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.95))
                                            .cornerRadius(12)
                                        },
                                        position: .bottom,
                                        id: "merge3"
                                    )
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding()
                        }
                        
                        // 控制
                        GroupBox("控制") {
                            VStack(spacing: 12) {
                                Text("弹窗数量：\(PopupManager.shared.count)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Button("关闭所有弹窗") {
                                    PopupManager.shared.closeAll()
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .padding()
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("弹窗演示")
        }
    }
}

// MARK: - 预览
#Preview {
    PopupPreview()
        .withUI() // 添加弹窗支持
}