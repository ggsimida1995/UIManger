import SwiftUI

/// 弹窗组件演示
public struct PopupDemo: View {
    @Environment(\.popup) var popup
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("弹窗演示")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 16) {
                        // 基本弹窗
                        GroupBox("基本弹窗") {
                            VStack(spacing: 12) {
                                Button("顶部弹窗") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 12) {
                                                Text("顶部弹窗")
                                                    .font(.headline)
                                                Text("这是一个顶部弹窗示例")
                                                    .foregroundColor(.secondary)
                                                Button("关闭") {
                                                    popup.close(position: .top)
                                                }
                                                .buttonStyle(.borderedProminent)
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.95))
                                            .cornerRadius(12)
                                        },
                                        position: .top
                                    )
                                }
                                .buttonStyle(.bordered)
                                
                                Button("中心弹窗") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 12) {
                                                Text("中心弹窗")
                                                    .font(.headline)
                                                Text("这是一个中心弹窗示例")
                                                    .foregroundColor(.secondary)
                                                Button("关闭") {
                                                    popup.close(position: .center)
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
                                
                                Button("底部弹窗") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 12) {
                                                Text("底部弹窗")
                                                    .font(.headline)
                                                Text("这是一个底部弹窗示例")
                                                    .foregroundColor(.secondary)
                                                Button("关闭") {
                                                    popup.close(position: .bottom)
                                                }
                                                .buttonStyle(.borderedProminent)
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
                        
                        // 高度控制演示
                        GroupBox("高度控制演示") {
                            VStack(spacing: 12) {
                                Button("固定高度顶部弹窗 (150pt)") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 12) {
                                                Text("固定高度弹窗")
                                                    .font(.headline)
                                                Text("高度: 150pt")
                                                    .foregroundColor(.secondary)
                                                Spacer()
                                                Button("关闭") {
                                                    popup.close(position: .top)
                                                }
                                                .buttonStyle(.borderedProminent)
                                            }
                                            .padding()
                                            .background(Color.blue.opacity(0.1))
                                            .cornerRadius(12)
                                        },
                                        position: .top,
                                        height: 150
                                    )
                                }
                                .buttonStyle(.bordered)
                                
                                Button("固定高度底部弹窗 (200pt)") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 12) {
                                                Text("固定高度底部弹窗")
                                                    .font(.headline)
                                                Text("高度: 200pt")
                                                    .foregroundColor(.secondary)
                                                
                                                HStack {
                                                    Button("选项1") {
                                                        print("选择了选项1")
                                                    }
                                                    .buttonStyle(.borderedProminent)
                                                    
                                                    Button("选项2") {
                                                        print("选择了选项2")
                                                    }
                                                    .buttonStyle(.bordered)
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding()
                                            .background(Color.green.opacity(0.1))
                                            .cornerRadius(12)
                                        },
                                        position: .bottom,
                                        height: 200
                                    )
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding()
                        }
                        
                        // 设置弹窗演示
                        GroupBox("设置弹窗演示") {
                            VStack(spacing: 12) {
                                Button("显示设置弹窗") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 12) {
                                                Text("设置弹窗")
                                                    .font(.headline)
                                                Text("这是一个设置弹窗示例")
                                                    .foregroundColor(.secondary)
                                                
                                                VStack(alignment: .leading, spacing: 8) {
                                                    HStack {
                                                        Text("通知")
                                                        Spacer()
                                                        Toggle("", isOn: .constant(true))
                                                    }
                                                    HStack {
                                                        Text("声音")
                                                        Spacer()
                                                        Toggle("", isOn: .constant(false))
                                                    }
                                                }
                                                .padding()
                                                .background(Color.gray.opacity(0.1))
                                                .cornerRadius(8)
                                                
                                                Button("关闭") {
                                                    popup.close(position: .bottom)
                                                }
                                                .buttonStyle(.borderedProminent)
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.95))
                                            .cornerRadius(12)
                                        },
                                        position: .bottom,
                                        height: 180
                                    )
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .padding()
                        }
                        
                        // 动态高度控制演示
                        GroupBox("动态高度控制") {
                            VStack(spacing: 12) {
                                Text("弹窗内部动态切换高度")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Button("显示动态高度弹窗") {
                                    popup.show(
                                        content: {
                                            SimpleHeightSwitchPopup()
                                        },
                                        position: .bottom,
                                        height: nil  // 让内容自适应
                                    )
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .padding()
                        }
                        
                        // 控制
                        GroupBox("控制") {
                            VStack(spacing: 12) {
                                Text("弹窗数量：\(popup.count)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Button("关闭所有弹窗") {
                                    popup.closeAll()
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

// MARK: - 简单高度切换弹窗组件

/// 简单的视图切换弹窗（在switchA和switchB之间切换）
struct SimpleHeightSwitchPopup: View {
    @State private var isShowingA: Bool = true
    @State private var showViewA: Bool = true
    @State private var showViewB: Bool = false
     // 定义弹簧动画参数
    private var springAnimation: Animation {
        Animation.spring(
            response: 0.3,  // 响应时间，控制动画速度
            dampingFraction: 0.95,  // 阻尼系数，值越小弹性越强
            blendDuration: 0  // 混合时间，控制动画过渡
        )
    }
    var body: some View {
        VStack(spacing: 0) {
            // 当前显示的视图
            ZStack {
                if showViewA {
                    SwitchViewA()
                        .transition(.offset(y: 1000)) // 从屏幕底部外进入
                }
                
                if showViewB {
                    SwitchViewB()
                        .transition(.offset(y: 1000)) // 从屏幕底部外进入
                }
            }
            
            // 切换按钮
            VStack{
                Button("切换视图 (\(isShowingA ? "A → B" : "B → A"))") {
                    switchViews()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.regular)
            }.frame(height: 70)
                .frame(maxWidth: .infinity)
                .glassEffect(in: RoundedRectangle(cornerRadius: 0))
        }
        .frame(maxWidth: .infinity)
    }
    
    private func switchViews() {
        if isShowingA {
            // 当前显示A，要切换到B
            // 第一步：A视图退出 - 快速且少弹性的退出动画
            withAnimation(springAnimation) {
                showViewA = false
            }
            
            // 第二步：等待A退出动画完成后，B视图进入 - 较慢且有弹性的进入动画
            withAnimation(springAnimation) {
                showViewB = true
                isShowingA = false
            }
        } else {
            // 当前显示B，要切换到A
            // 第一步：B视图退出 - 快速且少弹性的退出动画
            withAnimation(springAnimation) {
                showViewB = false
            }
            
            // 第二步：等待B退出动画完成后，A视图进入 - 较慢且有弹性的进入动画
            withAnimation(springAnimation) {
                showViewA = true
                isShowingA = true
            }
        }
    }
}

// MARK: - 切换视图组件

/// SwitchA 视图
struct SwitchViewA: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("视图 A")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Text("这是第一个视图")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                ForEach(1...3, id: \.self) { index in
                    HStack {
                        Circle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: 20, height: 20)
                        Text("项目 \(index)")
                            .font(.body)
                        Spacer()
                        Text("A")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
        .frame(height: 100)
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue, lineWidth: 2)
        )
        .frame(maxWidth: .infinity)
        .glassEffect(in: RoundedRectangle(cornerRadius: 0))
    }
}

/// SwitchB 视图
struct SwitchViewB: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("视图 B")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            Text("这是第二个视图")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                ForEach(1...4, id: \.self) { index in
                    VStack(spacing: 4) {
                        Rectangle()
                            .fill(Color.green.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .cornerRadius(8)
                        Text("\(index)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                }
            }
            
            Text("不同的布局和内容")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(height: 180)
        .background(Color.green.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.green, lineWidth: 2)
        )
        .frame(maxWidth: .infinity)
        .glassEffect(in: RoundedRectangle(cornerRadius: 0))
    }
}

// MARK: - 预览
#Preview {
    PopupDemo()
        .withPopup()
}
