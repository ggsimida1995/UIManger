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
        let content = popup.content
            .padding(10)
            .frame(
                width: popup.size.getSize(screenSize: screenSize, safeArea: safeArea)?.width,
                height: popup.size.getSize(screenSize: screenSize, safeArea: safeArea)?.height
            )
            .background(popup.config.backgroundColor)
            .cornerRadius(popup.config.cornerRadius)
            .shadow(
                color: Color.black.opacity(popup.config.shadowEnabled ? (colorScheme == .dark ? 0.3 : 0.15) : 0),
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
            // 应用垂直偏移
            .offset(y: -popup.config.offsetY)
        
        if case .absolute(let left, let top, let right, let bottom) = popup.position {
            GeometryReader { geo in
                content
                    .position(
                        absolutePosition(
                            left: left,
                            top: top,
                            right: right,
                            bottom: bottom,
                            screenSize: geo.size,
                            contentSize: estimateContentSize(geo: geo),
                            offsetY: popup.config.offsetY
                        )
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: popup.position.getAlignment())
        }
    }
    
    // 估算内容尺寸
    private func estimateContentSize(geo: GeometryProxy) -> CGSize {
        if let size = popup.size.getSize(screenSize: geo.size, safeArea: safeArea) {
            return CGSize(width: size.width + 32, height: size.height + 32)
        }
        return CGSize(width: 280, height: 200)
    }
    
    // 计算绝对位置坐标
    private func absolutePosition(
        left: CGFloat?,
        top: CGFloat?,
        right: CGFloat?,
        bottom: CGFloat?,
        screenSize: CGSize,
        contentSize: CGSize,
        offsetY: CGFloat = 0
    ) -> CGPoint {
        let halfWidth = contentSize.width / 2
        let halfHeight = contentSize.height / 2
        
        // 计算X坐标
        var xPos: CGFloat
        if let left = left {
            // 相对于左边缘
            xPos = left + halfWidth
        } else if let right = right {
            // 相对于右边缘
            xPos = screenSize.width - right - halfWidth
        } else {
            // 默认居中
            xPos = screenSize.width / 2
        }
        
        // 计算Y坐标
        var yPos: CGFloat
        if let top = top {
            // 相对于顶部
            yPos = top + halfHeight
        } else if let bottom = bottom {
            // 相对于底部
            yPos = screenSize.height - bottom - halfHeight
        } else {
            // 默认居中
            yPos = screenSize.height / 2
        }
        
        // 确保弹窗显示在屏幕内
        xPos = min(max(halfWidth, xPos), screenSize.width - halfWidth)
        yPos = min(max(halfHeight, yPos), screenSize.height - halfHeight)
        
        // 应用垂直偏移
        yPos -= offsetY
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    // 关闭按钮视图
    private var closeButton: some View {
        Button(action: {
            popupManager.closePopup(id: popup.id)
        }) {
            Image(systemName: "xmark")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(popup.config.closeButtonStyle.iconColor)
                .padding(8)
                .background(
                    Group {
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
                )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(8)
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
        case .top, .bottom, .left, .right:
            return EdgeInsets()
        default:
            return EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        }
    }
}

/// Popup 视图修饰器
public struct PopupViewModifier: ViewModifier {
    @ObservedObject private var popupManager = PopupManager.shared
    @Environment(\.colorScheme) private var colorScheme
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            if popupManager.popupCount > 0 {
                // 背景遮罩，无需依赖于特定弹窗的动画
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // 点击蒙层时关闭顶部弹窗(如果允许)
                        if let popup = popupManager.popup(at: popupManager.popupCount - 1),
                           popup.config.closeOnTapOutside {
                            // 先尝试隐藏键盘
                            #if canImport(UIKit)
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            #endif
                            
                            // 延迟一小段时间再关闭弹窗
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                popupManager.closePopup(id: popup.id)
                            }
                        }
                    }
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.2), value: popupManager.popupCount > 0)
                    .zIndex(900)
                
                // 逐个显示弹窗
                ForEach(popupManager.getActivePopups(), id: \.id) { popup in
                    // 使用独立的ZStack包装每个弹窗，确保动画独立
                    ZStack {
                        GeometryReader { geo in
                            PopupContainerView(
                                popup: popup,
                                screenSize: geo.size,
                                safeArea: geo.safeAreaInsets
                            )
                        }
                        .ignoresSafeArea()
                    }
                    // 使用explicitTransition确保过渡动画被显式应用
                    .explicitTransition(popup: popup)
                    .zIndex(999)
                }
            }
        }
    }
}

