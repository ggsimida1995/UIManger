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
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .glassEffect(in: .rect(cornerRadius: 16.0))
                                            
                                        },
                                        position: .center,
                                        width: 300,
                                        height: nil
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
                                            .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
                                            .glassEffect(in: .rect(cornerRadius: 16.0))
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
                                            .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
                                            .glassEffect(in: .rect(cornerRadius: 16.0))
                                        },
                                        position: .bottom,
                                        width: nil,
                                        height: 450  // 高度自适应
                                    )
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding()
                        }
                        
                        // 多弹窗演示
                        GroupBox("多弹窗演示") {
                            VStack(spacing: 12) {
                                Button("显示传统多弹窗") {
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
                                .buttonStyle(.bordered)
                                
                                Button("智能切换弹窗演示") {
                                    // 先清空所有弹窗
                                    popup.closeAll()
                                    
                                    // 延迟显示新弹窗
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        
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
                                                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
                                                .glassEffect(in: .rect(cornerRadius: 16.0))
                                            },
                                            position: .top,
                                            width: nil,
                                            height: 250
                                        )
                                        
                                        // 显示A弹窗（layer 0）
                                        popup.show(
                                            content: {
                                                SmartPopupContentA(popupManager: popup)
                                            },
                                            position: .bottom,
                                            width: nil,
                                            height: 60,
                                            id: "smartA",
                                            layer: 0
                                        )
                                        
                                        // 显示B弹窗（layer 1，在底部）
                                        popup.show(
                                            content: {
                                                SmartPopupContentB(popupManager: popup)
                                            },
                                            position: .bottom,
                                            width: nil,
                                            height: 140,
                                            id: "smartB",
                                            layer: 1
                                        )
                                    }
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

// MARK: - 智能切换弹窗内容组件

/// A弹窗内容（用于演示智能切换）
struct SmartPopupContentA: View {
    let popupManager: PopupManager
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("弹窗 A")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                Spacer()
                Text("Layer 0")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Capsule())
            }
            
            Text("我是A弹窗，在B弹窗的上方")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 10) {
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 30, height: 30)
                Text("点击B弹窗中的按钮来切换我为C")
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
        }.border(Color.red,width: 1)
        .padding()
        // .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
                                                .glassEffect(in: .rect(cornerRadius: 16.0))
        .border(Color.red,width: 1)

    }
}

/// C弹窗内容（用于演示智能切换）
struct SmartPopupContentC: View {
    let popupManager: PopupManager
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("弹窗 C")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
                Spacer()
                Text("Layer 0")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.1))
                    .clipShape(Capsule())
            }
            
            Text("我是C弹窗，替换了A弹窗的位置")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 10) {
                Circle()
                    .fill(Color.orange.opacity(0.3))
                    .frame(width: 30, height: 30)
                Text("点击B弹窗中的按钮来切换回A")
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
        }.border(Color.red,width: 1)
        .padding()
     
        // .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
                                                .glassEffect(in: .rect(cornerRadius: 16.0))
                                                   .border(Color.red,width: 1)
    }
}

/// B弹窗内容（用于演示智能切换）
struct SmartPopupContentB: View {
    let popupManager: PopupManager
    @State private var currentTopPopup = "A" // 当前顶层弹窗
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("弹窗 B - 控制器")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                Spacer()
                Text("Layer 1")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.green.opacity(0.1))
                    .clipShape(Capsule())
            }
            
            Text("我始终在底部，控制上方弹窗的切换")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                Button(currentTopPopup == "A" ? "切换为 C" : "切换为 A") {
                    if currentTopPopup == "A" {
                        switchToC()
                    } else {
                        switchToA()
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                
                Text("当前: \(currentTopPopup)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }.border(Color.red,width: 1)
        .padding()
        // .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
         .glassEffect(in: .rect(cornerRadius: 16.0))
         .border(Color.red,width: 1)
    }
    
    /// 切换到C弹窗
    private func switchToC() {
        popupManager.smartToggle(
            customId: "smartC",
            content: {
                SmartPopupContentC(popupManager: popupManager)
            },
            position: .bottom,
            width: nil,
            height: 180,
            replaceTargetId: "smartA"
        )
        currentTopPopup = "C"
    }
    
    /// 切换回A弹窗
    private func switchToA() {
        popupManager.smartToggle(
            customId: "smartA",
            content: {
                SmartPopupContentA(popupManager: popupManager)
            },
            position: .bottom,
            width: nil,
            height: 60,
            replaceTargetId: "smartC"
        )
        currentTopPopup = "A"
    }
}

// MARK: - 预览
#Preview {
    PopupPreview()
        .withUI() // 添加弹窗支持
}
