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
}

/// 弹窗数据
public struct PopupData: Identifiable {
    public let id = UUID()
    public let content: AnyView
    public let position: PopupPosition
    public let width: CGFloat?
    public let height: CGFloat?
    public let zIndex: Double
    public let customId: String?
    
    public init<Content: View>(
        content: Content,
        position: PopupPosition = .center,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        zIndex: Double = 1000,
        customId: String? = nil
    ) {
        self.content = AnyView(content)
        self.position = position
        self.width = width
        self.height = height
        self.zIndex = zIndex
        self.customId = customId
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
        zIndex: Double = 1000,
        id: String? = nil
    ) {
        // 防重复弹窗：如果指定了ID且该ID已存在，则不创建新弹窗
        if let customId = id, activePopups.contains(where: { $0.customId == customId }) {
            return
        }
        
        let popup = PopupData(
            content: content(),
            position: position,
            width: width,
            height: height,
            zIndex: zIndex,
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
        // DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(
                .spring(
                    response: 0.2,        // 快速响应
                    dampingFraction: 0.9, // 保持阻尼系数
                    blendDuration: 0
                )
            ) {
                self.activePopups.removeAll { $0.id == id }
            }
        // }
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
        // DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(
                .spring(
                    response: 0.2,        // 快速响应
                    dampingFraction: 0.9, // 保持阻尼系数
                    blendDuration: 0
                )
            ) {
                self.activePopups.removeAll { $0.customId == customId }
            }
        // }
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
    
    /// 检查指定ID的弹窗是否已存在
    public func isShowing(id: String) -> Bool {
        return activePopups.contains(where: { $0.customId == id })
    }
    
    /// 检查是否有任何弹窗在显示
    public var hasActivePopups: Bool {
        return !activePopups.isEmpty
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
