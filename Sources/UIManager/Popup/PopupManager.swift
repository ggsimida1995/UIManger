import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// 弹窗位置
public enum PopupPosition: Equatable {
    case center
    case top
    case bottom
    
    var alignment: Alignment {
        switch self {
        case .center: return .center
        case .top: return .top
        case .bottom: return .bottom
        }
    }
    
    // 实现Equatable协议
    public static func == (lhs: PopupPosition, rhs: PopupPosition) -> Bool {
        switch (lhs, rhs) {
        case (.center, .center):
            return true
        case (.top, .top):
            return true
        case (.bottom, .bottom):
            return true
        case (.center, _), (.top, _), (.bottom, _):
            return false
        }
    }
}

/// 弹窗数据
public struct PopupData: Identifiable {
    public let id = UUID()
    public let content: AnyView
    public let position: PopupPosition
    public let width: CGFloat?
    public let height: CGFloat?
    public let showCloseButton: Bool
    public let closeOnTapOutside: Bool
    public let zIndex: Double
    public let offset: CGPoint  // 添加偏移量，用于多个弹窗的堆叠
    public let customId: String? // 添加自定义ID
    public var isClosing: Bool = false // 标记弹窗是否正在关闭
    
    public init<Content: View>(
        content: Content,
        position: PopupPosition = .center,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        showCloseButton: Bool = true,
        closeOnTapOutside: Bool = true,
        zIndex: Double = 1000,
        offset: CGPoint = .zero,
        customId: String? = nil
    ) {
        self.content = AnyView(content)
        self.position = position
        self.width = width
        self.height = height
        self.showCloseButton = showCloseButton
        self.closeOnTapOutside = closeOnTapOutside
        self.zIndex = zIndex
        self.offset = offset
        self.customId = customId
        self.isClosing = false
    }
}

/// 弹窗管理器
public class PopupManager: ObservableObject {
    @Published var activePopups: [PopupData] = []
    @Published var showOverlay: Bool = false // 独立控制蒙层显示
    
    public static let shared = PopupManager()
    private init() {}
    
    // MARK: - 核心方法
    
    /// 显示全局弹窗（支持多个同时显示）
    public func show<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        position: PopupPosition = .center,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        showCloseButton: Bool = true,
        closeOnTapOutside: Bool = true,
        zIndex: Double = 1000,
        id: String? = nil // 添加可选的ID参数
    ) {
        // 获取屏幕宽度，如果width为nil则使用屏幕宽度
        #if canImport(UIKit)
        let screenWidth = UIScreen.main.bounds.width
        #else
        let screenWidth: CGFloat = 375 // macOS默认宽度
        #endif
        let finalWidth = width ?? screenWidth
        
        // 使用 VStack + Spacer 布局，不需要复杂的偏移和层级计算
        let calculatedZIndex = zIndex
        
        let popup = PopupData(
            content: content(),
            position: position,
            width: finalWidth,
            height: height,
            showCloseButton: showCloseButton,
            closeOnTapOutside: closeOnTapOutside,
            zIndex: calculatedZIndex,
            offset: .zero,
            customId: id
        )
        
        // 直接在主线程更新，不使用 DispatchQueue.main.async
        withAnimation(.easeInOut(duration: 0.3)) {
            self.activePopups.append(popup)
            // 显示弹窗时同时显示蒙层
            self.showOverlay = true
        }
    }
    

    
    /// 关闭指定弹窗
    public func close(id: UUID) {
        // 检查弹窗是否存在
        guard activePopups.contains(where: { $0.id == id }) else { return }
        
        // 发送关闭通知，传递弹窗ID（让 PopupView 执行关闭动画）
        NotificationCenter.default.post(
            name: NSNotification.Name("ClosePopup"), 
            object: nil, 
            userInfo: ["popupId": id]
        )
        
        // 延迟关闭，让退出动画完成（匹配 PopupView 中最长的 0.5 秒弹簧动画）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(
                .spring(
                    response: 0.2,        // 快速响应
                    dampingFraction: 0.9, // 保持阻尼系数
                    blendDuration: 0
                )
            ) {
                self.activePopups.removeAll { $0.id == id }
            }
        }
    }
    
    /// 根据自定义ID关闭弹窗
    public func close(customId: String) {
        // 检查弹窗是否存在并获取其索引
        guard let popup = activePopups.first(where: { $0.customId == customId }) else { return }
        
        // 发送关闭通知，传递弹窗ID（让 PopupView 执行关闭动画）
        NotificationCenter.default.post(
            name: NSNotification.Name("ClosePopup"), 
            object: nil, 
            userInfo: ["popupId": popup.id]
        )
        
        // 延迟关闭，让退出动画完成（匹配 PopupView 中最长的 0.5 秒弹簧动画）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(
                .spring(
                    response: 0.2,        // 快速响应
                    dampingFraction: 0.9, // 保持阻尼系数
                    blendDuration: 0
                )
            ) {
                self.activePopups.removeAll { $0.customId == customId }
            }
        }
    }
    
    /// 根据自定义ID切换弹窗显示状态
    public func toggle(customId: String, content: @escaping () -> some View, position: PopupPosition = .center) {
        if activePopups.contains(where: { $0.customId == customId }) {
            // 如果弹窗存在，则关闭
            close(customId: customId)
        } else {
            // 如果弹窗不存在，则显示
            show(content: content, position: position, id: customId)
        }
    }
    
    /// 关闭所有弹窗
    public func closeAll() {
        // 获取所有需要关闭的弹窗ID
        let popupsToClose = activePopups.map { $0.id }
        
        // 如果没有弹窗需要关闭，直接隐藏蒙层
        guard !popupsToClose.isEmpty else {
            withAnimation(.easeInOut(duration: 0.2)) {
                showOverlay = false
            }
            return
        }
        
        // 先立即关闭蒙层，给用户即时反馈
        withAnimation(.easeInOut(duration: 0.2)) {
            showOverlay = false
        }
        
        // 逐个调用 close(id:) 方法，确保每个弹窗都有正确的关闭动画
        for popupId in popupsToClose {
            close(id: popupId)
        }
    }
    
    /// 获取弹窗数量
    public var count: Int {
        activePopups.count
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
