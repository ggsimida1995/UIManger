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
        
        // 计算弹窗偏移量，避免重叠
        let offset = calculateOffset(for: position, existingPopups: activePopups, height: height)
        
        // 计算z-index：对于底部弹窗，先显示的层级更高，后显示的层级更低
        let calculatedZIndex: Double
        if position == .bottom {
            // 底部弹窗：先显示的层级高，后显示的层级低
            let bottomPopups = activePopups.filter { $0.position == .bottom && !$0.isClosing }
            calculatedZIndex = zIndex + Double(bottomPopups.count) * 10
        } else {
            // 其他位置：保持原有逻辑
            calculatedZIndex = zIndex + Double(activePopups.count) * 10
        }
        
        let popup = PopupData(
            content: content(),
            position: position,
            width: finalWidth,
            height: height,
            showCloseButton: showCloseButton,
            closeOnTapOutside: closeOnTapOutside,
            zIndex: calculatedZIndex,
            offset: offset,
            customId: id
        )
        
        // 直接在主线程更新，不使用 DispatchQueue.main.async
        withAnimation(.easeInOut(duration: 0.3)) {
            self.activePopups.append(popup)
        }
    }
    
    /// 计算弹窗偏移量，避免重叠
    private func calculateOffset(for position: PopupPosition, existingPopups: [PopupData], height: CGFloat?) -> CGPoint {
        // 只考虑不在关闭状态的弹窗
        let samePositionPopups = existingPopups.filter { $0.position == position && !$0.isClosing }
        
        switch position {
        case .top:
            // 顶部弹窗向下垂直堆叠
            let spacing: CGFloat = 20 // 弹窗之间的间距
            
            // 计算之前弹窗的总高度
            var previousHeight: CGFloat = 0
            for popup in samePositionPopups {
                let popupHeight = popup.height ?? 120
                previousHeight += popupHeight + spacing
            }
            
            // 向下偏移，让新弹窗堆叠在之前弹窗的下方
            let offsetY = previousHeight
            return CGPoint(x: 0, y: offsetY)
            
        case .bottom:
            // 底部弹窗向上拼接，形成连续的整体
            let spacing: CGFloat = 0 // 弹窗之间的间距为0
            
            // 计算之前弹窗的总高度（不包括当前正在添加的弹窗）
            var previousHeight: CGFloat = 0
            for popup in samePositionPopups {
                let popupHeight = popup.height ?? 150
                previousHeight += popupHeight + spacing
            }
            
            // 向上偏移，让新弹窗拼接在之前弹窗的上方
            let offsetY = -previousHeight
            
            return CGPoint(x: 0, y: offsetY)
            
        case .center:
            // 中心弹窗居中显示，不支持多个
            return .zero
        }
    }
    
    /// 关闭指定弹窗
    public func close(id: UUID) {
        // 检查弹窗是否存在并获取其索引
        guard let index = activePopups.firstIndex(where: { $0.id == id }) else { return }
        
        // 标记弹窗为正在关闭状态
        activePopups[index].isClosing = true
        
        // 发送关闭通知，传递弹窗ID
        NotificationCenter.default.post(
            name: NSNotification.Name("ClosePopup"), 
            object: nil, 
            userInfo: ["popupId": id]
        )
        
        // 延迟关闭，让退出动画和蒙层动画完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
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
        guard let index = activePopups.firstIndex(where: { $0.customId == customId }) else { return }
        
        // 标记弹窗为正在关闭状态
        activePopups[index].isClosing = true
        
        // 发送关闭通知，传递弹窗ID
        NotificationCenter.default.post(
            name: NSNotification.Name("ClosePopup"), 
            object: nil, 
            userInfo: ["popupId": activePopups[index].id]
        )
        
        // 延迟关闭，让退出动画和蒙层动画完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
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
        // 逐个关闭弹窗，让每个弹窗执行退出动画
        for (index, _) in activePopups.enumerated() {
            if !activePopups[index].isClosing {
                activePopups[index].isClosing = true
                // 发送关闭通知，传递弹窗ID
                NotificationCenter.default.post(
                    name: NSNotification.Name("ClosePopup"), 
                    object: nil, 
                    userInfo: ["popupId": activePopups[index].id]
                )
            }
        }
        
        // 延迟关闭，让退出动画和蒙层动画完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(
                .spring(
                    response: 0.2,        // 快速响应
                    dampingFraction: 0.9, // 保持阻尼系数
                    blendDuration: 0
                )
            ) {
                self.activePopups.removeAll()
            }
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
