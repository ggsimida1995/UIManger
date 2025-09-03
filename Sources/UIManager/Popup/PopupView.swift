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
        ZStack {
            PopupContentView(popup: popup, onClose: closePopup)
                .opacity(isVisible ? 1 : 0)
                .scaleEffect(
                    isVisible ? 1 : (
                        popup.position == .center ? 0.3 : 1
                    )
                )
                .offset(
                    x: 0, 
                    y: isVisible ? 0 : (
                        popup.position == .top ? -300 : 
                        popup.position == .bottom ? 300 : 0  // 增加底部弹窗的滑入距离
                    )
                )
                .animation(.easeInOut(duration: 0.35), value: isVisible)
        }
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
        withAnimation(.easeInOut(duration: 0.25)) {
            isVisible = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            onClose()
        }
    }
}

/// 弹窗内容视图
private struct PopupContentView: View {
    let popup: PopupData
    let onClose: () -> Void
    
    var body: some View {
        popup.content
            .frame(width: popup.width)
            .clipped()
            .allowsHitTesting(true) // 确保弹窗内容能接收触摸事件
            .contentShape(Rectangle()) // 确保整个内容区域都能接收触摸事件
    }
}

/// 弹窗容器视图
public struct PopupContainer: View {
    @StateObject private var popupManager = PopupManager.shared
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // 统一的蒙层，只在有可见弹窗时显示（带淡入淡出动画）
            if !popupManager.activePopups.filter({ !$0.isClosing }).isEmpty {
                Color.overlayColor
                    .ignoresSafeArea(.all, edges: .all)
                    .contentShape(Rectangle()) // 确保整个区域都能接收触摸事件
                    .onTapGesture {
                        // 点击蒙层关闭所有弹窗
                        popupManager.closeAll()
                    }
                    .allowsHitTesting(true) // 确保蒙层能接收触摸事件
                    .transition(.opacity) // 添加淡入淡出过渡效果
                    .animation(.easeInOut(duration: 0.2), value: !popupManager.activePopups.filter({ !$0.isClosing }).isEmpty) // 添加动画
            }
            
            // 渲染所有弹窗
            ForEach(popupManager.activePopups) { popupData in
                PopupView(
                    popup: popupData,
                    onClose: { 
                        popupManager.close(id: popupData.id)
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: popupData.position.alignment)
                .offset(x: popupData.offset.x, y: popupData.offset.y)
                .zIndex(popupData.zIndex)
                .allowsHitTesting(true) // 确保弹窗能接收触摸事件
            }
        }
        .ignoresSafeArea(.all, edges: .all)
        .allowsHitTesting(true) // 确保整个容器能接收触摸事件
        .onTapGesture {
            // 防止触摸事件穿透到下层
            // 这个手势处理器会拦截所有触摸事件
        }
    }
}
