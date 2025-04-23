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
            .padding()
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
            .padding(getPadding())
            // 应用垂直偏移
            .offset(y: -popup.config.offsetY)
        
        if case .custom(let point) = popup.position {
            GeometryReader { geo in
                content
                    .position(
                        safePosition(
                            relativePoint: point,
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
    
    // 计算安全的位置坐标，防止弹窗显示在屏幕外
    private func safePosition(relativePoint: CGPoint, screenSize: CGSize, contentSize: CGSize, offsetY: CGFloat = 0) -> CGPoint {
        let halfWidth = contentSize.width / 2
        let halfHeight = contentSize.height / 2
        
        let safeX = min(max(halfWidth, relativePoint.x * screenSize.width), screenSize.width - halfWidth)
        
        // 考虑垂直偏移量调整Y坐标
        var safeY = min(max(halfHeight, relativePoint.y * screenSize.height), screenSize.height - halfHeight)
        safeY -= offsetY // 应用垂直偏移（向上为负）
        
        return CGPoint(x: safeX, y: safeY)
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
            return EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        }
    }
}

/// Popup 视图修饰器
public struct PopupViewModifier: ViewModifier {
    @ObservedObject private var popupManager = PopupManager.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var activePopupCount: Int = 0
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .onReceive(popupManager.popupCountPublisher) { count in
                    activePopupCount = count
                }
            
            if popupManager.popupCount > 0 {
                // 使用ZStack确保蒙层和弹窗内容分开布局
                ZStack {
                    // 蒙层使用全屏幕覆盖，并确保不受键盘影响
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle()) // 确保点击区域覆盖全屏
                        .onTapGesture {
                            // 检查关闭条件并关闭弹窗
                            for index in (0..<popupManager.popupCount).reversed() {
                                if let popup = popupManager.popup(at: index), popup.config.closeOnTapOutside {
                                    // 先尝试隐藏键盘，然后关闭弹窗
                                    #if canImport(UIKit)
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    #endif
                                    
                                    // 稍微延迟关闭弹窗，确保键盘已经开始收起
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        popupManager.closePopup(id: popup.id)
                                    }
                                    break
                                }
                            }
                        }
                        .zIndex(900)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                
                // 使用局部变量防止在渲染过程中数量变化
                let count = min(activePopupCount, popupManager.popupCount)
                ForEach(0..<count, id: \.self) { index in
                    if let popup = popupManager.popup(at: index) {
                        GeometryReader { geo in
                            PopupContainerView(
                                popup: popup,
                                screenSize: geo.size,
                                safeArea: geo.safeAreaInsets
                            )
                        }
                        .ignoresSafeArea()
                        .transition(popup.position.getEntryTransition())
                        .zIndex(999)
                    }
                }
            }
        }
    }
}

// 扩展 View，添加方便的方法用于显示 Popup
public extension View {
    /// 在视图中添加 Popup 显示功能
    func withPopups() -> some View {
        self.modifier(PopupViewModifier())
    }
    
    /// 显示弹窗
    func uiPopup<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        position: PopupPosition = .center,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        cornerRadius: CGFloat = 12,
        closeOnTapOutside: Bool = true,
        showCloseButton: Bool = false,
        onClose: (() -> Void)? = nil
    ) {
        let config = PopupBaseConfig(
            cornerRadius: cornerRadius,
            closeOnTapOutside: closeOnTapOutside,
            showCloseButton: showCloseButton,
            onClose: onClose
        )
        
        PopupManager.shared.show(
            content: content,
            position: position,
            width: width,
            height: height,
            config: config
        )
    }
    
    /// 关闭所有弹窗
    func uiCloseAllPopups() {
        PopupManager.shared.closeAllPopups()
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