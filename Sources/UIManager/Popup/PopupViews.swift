import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Popup 容器视图
public struct PopupContainerView: View {
    @ObservedObject private var popupManager = PopupManager.shared
    @Environment(\.colorScheme) private var colorScheme
    
    let popup: PopupData
    let screenSize: CGSize
    let safeArea: EdgeInsets
    
    public var body: some View {
        contentView
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: popup.position.getAlignment())
            .animation(popup.config.animation, value: true)
    }
    
    // 内容视图
    @ViewBuilder
    private var contentView: some View {
        let content = popupContent
        
        if case .absolute(let left, let top, let right, let bottom) = popup.position {
            GeometryReader { geo in
                content
                    .position(
                        absolutePosition(
                            left: left, top: top, right: right, bottom: bottom,
                            screenSize: geo.size,
                            contentSize: estimateContentSize(geo: geo)
                        )
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            content
        }
    }
    
    // 弹窗内容
    private var popupContent: some View {
        popup.content
            .padding()
            .frame(width: getWidth(), height: getHeight())
            .background(popup.config.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: popup.config.cornerRadius))
            .shadow(
                color: getShadowColor(),
                radius: popup.config.shadowEnabled ? 10 : 0,
                x: 0,
                y: popup.config.shadowEnabled ? 5 : 0
            )
            .overlay(
                RoundedRectangle(cornerRadius: popup.config.cornerRadius)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .overlay(alignment: getCloseButtonAlignment()) {
                if popup.config.showCloseButton {
                    closeButton
                }
            }
            .padding(getPadding())
    }
    
    // 获取尺寸
    private func getWidth() -> CGFloat? {
        let size = popup.size.getSize(screenSize: screenSize, safeArea: safeArea)
        guard let width = size?.width, !width.isNaN, width > 0 else {
            return nil
        }
        return width
    }
    
    private func getHeight() -> CGFloat? {
        let size = popup.size.getSize(screenSize: screenSize, safeArea: safeArea)
        guard let height = size?.height, !height.isNaN, height > 0 else {
            return nil
        }
        return height
    }
    
    // 获取阴影颜色
    private func getShadowColor() -> Color {
        let opacity = popup.config.shadowEnabled ? (colorScheme == .dark ? 0.3 : 0.15) : 0
        return Color.black.opacity(opacity)
    }
    
    // 估算内容尺寸
    private func estimateContentSize(geo: GeometryProxy) -> CGSize {
        let size = popup.size.getSize(screenSize: geo.size, safeArea: safeArea)
        let width = (size?.width.isNaN ?? true) ? 280 : (size?.width ?? 280)
        let height = (size?.height.isNaN ?? true) ? 200 : (size?.height ?? 200)
        return CGSize(width: width + 32, height: height + 32)
    }
    
    // 计算绝对位置坐标
    private func absolutePosition(
        left: CGFloat?, top: CGFloat?, right: CGFloat?, bottom: CGFloat?,
        screenSize: CGSize, contentSize: CGSize
    ) -> CGPoint {
        let halfWidth = contentSize.width / 2
        let halfHeight = contentSize.height / 2
        
        // 计算X坐标
        var xPos: CGFloat
        if let left = left, !left.isNaN {
            xPos = left + halfWidth
        } else if let right = right, !right.isNaN {
            xPos = screenSize.width - right - halfWidth
        } else {
            xPos = screenSize.width / 2
        }
        
        // 计算Y坐标
        var yPos: CGFloat
        if let top = top, !top.isNaN {
            yPos = top + halfHeight
        } else if let bottom = bottom, !bottom.isNaN {
            yPos = screenSize.height - bottom - halfHeight
        } else {
            yPos = screenSize.height / 2
        }
        
        // 确保弹窗显示在屏幕内
        let safeX = min(max(halfWidth, xPos), screenSize.width - halfWidth)
        let safeY = min(max(halfHeight, yPos), screenSize.height - halfHeight)
        
        return CGPoint(x: safeX, y: safeY)
    }
    
    // 关闭按钮视图
    private var closeButton: some View {
        Button {
            popupManager.closePopup(id: popup.id)
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(popup.config.closeButtonStyle.iconColor)
                .padding(8)
                .background(closeButtonBackground)
        }
        .buttonStyle(.plain)
        .padding(8)
    }
    
    // 关闭按钮背景
    @ViewBuilder
    private var closeButtonBackground: some View {
        switch popup.config.closeButtonStyle {
        case .circular:
            Circle().fill(popup.config.closeButtonStyle.backgroundColor)
        case .square:
            RoundedRectangle(cornerRadius: 4)
                .fill(popup.config.closeButtonStyle.backgroundColor)
        case .minimal, .custom:
            popup.config.closeButtonStyle.backgroundColor.clipShape(Circle())
        }
    }
    
    // 获取关闭按钮对齐方式
    private func getCloseButtonAlignment() -> Alignment {
        switch popup.config.closeButtonPosition {
        case .topLeading: return .topLeading
        case .topTrailing: return .topTrailing
        default: return .topTrailing
        }
    }
    
    // 获取内边距
    private func getPadding() -> EdgeInsets {
        switch popup.position {
        case .top, .bottom, .left, .right: return EdgeInsets()
        default: return EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        }
    }
}

/// Popup 视图修饰器
public struct PopupViewModifier: ViewModifier {
    @ObservedObject private var popupManager = PopupManager.shared
    
    public func body(content: Content) -> some View {
        GeometryReader { geo in
            ZStack {
                content
                
                if popupManager.popupCount > 0 {
                    backgroundOverlay
                        .zIndex(900)
                    
                    popupLayer(geo)
                        .zIndex(999)
                }
            }
        }
        .ignoresSafeArea()
    }
    
    // 背景遮罩层
    private var backgroundOverlay: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .onTapGesture(perform: handleBackgroundTap)
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.2), value: popupManager.popupCount > 0)
    }
    
    // 处理背景点击
    private func handleBackgroundTap() {
        guard let popup = popupManager.popup(at: popupManager.popupCount - 1),
              popup.config.closeOnTapOutside else { return }
        
        // 先隐藏键盘
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
        
        // 延迟关闭弹窗
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(popup.config.animation) {
                popupManager.closePopup(id: popup.id)
            }
        }
    }
    
    // 弹窗层
    private func popupLayer(_ geo: GeometryProxy) -> some View {
        ForEach(popupManager.getActivePopups()) { popup in
            PopupContainerView(
                popup: popup,
                screenSize: geo.size,
                safeArea: geo.safeAreaInsets
            )
            .explicitTransition(popup: popup)
        }
    }
}

