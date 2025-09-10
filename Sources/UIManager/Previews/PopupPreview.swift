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
                                // 中心弹窗 - 屏幕宽度，固定高度
                                Button("中心弹窗 (屏幕宽度)") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 16) {
                                                Text("中心弹窗")
                                                    .font(.headline)
                                                Text("width: nil (屏幕宽度), height: 200")
                                                    .foregroundColor(.secondary)
                                                
                                                // 添加横向内容来验证屏幕宽度
                                                HStack {
                                                    Rectangle()
                                                        .fill(Color.red.opacity(0.3))
                                                        .frame(width: 50, height: 50)
                                                    Spacer()
                                                    Text("应该占满屏幕宽度")
                                                        .font(.caption)
                                                    Spacer()
                                                    Rectangle()
                                                        .fill(Color.blue.opacity(0.3))
                                                        .frame(width: 50, height: 50)
                                                }
                                                
                                                Button("关闭") {
                                                    // 弹窗会自动处理关闭
                                                }
                                                .buttonStyle(.borderedProminent)
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.95))
                                            .cornerRadius(12)
                                        },
                                        position: .center,
                                        width: nil,  // 使用屏幕宽度
                                        height: 200
                                    )
                                }
                                .buttonStyle(.bordered)
                                
                                // 顶部弹窗 - 宽度自适应，固定高度
                                Button("顶部弹窗 (宽度自适应)") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 16) {
                                                Text("顶部弹窗")
                                                    .font(.headline)
                                                Text("width: nil (自适应), height: 150")
                                                    .foregroundColor(.secondary)
                                                HStack {
                                                    Rectangle()
                                                        .fill(Color.blue.opacity(0.3))
                                                        .frame(width: 40, height: 40)
                                                    Spacer()
                                                    Text("应该填满宽度")
                                                        .font(.caption)
                                                    Spacer()
                                                    Rectangle()
                                                        .fill(Color.green.opacity(0.3))
                                                        .frame(width: 40, height: 40)
                                                }
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.95))
                                            .cornerRadius(12)
                                        },
                                        position: .top,
                                        width: nil,
                                        height: 250
                                    )
                                }
                                .buttonStyle(.bordered)
                                
                                // 底部弹窗 - 宽度屏幕，高度自适应
                                Button("底部弹窗 (高度自适应)") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 16) {
                                                Text("底部弹窗")
                                                    .font(.headline)
                                                Text("width: nil (屏幕宽度), height: nil (自适应)")
                                                    .foregroundColor(.secondary)
                                                
                                                // 动态内容测试自适应
                                                VStack(alignment: .leading, spacing: 8) {
                                                    Text("• 这是一行文本")
                                                    Text("• 这是另一行更长的文本内容，用来测试高度自适应")
                                                    Text("• 第三行文本")
                                                    Text("• 高度会根据这些内容自动调整")
                                                }
                                                .font(.caption)
                                                
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
                                        position: .bottom,
                                        width: nil,
                                        height: nil  // 高度自适应
                                    )
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding()
                        }
                        
                        // 尺寸自适应演示
                        GroupBox("尺寸自适应演示") {
                            VStack(spacing: 12) {
                                // 1. 指定宽度，高度自适应
                                Button("指定宽度，高度自适应") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 12) {
                                                Text("固定宽度弹窗")
                                                    .font(.headline)
                                                Text("width: 280, height: nil")
                                                    .foregroundColor(.secondary)
                                                    .font(.caption)
                                                
                                                Text("这是一段较长的文本内容，用来测试高度自适应功能。高度会根据内容自动调整，但宽度固定为280pt。")
                                                    .multilineTextAlignment(.center)
                                                    .font(.body)
                                                
                                                Button("确定") {
                                                    print("确定")
                                                }
                                                .buttonStyle(.borderedProminent)
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.95))
                                            .cornerRadius(12)
                                        },
                                        position: .center,
                                        width: 280,
                                        height: nil
                                    )
                                }
                                .buttonStyle(.bordered)
                                
                                // 2. 宽度和高度都自适应
                                Button("宽度高度都自适应") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 12) {
                                                Text("完全自适应弹窗")
                                                    .font(.headline)
                                                Text("width: nil, height: nil")
                                                    .foregroundColor(.secondary)
                                                    .font(.caption)
                                                
                                                Text("短内容")
                                                    .font(.body)
                                                
                                                HStack(spacing: 8) {
                                                    Button("取消") { }
                                                        .buttonStyle(.bordered)
                                                    Button("确定") { }
                                                        .buttonStyle(.borderedProminent)
                                                }
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.95))
                                            .cornerRadius(12)
                                        },
                                        position: .center,
                                        width: nil,
                                        height: nil
                                    )
                                }
                                .buttonStyle(.bordered)
                                
                                // 3. 动态内容高度自适应
                                Button("动态内容高度自适应") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 12) {
                                                Text("动态内容弹窗")
                                                    .font(.headline)
                                                Text("width: 300, height: nil")
                                                    .foregroundColor(.secondary)
                                                    .font(.caption)
                                                
                                                VStack(alignment: .leading, spacing: 6) {
                                                    ForEach(1...Int.random(in: 3...7), id: \.self) { i in
                                                        Text("• 动态生成的第 \(i) 行内容")
                                                            .font(.body)
                                                    }
                                                }
                                                
                                                Button("刷新内容") {
                                                    // 这会关闭当前弹窗并重新生成
                                                    PopupManager.shared.closeAll()
                                                }
                                                .buttonStyle(.borderedProminent)
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.95))
                                            .cornerRadius(12)
                                        },
                                        position: .center,
                                        width: 300,
                                        height: nil
                                    )
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding()
                        }
                        
                        // 防重复弹窗演示
                        GroupBox("防重复弹窗演示") {
                            VStack(spacing: 12) {
                                HStack {
                                    Text("状态: ")
                                    Text(PopupManager.shared.isShowing(id: "unique-popup") ? "已显示" : "未显示")
                                        .foregroundColor(PopupManager.shared.isShowing(id: "unique-popup") ? .green : .secondary)
                                        .fontWeight(.medium)
                                }
                                .font(.caption)
                                
                                Button("多次点击我试试 (ID: unique-popup)") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 16) {
                                                Text("唯一弹窗")
                                                    .font(.headline)
                                                
                                                Text("这个弹窗有固定ID: 'unique-popup'")
                                                    .foregroundColor(.secondary)
                                                    .font(.caption)
                                                
                                                Text("无论你点击多少次按钮，都只会显示一个弹窗")
                                                    .multilineTextAlignment(.center)
                                                
                                                Button("关闭") {
                                                    PopupManager.shared.close(customId: "unique-popup")
                                                }
                                                .buttonStyle(.borderedProminent)
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.95))
                                            .cornerRadius(12)
                                        },
                                        position: .center,
                                        width: 280,
                                        height: nil,
                                        id: "unique-popup"
                                    )
                                }
                                .buttonStyle(.borderedProminent)
                                
                                Button("可重复弹窗 (无ID)") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 16) {
                                                Text("可重复弹窗")
                                                    .font(.headline)
                                                
                                                Text("这个弹窗没有ID，可以重复显示")
                                                    .foregroundColor(.secondary)
                                                    .font(.caption)
                                                
                                                Text("每次点击都会创建新的弹窗实例")
                                                    .multilineTextAlignment(.center)
                                                
                                                Button("关闭全部") {
                                                    PopupManager.shared.closeAll()
                                                }
                                                .buttonStyle(.borderedProminent)
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.95))
                                            .cornerRadius(12)
                                        },
                                        position: .center,
                                        width: 280,
                                        height: nil
                                        // 没有传入id参数，所以可以重复创建
                                    )
                                }
                                .buttonStyle(.bordered)
                                
                                HStack(spacing: 12) {
                                    Button("检查弹窗状态") {
                                        let isShowing = PopupManager.shared.isShowing(id: "unique-popup")
                                        print("unique-popup 是否显示: \(isShowing)")
                                    }
                                    .buttonStyle(.bordered)
                                    .font(.caption)
                                    
                                    Button("弹窗总数: \(PopupManager.shared.count)") {
                                        print("当前弹窗总数: \(PopupManager.shared.count)")
                                    }
                                    .buttonStyle(.bordered)
                                    .font(.caption)
                                }
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
                                        width: nil,
                                        height: 120,
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
                                        width: nil,
                                        height: 120,
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
                                        width: nil,
                                        height: 100,
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
                                        width: nil,
                                        height: 100,
                                        id: "bottom2"
                                    )
                                }
                                .buttonStyle(.borderedProminent)
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
