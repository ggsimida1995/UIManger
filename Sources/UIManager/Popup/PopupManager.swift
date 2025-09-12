import SwiftUI

// MARK: - 数据模型

/// 弹窗位置
public enum PopupPosition: Equatable, CaseIterable {
    case top, center, bottom
}

/// 弹窗数据
public struct PopupData: Identifiable {
    public let id = UUID()
    public let content: AnyView
    public let position: PopupPosition
    public let height: CGFloat?
    public let customId: String?
    
    public init<Content: View>(
        content: Content,
        position: PopupPosition,
        height: CGFloat? = nil,
        customId: String? = nil
    ) {
        self.content = AnyView(content)
        self.position = position
        self.height = height
        self.customId = customId
    }
}

// MARK: - 弹窗管理器

/// 弹窗管理器 - 每个位置只支持一个弹窗
public class PopupManager: ObservableObject {
    @Published var topPopup: PopupData? = nil
    @Published var centerPopup: PopupData? = nil
    @Published var bottomPopup: PopupData? = nil
    @Published var showOverlay: Bool = false
    
    public static let shared = PopupManager()
    private init() {}
    
    // 统一的弹簧动画配置
    private var springAnimation: Animation {
        .spring(response: 0.4, dampingFraction: 0.95, blendDuration: 0)
    }
    
    // MARK: - 核心方法
    
    /// 显示弹窗
    public func show<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        position: PopupPosition,
        height: CGFloat? = nil,
        id: String? = nil
    ) {
        let popup = PopupData(
            content: content(),
            position: position,
            height: height,
            customId: id
        )
        
        withAnimation(springAnimation) {
            switch position {
            case .top:
                self.topPopup = popup
            case .center:
                self.centerPopup = popup
            case .bottom:
                self.bottomPopup = popup
            }
            self.updateOverlayVisibility()
        }
    }
    
    /// 关闭指定位置的弹窗
    public func close(position: PopupPosition) {
        withAnimation(springAnimation) {
            switch position {
            case .top:
                self.topPopup = nil
            case .center:
                self.centerPopup = nil
            case .bottom:
                self.bottomPopup = nil
            }
            self.updateOverlayVisibility()
        }
    }
    
    
    /// 关闭所有弹窗
    public func closeAll() {
        withAnimation(springAnimation) {
            topPopup = nil
            centerPopup = nil
            bottomPopup = nil
            showOverlay = false
        }
    }
    
    /// 获取弹窗数量
    public var count: Int {
        [topPopup, centerPopup, bottomPopup].compactMap { $0 }.count
    }
    
    /// 检查是否有弹窗在显示
    public var hasActivePopups: Bool {
        topPopup != nil || centerPopup != nil || bottomPopup != nil
    }
    
    private func updateOverlayVisibility() {
        showOverlay = hasActivePopups
    }
}

// MARK: - 环境键
struct PopupManagerKey: EnvironmentKey {
    static let defaultValue = PopupManager.shared
}

public extension EnvironmentValues {
    var popup: PopupManager {
        get { self[PopupManagerKey.self] }
        set { self[PopupManagerKey.self] = newValue }
    }
}

// MARK: - 便捷扩展

public extension View {
    /// 添加弹窗支持
    func withPopup() -> some View {
        self.overlay(PopupContainer())
            .environment(\.popup, PopupManager.shared)
    }
}
