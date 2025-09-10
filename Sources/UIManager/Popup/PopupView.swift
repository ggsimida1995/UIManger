import SwiftUI

/// 弹窗视图
public struct PopupView: View {
    let popup: PopupData
    let onClose: () -> Void
    
    @State private var isVisible = false
    @State private var isClosing = false
    
    public init(popup: PopupData, onClose: @escaping () -> Void) {
        self.popup = popup
        self.onClose = onClose
    }
    
    public var body: some View {
        // 直接处理content，避免中间层干扰
        Group {
            if popup.width != nil || popup.height != nil {
                popup.content
                    .frame(width: popup.width, height: popup.height)
            } else {
                popup.content
            }
        }
        .clipped()
        .allowsHitTesting(true)
        .contentShape(Rectangle())

        .opacity(isVisible ? 1 : 0)
        .offset(
            x: 0,
            y: popup.position == .center ? 0 : (
                isVisible ? 0 : (
                    popup.position == .top ? 
                        -(popup.height ?? 300) - 100 : 
                        (popup.height ?? 300) + 100
                )
            )
        )

        .zIndex(popup.zIndex)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                isVisible = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ClosePopup"))) { notification in
            if let popupId = notification.userInfo?["popupId"] as? UUID {
                if popupId == popup.id {
                    closePopup()
                }
            }
            // 移除了无ID通知的处理，避免重复关闭
        }
    }
    
    private func closePopup() {
        guard !isClosing else { return } // 防止重复关闭
        
        isClosing = true
        
        // 根据弹窗位置使用不同的关闭动画
        if popup.position == .center {
            // 中心弹窗：缩放动画（使用系统默认时间）
            withAnimation(.easeInOut(duration: 0.25)) {
                isVisible = false
            }
        } else {
            // 顶部和底部弹窗：弹簧动画（增加回弹效果）
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
                isVisible = false
            }
        }
        
        // PopupManager 会自动处理弹窗的移除，不需要调用 onClose()
    }
}



/// 弹窗容器视图
public struct PopupContainer: View {
    @StateObject private var popupManager = PopupManager.shared
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // 统一的蒙层，使用独立的控制字段
            if popupManager.showOverlay {
                Color.overlayColor
                    .ignoresSafeArea(.all, edges: .all)
                    .contentShape(Rectangle()) // 确保整个区域都能接收触摸事件
                    .onTapGesture {
                        // 点击蒙层关闭所有弹窗
                        popupManager.closeAll()
                    }
                    .allowsHitTesting(true) // 确保蒙层能接收触摸事件
                    .transition(.opacity) // 添加淡入淡出过渡效果
                    .animation(.easeInOut(duration: 0.2), value: popupManager.showOverlay) // 添加动画
            }
            
            // 使用官方 GlassEffectContainer API 来让多个弹窗视觉融合
            GlassEffectContainer(spacing: 8) {
                VStack(spacing: 0) {
                    // 顶部弹窗 - 按layer排序（layer小的在上方）
                    let topPopups = popupManager.activePopups.filter { $0.position == .top }
                    if !topPopups.isEmpty {
                        
                            ForEach(topPopups.sorted(by: { $0.layer < $1.layer })) { popupData in
                                PopupView(
                                    popup: popupData,
                                    onClose: { 
                                        popupManager.close(id: popupData.id)
                                    }
                                )
                            }
                 
                    }
                    
                    // 中心弹窗（只有一个）
                    Spacer()
                    if let centerPopup = popupManager.activePopups.first(where: { $0.position == .center }) {
                        PopupView(
                            popup: centerPopup,
                            onClose: { 
                                popupManager.close(id: centerPopup.id)
                            }
                        )
                    }
                    Spacer()
                    
                    // 底部弹窗 - 按layer排序（layer小的在上方，layer大的靠近底部）
                    let bottomPopups = popupManager.activePopups.filter { $0.position == .bottom }
                    if !bottomPopups.isEmpty {
                      
                            ForEach(bottomPopups.sorted(by: { $0.layer < $1.layer })) { popupData in
                                PopupView(
                                    popup: popupData,
                                    onClose: { 
                                        popupManager.close(id: popupData.id)
                                    }
                                )
                            }
                     
                    }
                }
            }
        }
        .ignoresSafeArea(.all, edges: .all)
        .onTapGesture {
            // 防止触摸事件穿透到下层
            // 这个手势处理器会拦截所有触摸事件
        }
    }
}

