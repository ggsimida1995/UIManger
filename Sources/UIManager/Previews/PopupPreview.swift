import SwiftUI

/// 弹窗预览视图
public struct PopupPreview: View {
    @Environment(\.popup) var popup
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // 主要内容
            NavigationView {
                VStack(spacing: 20) {
                    Text("弹窗预览")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 16) {
                        // 基本弹窗
                        // closeAll 测试用例
                        GroupBox("closeAll 测试") {
                            VStack(spacing: 12) {
                                Button("测试 closeAll + 新弹窗") {
                                    // 先显示一个弹窗
                                    popup.show(
                                        content: {
                                            VStack {
                                                Text("第一个弹窗")
                                                    .font(.headline)
                                                Text("即将被关闭")
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding()
                                            .frame(width: 200, height: 100)
                                            .background(Color.red.opacity(0.1))
                                            .cornerRadius(8)
                                        },
                                        position: .top
                                    )
                                    
                                    // 立即关闭所有弹窗并显示新弹窗
                                    popup.closeAll()
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        popup.show(
                                            content: {
                                                VStack {
                                                    Text("新弹窗")
                                                        .font(.headline)
                                                    Text("应该保持显示")
                                                        .foregroundColor(.green)
                                                    Button("关闭") {
                                                        popup.closeAll()
                                                    }
                                                    .buttonStyle(.borderedProminent)
                                                }
                                                .padding()
                                                .frame(width: 250, height: 150)
                                                .background(Color.green.opacity(0.1))
                                                .cornerRadius(8)
                                            },
                                            position: .center
                                        )
                                    }
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        
                        // 底部弹窗堆叠测试
                        GroupBox("底部弹窗堆叠测试") {
                            VStack(spacing: 12) {
                                Button("显示底部弹窗1") {
                                    popup.show(
                                        content: {
                                            VStack {
                                                Text("底部弹窗1")
                                                    .font(.headline)
                                                Text("基础弹窗 - 应该在上层")
                                                    .foregroundColor(.blue)
                                                Button("关闭") {
                                                    popup.close(customId: "bottom1")
                                                }
                                                .buttonStyle(.borderedProminent)
                                            }
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 120)
                                            .background(Color.blue.opacity(0.1))
                                            .cornerRadius(8)
                                        },
                                        position: .bottom,
                                        height: 120,
                                        id: "bottom1"
                                    )
                                }
                                .buttonStyle(.bordered)
                                
                                Button("显示底部弹窗2") {
                                    popup.show(
                                        content: {
                                            VStack {
                                                Text("底部弹窗2")
                                                    .font(.headline)
                                                Text("新弹窗 - 从下方滑入")
                                                    .foregroundColor(.green)
                                                Button("关闭") {
                                                    popup.close(customId: "bottom2")
                                                }
                                                .buttonStyle(.borderedProminent)
                                            }
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 100)
                                            .background(Color.green.opacity(0.1))
                                            .cornerRadius(8)
                                        },
                                        position: .bottom,
                                        height: 100,
                                        id: "bottom2"
                                    )
                                }
                                .buttonStyle(.bordered)
                                
                                Button("显示底部弹窗3") {
                                    popup.show(
                                        content: {
                                            VStack {
                                                Text("底部弹窗3")
                                                    .font(.headline)
                                                Text("第三个弹窗 - 也从下方滑入")
                                                    .foregroundColor(.orange)
                                                Button("关闭") {
                                                    popup.close(customId: "bottom3")
                                                }
                                                .buttonStyle(.borderedProminent)
                                            }
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 90)
                                            .background(Color.orange.opacity(0.1))
                                            .cornerRadius(8)
                                        },
                                        position: .bottom,
                                        height: 90,
                                        id: "bottom3"
                                    )
                                }
                                .buttonStyle(.bordered)
                                
                                Button("关闭所有底部弹窗") {
                                    popup.close(customId: "bottom1")
                                    popup.close(customId: "bottom2")
                                    popup.close(customId: "bottom3")
                                }
                                .buttonStyle(.bordered)
                                .foregroundColor(.red)
                            }
                        }
                        
                        GroupBox("基本弹窗") {
                            VStack(spacing: 12) {
                                Button("中心弹窗") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 16) {
                                                Text("这是一个弹窗")
                                                    .font(.headline)
                                                
                                                Text("支持多种位置和自定义内容")
                                                    .font(.subheadline)
                                                    .foregroundColor(Color.secondaryTextColor)
                                                
                                                Button("关闭") {
                                                    popup.closeAll()
                                                }
                                                .buttonStyle(.borderedProminent)
                                            }
                                            .padding()
                                            .frame(width: 300, height: 200)
                                            .background(Color.backgroundColor)
                                            .cornerRadius(12)
                                            .shadow(radius: 8)
                                        },
                                        position: .center
                                    )
                                }
                                .buttonStyle(.bordered)
                                
