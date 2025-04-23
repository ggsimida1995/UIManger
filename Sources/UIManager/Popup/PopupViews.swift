import SwiftUI

/// Popup 容器视图
public struct PopupContainerView: View {
    @ObservedObject private var popupManager = PopupManager.shared
    @Environment(\.colorScheme) private var colorScheme
    
    let popup: PopupData
    let screenSize: CGSize
    let safeArea: EdgeInsets
    
    public var body: some View {
        ZStack {
            // 主内容视图
            popup.content
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
                // 关闭按钮
                .overlay(alignment: getCloseButtonAlignment()) {
                    if popup.config.showCloseButton {
                        closeButton
                    }
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: popup.position.getAlignment())
        .padding(getPadding())
    }
    
    // 关闭按钮视图
    private var closeButton: some View {
        Button(action: {
            popupManager.closePopup(id: popup.id)
        }) {
            Image(systemName: "xmark")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.gray)
                .padding(8)
                .background(Circle().fill(Color.gray.opacity(0.1)))
        }
        .buttonStyle(PlainButtonStyle())
        .padding(8)
    }
    
    // 获取关闭按钮对齐方式
    private func getCloseButtonAlignment() -> Alignment {
        switch popup.config.closeButtonPosition {
        case .topLeading:
            return .topLeading
        case .topTrailing:
            return .topTrailing
        default:
            return .topTrailing
        }
    }
    
    // 获取内边距
    private func getPadding() -> EdgeInsets {
        switch popup.position {
        case .top:
            return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        case .bottom:
            return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        case .left:
            return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        case .right:
            return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
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
            
            // 更新当前活跃弹窗数量，避免在渲染过程中数量变化导致索引错误
            .onReceive(popupManager.popupCountPublisher) { count in
                activePopupCount = count
            }
            
            if popupManager.popupCount > 0 {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        // 检查是否有可以点击外部关闭的弹窗
                        for index in (0..<popupManager.popupCount).reversed() {
                            if let popup = popupManager.popup(at: index), popup.config.closeOnTapOutside {
                                popupManager.closePopup(id: popup.id)
                                break
                            }
                        }
                    }
                    .zIndex(900)
            }
            
            // 使用局部变量防止在渲染过程中数量变化
            let count = min(activePopupCount, popupManager.popupCount)
            ForEach(0..<count, id: \.self) { index in
                // 增加安全检查，确保索引有效
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
        size: PopupSize = .flexible,
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
            size: size,
            config: config
        )
    }
    
    /// 显示底部弹窗
    func uiBottomSheet<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        height: CGFloat? = nil,
        cornerRadius: CGFloat = 12,
        closeOnTapOutside: Bool = true,
        onClose: (() -> Void)? = nil
    ) {
        let config = PopupBaseConfig(
            cornerRadius: cornerRadius,
            closeOnTapOutside: closeOnTapOutside,
            onClose: onClose
        )
        
        PopupManager.shared.show(
            content: content,
            position: .bottom,
            size: .fullWidth(height),
            config: config
        )
    }
    
    /// 显示侧边栏菜单
    func uiSidebar<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        side: PopupPosition = .right,
        width: CGFloat = UIScreen.main.bounds.width * 0.75,
        closeOnTapOutside: Bool = true,
        onClose: (() -> Void)? = nil
    ) {
        // 只支持左侧和右侧弹出
        switch side {
        case .left, .right:
            let config = PopupBaseConfig(
                cornerRadius: 0,
                closeOnTapOutside: closeOnTapOutside,
                onClose: onClose
            )
            
            PopupManager.shared.show(
                content: content,
                position: side,
                size: .fullHeight(width),
                config: config
            )
        default:
            return
        }
    }
    
    /// 显示输入框弹窗
    func uiInputPopup<Content: View>(
        @ViewBuilder content: @escaping (KeyboardHeightObserver) -> Content,
        position: PopupPosition = .center,
        size: PopupSize = .flexible,
        cornerRadius: CGFloat = 12,
        closeOnTapOutside: Bool = true,
        onClose: (() -> Void)? = nil
    ) {
        let config = PopupBaseConfig(
            cornerRadius: cornerRadius,
            closeOnTapOutside: closeOnTapOutside,
            onClose: onClose
        )
        
        PopupManager.shared.showInput(
            content: content,
            position: position,
            size: size,
            config: config
        )
    }
    
    /// 显示标准输入弹窗
    func uiStandardInput(
        title: String,
        message: String? = nil,
        placeholder: String = "",
        initialText: String = "",
        keyboardType: UIKeyboardType = .default,
        submitLabel: SubmitLabel = .done,
        onCancel: (() -> Void)? = nil,
        onSubmit: @escaping (String) -> Void
    ) {
        PopupManager.shared.showStandardInput(
            title: title,
            message: message,
            placeholder: placeholder,
            initialText: initialText,
            keyboardType: keyboardType,
            submitLabel: submitLabel,
            onCancel: onCancel,
            onSubmit: onSubmit
        )
    }
    
    /// 关闭所有弹窗
    func uiCloseAllPopups() {
        PopupManager.shared.closeAllPopups()
    }
}

// MARK: - 标准输入弹窗视图
public struct StandardInputPopupView: View {
    public let title: String
    public let message: String?
    public let placeholder: String
    public let keyboardType: UIKeyboardType
    public let submitLabel: SubmitLabel
    @ObservedObject public var keyboardObserver: KeyboardHeightObserver
    public let onCancel: () -> Void
    public let onSubmit: (String) -> Void
    
    @State private var text: String
    @FocusState private var isInputFocused: Bool
    
    public init(
        title: String,
        message: String? = nil,
        placeholder: String = "",
        initialText: String = "",
        keyboardType: UIKeyboardType = .default,
        submitLabel: SubmitLabel = .done,
        keyboardObserver: KeyboardHeightObserver,
        onCancel: @escaping () -> Void,
        onSubmit: @escaping (String) -> Void
    ) {
        self.title = title
        self.message = message
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.submitLabel = submitLabel
        self.keyboardObserver = keyboardObserver
        self.onCancel = onCancel
        self.onSubmit = onSubmit
        self._text = State(initialValue: initialText)
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color(.label))
            
            if let message = message {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(Color(.secondaryLabel))
                    .multilineTextAlignment(.center)
            }
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .submitLabel(submitLabel)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .focused($isInputFocused)
                .onSubmit {
                    onSubmit(text)
                }
            
            HStack {
                Button("取消") {
                    keyboardObserver.hideKeyboard()
                    onCancel()
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .foregroundColor(Color(.label))
                .cornerRadius(8)
                
                Button("确定") {
                    keyboardObserver.hideKeyboard()
                    onSubmit(text)
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .onAppear {
            // 弹窗显示后自动聚焦到输入框
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isInputFocused = true
            }
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
        let offset = CGPoint.zero
        
        return GeometryReader { geometry in
            self
                .frame(
                    width: calculatedSize.width != .nan ? calculatedSize.width : nil,
                    height: calculatedSize.height != .nan ? calculatedSize.height : nil
                )
                .position(
                    x: geometry.size.width / 2 + offset.x,
                    y: geometry.size.height / 2 + offset.y
                )
        }
    }
} 