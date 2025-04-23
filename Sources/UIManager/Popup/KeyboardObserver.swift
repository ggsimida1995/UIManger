import SwiftUI
import Combine

/// 键盘高度观察器
public class KeyboardHeightObserver: ObservableObject {
    @Published public var keyboardHeight: CGFloat = 0
    @Published public var keyboardAnimationDuration: Double = 0.25
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { [weak self] notification -> Void? in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                    return nil
                }
                
                // 获取动画持续时间
                if let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                    self?.keyboardAnimationDuration = animationDuration
                }
                
                self?.keyboardHeight = keyboardFrame.height
                return ()
            }
            .sink { _ in }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .compactMap { [weak self] notification -> Void? in
                // 获取动画持续时间
                if let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                    self?.keyboardAnimationDuration = animationDuration
                }
                
                self?.keyboardHeight = 0
                return ()
            }
            .sink { _ in }
            .store(in: &cancellables)
    }
    
    // 强制隐藏键盘
    public func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
}

/// 适应键盘高度的视图包装器
public struct KeyboardAdaptiveView<Content: View>: View {
    @ObservedObject var keyboardObserver: KeyboardHeightObserver
    @State private var bottomPadding: CGFloat = 0
    let content: Content
    
    public init(keyboardObserver: KeyboardHeightObserver, @ViewBuilder content: () -> Content) {
        self.keyboardObserver = keyboardObserver
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(.bottom, keyboardObserver.keyboardHeight > 0 ? max(0, bottomPadding) : 0)
            .animation(.easeOut(duration: keyboardObserver.keyboardAnimationDuration), value: bottomPadding)
            .onReceive(keyboardObserver.$keyboardHeight) { height in
                if height >= 0 && height.isFinite {
                    bottomPadding = height > 0 ? height : 0
                } else {
                    bottomPadding = 0
                }
            }
            .offset(y: keyboardObserver.keyboardHeight > 0 ? -keyboardObserver.keyboardHeight / 3 : 0)
    }
}

// MARK: - 输入框组件数据
public struct InputPopupData: Identifiable {
    public let id = UUID()
    public var content: AnyView
    public var size: PopupSize
    public var config: PopupBaseConfig
    public var keyboardObserver: KeyboardHeightObserver
    private let position: PopupPosition = .center
    
    public init<Content: View>(
        content: @escaping (KeyboardHeightObserver) -> Content,
        size: PopupSize = .flexible,
        config: PopupBaseConfig = PopupBaseConfig()
    ) {
        self.keyboardObserver = KeyboardHeightObserver()
        self.size = size
        self.config = config
        
        // 创建一个临时引用以避免在闭包中引用self.content
        let observer = self.keyboardObserver
        let wrappedContent = KeyboardAdaptiveView(keyboardObserver: observer) {
            content(observer)
        }
        self.content = AnyView(wrappedContent)
    }
    
    func getPosition() -> PopupPosition {
        return position
    }
} 