                                Button("顶部弹窗") {
                                    popup.show(
                                        content: {
                                            HStack {
                                                Image(systemName: "info.circle.fill")
                                                    .foregroundColor(Color.primaryColor)
                                                Text("顶部提示信息")
                                                    .font(.headline)
                                                    .foregroundColor(Color.textColor)
                                            }
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.primaryColor.opacity(0.1))
                                            .frame(height: 120)
                                            .background(Color.backgroundColor)
                                            .cornerRadius(8)
                                            .shadow(radius: 4)
                                        },
                                        position: .top,
                                        showCloseButton: false
                                    )
                                }
                                .buttonStyle(.bordered)
                                
                                Button("底部弹窗") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 16) {
                                                Text("底部操作菜单")
                                                    .font(.headline)
                                                    .foregroundColor(Color.textColor)
                                                
                                                Divider()
                                                    .background(Color.separatorColor)
                                                
                                                Button("选项1") {
                                                    popup.closeAll()
                                                }
                                                .buttonStyle(.bordered)
                                                
                                                Button("选项2") {
                                                    popup.closeAll()
                                                }
                                                .buttonStyle(.bordered)
                                            }
                                            .padding()
                                            .frame(height: 200)
                                            .background(Color.backgroundColor)
                                            .cornerRadius(12)
                                            .shadow(radius: 8)
                                        },
                                        position: .bottom
                                    )
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        
                        // 多弹窗演示
                        GroupBox("多弹窗演示") {
                            VStack(spacing: 12) {
                                Button("显示多个弹窗") {
                                    // 同时显示三个弹窗：一个在顶部，两个在底部
                                    
                                    // 1. 先显示顶部弹窗
                                    popup.show(
                                        content: {
                                            VStack(spacing: 12) {
                                                Text("顶部弹窗1")
                                                    .font(.headline)
                                                    .foregroundColor(Color.textColor)
                                            }
                                            .frame(height: 120)
                                            .background(Color.backgroundColor)
                                            .cornerRadius(8)
                                            .shadow(radius: 4)
                                        },
                                        position: .top,
                                        width: nil,
                                        height: 120,
                                        id: "top-popup"
                                    )
                                    
                                    // 2. 显示底部弹窗1（绿色，作为基础弹窗）
                                    popup.show(
                                        content: {
                                            VStack(spacing: 12) {
                                                Text("底部弹窗1")
                                                    .font(.headline)
                                                    .foregroundColor(Color.textColor)

                                                // 控制按钮
                                                HStack(spacing: 12) {
                                                    Button("切换弹窗2/3") {
                                                        // 检查当前显示的是哪个弹窗
                                                        if popup.activePopups.contains(where: { $0.customId == "bottom-popup-2" }) {
                                                            // 当前显示的是弹窗2，切换到弹窗3
                                                            popup.close(customId: "bottom-popup-2")
                                                            
                                                            // 等待0.35秒后显示弹窗3
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                                                popup.show(
                                                                    content: {
                                                                        VStack(spacing: 12) {
                                                                            Text("底部弹窗3")
                                                                                .font(.headline)
                                                                                .foregroundColor(Color.textColor)
                                                                        }
                                                                        .frame(height: 150)
                                                                        .background(Color.backgroundColor)
                                                                        .cornerRadius(12)
                                                                        .shadow(radius: 8)
                                                                    },
                                                                    position: .bottom,
                                                                    width: nil,
                                                                    height: 150,
                                                                    id: "bottom-popup-3"
                                                                )
                                                            }
                                                        } else if popup.activePopups.contains(where: { $0.customId == "bottom-popup-3" }) {
                                                            // 当前显示的是弹窗3，切换到弹窗2
                                                            popup.close(customId: "bottom-popup-3")
                                                            
                                                            // 等待0.35秒后显示弹窗2
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                                                popup.show(
                                                                    content: {
                                                                        VStack(spacing: 12) {
                                                                            Text("底部弹窗2")
                                                                                .font(.headline)
                                                                                .foregroundColor(Color.textColor)
                                                                        }
                                                                        .frame(height: 100)
                                                                        .background(Color.backgroundColor)
                                                                        .cornerRadius(12)
                                                                        .shadow(radius: 8)
                                                                    },
                                                                    position: .bottom,
                                                                    width: nil,
                                                                    height: 100,
                                                                    id: "bottom-popup-2"
                                                                )
                                                            }
                                                        }
                                                    }
                                                    .buttonStyle(.bordered)
                                                    .font(.caption)
                                                }
                                            }
                                            .frame(height: 150)
                                            .background(Color.backgroundColor)
                                            .cornerRadius(12)
                                            .shadow(radius: 8)
                                        },
                                        position: .bottom,
                                        width: nil,
                                        height: 150,
                                        id: "bottom-popup-1"
                                    )
                                    
                                    // 3. 显示底部弹窗2（橙色，拼接在弹窗1上方）
                                    popup.show(
                                        content: {
                                            VStack(spacing: 12) {
                                                Text("底部弹窗2")
                                                    .font(.headline)
                                                    .foregroundColor(Color.textColor)
                                            }
                                            .frame(height: 100)
                                            .background(Color.backgroundColor)
                                            .cornerRadius(12)
                                            .shadow(radius: 8)
                                        },
                                        position: .bottom,
                                        width: nil,
                                        height: 100,
                                        id: "bottom-popup-2"
                                    )
                                }
                                .buttonStyle(.borderedProminent)
                                
                                // 添加专门的拼接测试按钮
                                Button("测试弹窗拼接") {
                                    // 清空现有弹窗
                                    popup.closeAll()
                                    
                                    // 按顺序显示底部弹窗，测试拼接效果
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                        popup.show(
                                            content: {
                                                ZStack {
                                                    Rectangle()
                                                        .fill(Color.primaryColor)
                                                    VStack(spacing: 4) {
                                                        Text("弹窗A")
                                                            .font(.headline)
                                                            .foregroundColor(.white)
                                                        Text("高度: 100")
                                                            .font(.caption)
                                                            .foregroundColor(.white.opacity(0.8))
                                                    }
                                                }
                                                .frame(height: 100)
                                                .cornerRadius(12)
                                                .shadow(radius: 8)
                                            },
                                            position: .bottom,
                                            width: nil,
                                            height: 100,
                                            id: "popup-a"
                                        )
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        popup.show(
                                            content: {
                                                ZStack {
                                                    Rectangle()
                                                        .fill(Color.successColor)
                                                    VStack(spacing: 4) {
                                                        Text("弹窗B")
                                                            .font(.headline)
                                                            .foregroundColor(.white)
                                                        Text("高度: 100")
                                                            .font(.caption)
                                                            .foregroundColor(.white.opacity(0.8))
                                                    }
                                                }
                                                .frame(height: 100)
                                                .cornerRadius(12)
                                                .shadow(radius: 8)
                                            },
                                            position: .bottom,
                                            width: nil,
                                            height: 100,
                                            id: "popup-b"
                                        )
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        popup.show(
                                            content: {
                                                ZStack {
                                                    Rectangle()
                                                        .fill(Color.primaryButtonText)
                                                    VStack(spacing: 4) {
                                                        Text("弹窗C")
                                                            .font(.headline)
                                                            .foregroundColor(.white)
                                                        Text("高度: 100")
                                                            .font(.caption)
                                                            .foregroundColor(.white.opacity(0.8))
                                                    }
                                                }
                                                .frame(height: 100)
                                                .cornerRadius(12)
                                                .shadow(radius: 8)
                                            },
                                            position: .bottom,
                                            width: nil,
                                            height: 100,
                                            id: "popup-c"
                                        )
                                    }
                                }
                                .buttonStyle(.bordered)
                                
                                                                                Text("弹窗3中包含控制弹窗2显示隐藏的按钮")
                                                    .font(.caption)
                                                    .foregroundColor(Color.secondaryTextColor)
                            }
                        }
                        
                        // 自定义弹窗
                        GroupBox("自定义弹窗") {
                            VStack(spacing: 12) {
                                Button("表单弹窗") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 16) {
                                                Text("用户信息")
                                                    .font(.headline)
                                                    .foregroundColor(Color.textColor)
                                                
                                                TextField("姓名", text: .constant(""))
                                                    .textFieldStyle(.roundedBorder)
                                                
                                                TextField("邮箱", text: .constant(""))
                                                    .textFieldStyle(.roundedBorder)
                                                
                                                Button("保存") {
                                                    popup.closeAll()
                                                }
                                                .buttonStyle(.borderedProminent)
                                            }
                                            .padding()
                                            .frame(width: 300, height: 200)
                                            .background(Color.backgroundColor)
                                            .cornerRadius(12)
                                            .shadow(radius: 8)
                                        },
                                        position: .center,
                                        width: 300,
                                        height: 200
                                    )
                                }
                                .buttonStyle(.bordered)
                                
                                Button("确认弹窗") {
                                    popup.show(
                                        content: {
                                            VStack(spacing: 16) {
                                                Text("确认删除")
                                                    .font(.headline)
                                                    .foregroundColor(Color.textColor)
                                                Text("此操作不可撤销")
                                                    .font(.subheadline)
                                                    .foregroundColor(Color.secondaryTextColor)
                                                
                                                HStack(spacing: 12) {
                                                    Button("取消") {
                                                        popup.closeAll()
                                                    }
                                                    .buttonStyle(.bordered)
                                                    
                                                    Button("删除") {
                                                        popup.closeAll()
                                                    }
                                                    .buttonStyle(.borderedProminent)
                                                }
                                            }
                                            .padding()
                                            .frame(width: 300, height: 150)
                                            .background(Color.backgroundColor)
                                            .cornerRadius(12)
                                            .shadow(radius: 8)
                                        },
                                        position: .center,
                                        width: 300,
                                        height: 150
                                    )
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        
                        // 控制按钮
                        GroupBox("控制") {
                            VStack(spacing: 8) {
                                Text("当前弹窗数量: \(popup.count)")
                                    .font(.caption)
                                    .foregroundColor(Color.secondaryTextColor)
                                
                                Button("关闭所有弹窗") {
                                    popup.closeAll()
                                }
                                .buttonStyle(.bordered)
                                .font(.caption)
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            
            // 弹窗容器
            PopupContainer()
        }
        .withUI()
    }
}

#if DEBUG
struct PopupPreview_Previews: PreviewProvider {
    static var previews: some View {
        PopupPreview()
    }
}
#endif
