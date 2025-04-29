import SwiftUI
import Combine
#if canImport(UIKit)
import UIKit
#endif

/// Popup 管理器 - 全局单例
public class PopupManager: ObservableObject {
    /// 当前显示的 Popup 列表
    @Published private(set) var activePopups: [PopupData] = []
    
    /// 弹窗数量
    public var popupCount: Int { activePopups.count }
    
    /// 单例实例
    public static let shared = PopupManager()
    
    private init() {}
    
    /// 获取指定索引的弹窗
    public func popup(at index: Int) -> PopupData? {
        activePopups.indices.contains(index) ? activePopups[index] : nil
    }
    
    /// 获取所有活跃弹窗列表（用于 ForEach 遍历）
    public func getActivePopups() -> [PopupData] {
        activePopups
    }
    
    // MARK: - 核心API
    
    /// 显示弹窗（核心方法）
    public func showPopup(_ popup: PopupData) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            withAnimation(popup.config.animation) {
                self.activePopups.append(popup)
            }
        }
    }
    
    /// 显示视图弹窗
    public func show<Content: View>(
        @ViewBuilder content: @escaping () -> Content,
        position: PopupPosition = .center,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        config: PopupConfig = PopupConfig(),
        id: UUID? = nil
    ) {
        let size = createPopupSize(position: position, width: width, height: height)
        
        let popup = PopupData(
            id: id ?? UUID(),
            content: content(),
            position: position,
            size: size,
            config: config
        )
        
        withAnimation(config.animation) {
            showPopup(popup)
        }
    }
    
    // 创建弹窗尺寸
    private func createPopupSize(
        position: PopupPosition,
        width: CGFloat?,
        height: CGFloat?
    ) -> PopupSize {
        let safeWidth = width.map { max(0, $0) } ?? CGFloat.nan
        let safeHeight = height.map { max(0, $0) } ?? CGFloat.nan
        
        switch position {
        case .top, .bottom:
            return .fullWidth(safeHeight)
        case .left, .right:
            return .fullHeight(safeWidth)
        case .center, .absolute:
            if width != nil, height != nil {
                return .fixed(CGSize(width: safeWidth, height: safeHeight))
            } else if width != nil {
                return .fixed(CGSize(width: safeWidth, height: CGFloat.nan))
            } else if height != nil {
                return .fixed(CGSize(width: CGFloat.nan, height: safeHeight))
            }
            return .flexible
        }
    }
    
    // MARK: - 关闭方法
    
    /// 关闭指定 Popup
    public func closePopup(id: UUID) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let index = self.activePopups.firstIndex(where: { $0.id == id }) else { return }
            
            let popup = self.activePopups[index]
            withAnimation(popup.config.animation) {
                self.activePopups.remove(at: index)
                popup.config.onClose?()
            }
        }
    }
    
    /// 关闭所有 Popup
    public func closeAllPopups() {
        guard !activePopups.isEmpty else { return }
        
        let popupsCopy = self.activePopups
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            withAnimation {
                self.activePopups.removeAll()
                popupsCopy.forEach { $0.config.onClose?() }
            }
        }
    }
}

// MARK: - 环境扩展
public extension EnvironmentValues {
    private struct PopupManagerKey: EnvironmentKey {
        static let defaultValue = PopupManager.shared
    }
    
    var popupManager: PopupManager {
        get { self[PopupManagerKey.self] }
        set { self[PopupManagerKey.self] = newValue }
    }
} 
