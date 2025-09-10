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
    public let layer: Int // 新增：层级概念，用于维护弹窗的相对顺序
    
    public init<Content: View>(
        content: Content,
        position: PopupPosition = .center,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        zIndex: Double = 1000,
        customId: String? = nil,
        layer: Int = 0
    ) {
        self.content = AnyView(content)
        self.position = position
        self.width = width
        self.height = height
        self.zIndex = zIndex
        self.customId = customId
        self.layer = layer
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
        id: String? = nil,
        layer: Int? = nil
    ) {
        // 防重复弹窗：如果指定了ID且该ID已存在，则不创建新弹窗
        if let customId = id, activePopups.contains(where: { $0.customId == customId }) {
            return
        }
        
        // 如果没有指定layer，则根据当前同位置弹窗数量自动分配
        let finalLayer = layer ?? activePopups.filter { $0.position == position }.count
        
        let popup = PopupData(
            content: content(),
            position: position,
            width: width,
            height: height,
            zIndex: zIndex,
            customId: id,
            layer: finalLayer
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
    
    /// 替换指定customId的弹窗，保持其在队列中的位置和层级
    public func replace<Content: View>(
        customId: String,
        @ViewBuilder content: @escaping () -> Content,
        position: PopupPosition = .center,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        // 查找要替换的弹窗
        guard let index = activePopups.firstIndex(where: { $0.customId == customId }) else {
            // 如果找不到，则直接显示新弹窗
            show(content: content, position: position, width: width, height: height, id: customId)
            return
        }
        
        // 获取原弹窗的zIndex和layer，保持层级顺序
        let originalZIndex = activePopups[index].zIndex
        let originalLayer = activePopups[index].layer
        
        // 创建新弹窗数据，保持原有的zIndex和layer
        let newPopup = PopupData(
            content: content(),
            position: position,
            width: width,
            height: height,
            zIndex: originalZIndex,
            customId: customId,
            layer: originalLayer
        )
        
        // 发送关闭原弹窗的通知
        let originalId = activePopups[index].id
        NotificationCenter.default.post(
            name: NSNotification.Name("ClosePopup"),
            object: nil,
            userInfo: ["popupId": originalId]
        )
        
        // 直接替换数组中的元素，保持位置不变
        withAnimation(.easeInOut(duration: 0.3)) {
            self.activePopups[index] = newPopup
        }
    }
    
    /// 切换弹窗，如果目标弹窗不存在且找到可替换的弹窗，则替换它，否则正常切换
    public func smartToggle<Content: View>(
        customId: String,
        @ViewBuilder content: @escaping () -> Content,
        position: PopupPosition = .center,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        replaceTargetId: String? = nil
    ) {
        if activePopups.contains(where: { $0.customId == customId }) {
            // 如果目标弹窗存在，则关闭它
            close(customId: customId)
        } else {
            // 目标弹窗不存在
            if let replaceId = replaceTargetId, 
               activePopups.contains(where: { $0.customId == replaceId }) {
                // 如果指定了要替换的弹窗ID，且该弹窗存在，则替换它
                replace(customId: replaceId, content: content, position: position, width: width, height: height)
                
                // 更新为新的customId
                if let index = activePopups.firstIndex(where: { $0.customId == replaceId }) {
                    let newPopup = PopupData(
                        content: content(),
                        position: position,
                        width: width,
                        height: height,
                        zIndex: activePopups[index].zIndex,
                        customId: customId,
                        layer: activePopups[index].layer
                    )
                    activePopups[index] = newPopup
                }
            } else {
                // 没有指定替换目标或替换目标不存在，正常显示新弹窗
                show(content: content, position: position, width: width, height: height, id: customId)
            }
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
