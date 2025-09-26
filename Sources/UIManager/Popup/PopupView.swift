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
    
    // 统一的弹簧动画配置
    private var springAnimation: Animation {
        .spring(response: 0.3, dampingFraction: 0.95, blendDuration: 0)
    }
    
    public var body: some View {
        Group {
            if let height = popup.height {
                popup.content
                    .frame(maxWidth: .infinity, maxHeight: height)
            } else {
                popup.content
                    .frame(maxWidth: .infinity)
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
                        -(popup.height ?? 200) - 50 : 
                        (popup.height ?? 200) + 50
                )
            )
        )
        .animation(springAnimation, value: isVisible)
        .onAppear {
            withAnimation(springAnimation) {
                isVisible = true
            }
        }
        .onDisappear {
            withAnimation(springAnimation) {
                isVisible = false
            }
        }
        .preferredColorScheme(.light)
    }
}

/// 弹窗容器视图
public struct PopupContainer: View {
    @StateObject private var popupManager = PopupManager.shared
    
    public init() {}
    
    // 统一的弹簧动画配置
    private var springAnimation: Animation {
        .spring(response: 0.3, dampingFraction: 0.95, blendDuration: 0)
    }
    
    public var body: some View {
        ZStack {
            // 蒙层
            if popupManager.showOverlay {
                Color.overlayColor
                    .ignoresSafeArea(.all, edges: .all)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        popupManager.closeAll()
                    }
                    .allowsHitTesting(true)
                    .transition(.opacity.animation(springAnimation))
            }
            
            // 弹窗内容
            VStack(spacing: 0) {
                // 顶部弹窗
                if let topPopup = popupManager.topPopup {
                    PopupView(popup: topPopup) {
                        popupManager.close(position: .top)
                    }
                    .zIndex(1000)
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity).animation(springAnimation),
                        removal: .move(edge: .top).combined(with: .opacity).animation(springAnimation)
                    ))
                }
                
                Spacer()
                
                // 中心弹窗
                if let centerPopup = popupManager.centerPopup {
                    PopupView(popup: centerPopup) {
                        popupManager.close(position: .center)
                    }
                    .zIndex(2000)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity).animation(springAnimation),
                        removal: .scale.combined(with: .opacity).animation(springAnimation)
                    ))
                }
                
                Spacer()
                
                // 底部弹窗 - 层级最高
                if let bottomPopup = popupManager.bottomPopup {
                    PopupView(popup: bottomPopup) {
                        popupManager.close(position: .bottom)
                    }
                    .zIndex(3000)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity).animation(springAnimation),
                        removal: .move(edge: .bottom).combined(with: .opacity).animation(springAnimation)
                    ))
                }
            }
        }
        .ignoresSafeArea(.all, edges: .all)
        .allowsHitTesting(popupManager.hasActivePopups)
    }
}