// 扩展View，添加显式过渡效果的修饰符
extension View {
    fileprivate func explicitTransition(popup: PopupData) -> some View {
        // 使用viewModifier而非直接添加transition和animation，以确保它们被正确应用
        self.modifier(ExplicitTransitionModifier(popup: popup))
    }
}

// 显式过渡效果修饰符，确保过渡和动画被正确应用
private struct ExplicitTransitionModifier: ViewModifier {
    let popup: PopupData
    
    func body(content: Content) -> some View {
        content
            // 1. 应用过渡效果 - 使用自定义过渡效果或位置相关的默认过渡效果
            .transition(popup.config.customTransition ?? popup.position.getEntryTransition())
            // 2. 应用动画 - 确保动画与过渡效果相协调
            .animation(popup.config.animation, value: true)
    }
}

// 扩展 View，添加方便的方法用于显示 Popup
public extension View {
    /// 在视图中添加 Popup 显示功能
    func withPopups() -> some View {
        self.modifier(PopupViewModifier())
            // 禁用默认动画，使用我们自定义的动画控制
            .animation(nil, value: PopupManager.shared.popupCount)
    }
    
    /// 显示弹窗
    func uiPopup<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        position: PopupPosition = .center,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        config: PopupConfig = PopupConfig(),
        exitConfig: PopupConfig? = nil,
        id: UUID? = nil
    ) {
        // 使用显式动画包装
        withAnimation(config.animation) {
            PopupManager.shared.show(
                content: content,
                position: position,
                width: width,
                height: height,
                config: config,
                exitConfig: exitConfig,
                id: id
            )
        }
    }
    
    /// 使用绝对位置显示弹窗
    func uiPopupAt<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        left: CGFloat? = nil,
        top: CGFloat? = nil,
        right: CGFloat? = nil,
        bottom: CGFloat? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        config: PopupConfig = PopupConfig(),
        exitConfig: PopupConfig? = nil,
        id: UUID? = nil
    ) {
        // 使用显式动画包装
        withAnimation(config.animation) {
            PopupManager.shared.showAt(
                content: content,
                left: left,
                top: top,
                right: right,
                bottom: bottom,
                width: width,
                height: height,
                config: config,
                exitConfig: exitConfig,
                id: id
            )
        }
    }
    
    /// 显示侧边栏弹窗
    func uiSidebar<Content: View>(
        side: PopupPosition,
        width: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content,
        config: PopupConfig = PopupConfig(),
        exitConfig: PopupConfig? = nil,
        id: UUID? = nil
    ) {
        PopupManager.shared.showSidebar(
            side: side,
            width: width,
            content: content,
            config: config,
            exitConfig: exitConfig,
            id: id
        )
    }
    
    /// 显示顶部或底部横幅
    func uiBanner<Content: View>(
        position: PopupPosition,
        height: CGFloat = 80,
        @ViewBuilder content: @escaping () -> Content,
        config: PopupConfig = PopupConfig(),
        exitConfig: PopupConfig? = nil,
        autoHide: Bool = false,
        autoHideDuration: TimeInterval = 3.0,
        id: UUID? = nil
    ) {
        PopupManager.shared.showBanner(
            position: position,
            height: height,
            content: content,
            config: config,
            exitConfig: exitConfig,
            autoHide: autoHide,
            autoHideDuration: autoHideDuration,
            id: id
        )
    }
    
    /// 关闭所有弹窗
    func uiCloseAllPopups() {
        withAnimation {
            PopupManager.shared.closeAllPopups()
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