// 扩展View，添加显式过渡效果的修饰符
extension View {
    fileprivate func explicitTransition(popup: PopupData) -> some View {
        modifier(ExplicitTransitionModifier(popup: popup))
    }
}

// 显式过渡效果修饰符
private struct ExplicitTransitionModifier: ViewModifier {
    let popup: PopupData
    
    func body(content: Content) -> some View {
        content
            .transition(popup.config.customTransition ?? popup.position.getEntryTransition())
            .animation(popup.config.animation, value: true)
    }
}

// MARK: - 便捷扩展方法
public extension View {
    /// 在视图中添加 Popup 显示功能
    func withPopups() -> some View {
        modifier(PopupViewModifier())
            .animation(nil, value: PopupManager.shared.popupCount)
    }
    
    /// 显示弹窗
    func uiPopup<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        position: PopupPosition = .center,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        config: PopupConfig = PopupConfig(),
        id: UUID? = nil
    ) {
        withAnimation(config.animation) {
            PopupManager.shared.show(
                content: content,
                position: position,
                width: width,
                height: height,
                config: config,
                id: id
            )
        }
    }
    

    /// 关闭所有弹窗
    func uiCloseAllPopups() {
        withAnimation {
            PopupManager.shared.closeAllPopups()
        }
    }
    
    /// 通过uuid关闭指定的弹窗
    func uiClosePopup(id: UUID) {
        withAnimation {
            PopupManager.shared.closePopup(id: id)
        }
    }
}

// MARK: - 弹窗视图修饰符
public extension View {
    func popupify(
        position: PopupPosition,
        size: PopupSize,
        screenSize: CGSize,
        safeArea: EdgeInsets
    ) -> some View {
        let calculatedSize = size.getSize(screenSize: screenSize, safeArea: safeArea) ?? CGSize(width: 300, height: 200)
        
        return GeometryReader { geometry in
            self
                .frame(
                    width: !calculatedSize.width.isNaN ? calculatedSize.width : nil,
                    height: !calculatedSize.height.isNaN ? calculatedSize.height : nil
                )
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
        }
    }
} 
