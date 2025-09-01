import SwiftUI

/// 弹窗视图
public struct PopupView: View {
    let popup: PopupData
    let onClose: () -> Void
    
    @State private var isVisible = false
    
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
                        popup.position == .bottom ? 200 : 0
                    )
                )
                .animation(.easeInOut(duration: 0.35), value: isVisible)
        }
        .zIndex(
            isVisible ? popup.zIndex : 
            popup.position == .bottom ? popup.zIndex - 100 : popup.zIndex - 50
        )
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
            } else {
                closePopup()
            }
        }
    }
    
    private func closePopup() {
        withAnimation(.easeInOut(duration: 0.35)) {
            isVisible = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
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
            .padding(.horizontal, 16)
            .frame(width: popup.width)
            .background(
                Rectangle()
                    .fill(Color.backgroundColor)
            )
            .clipped()
    }
}

/// 弹窗容器视图
public struct PopupContainer: View {
    @StateObject private var popupManager = PopupManager.shared
    @State private var isMaskVisible = true
    @State private var isClosing = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            if !popupManager.activePopups.isEmpty && isMaskVisible && !isClosing {
                Color.overlayColor
                    .ignoresSafeArea(.all, edges: .all)
                    .onTapGesture {
                        isClosing = true
                        withAnimation(.easeOut(duration: 0.35)) {
                            isMaskVisible = false
                        }
                        popupManager.closeAll()
                    }
            }
            
            ForEach(Array(popupManager.activePopups.enumerated()), id: \.element.id) { index, popup in
                PopupView(
                    popup: popup,
                    onClose: { 
                        popupManager.close(id: popup.id)
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: popup.position.alignment)
                .offset(x: popup.offset.x, y: popup.offset.y)
            }
        }
        .ignoresSafeArea(.all, edges: .all)
        .onReceive(popupManager.$activePopups) { popups in
            if popups.isEmpty {
                isClosing = false
                isMaskVisible = true
            } else if !isClosing {
                isMaskVisible = true
            }
        }
    }
}
