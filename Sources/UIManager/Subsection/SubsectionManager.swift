import SwiftUI

/// 分段器管理器
public class SubsectionManager: ObservableObject {
    public static let shared = SubsectionManager()
    
    @Published public var currentIndex: Int = 0
    @Published public var config: SubsectionConfig
    
    private init() {
        // 初始化时提供一个空的配置
        self.config = SubsectionConfig(items: [])
    }
    
    /// 更新分段器配置
    public func update(config: SubsectionConfig) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.config = config
            self.currentIndex = config.current
        }
    }
    
    /// 更新分段器选项
    public func updateItems(_ items: [SubsectionItem]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let newConfig = SubsectionConfig(
                title: self.config.title,
                items: items,
                current: self.config.current,
                fontSize: self.config.fontSize,
                bold: self.config.bold,
                cornerRadius: self.config.cornerRadius,
                height: self.config.height,
                width: self.config.width,
                activeTextColor: self.config.activeTextColor,
                activeBgColor: self.config.activeBgColor,
                inactiveTextColor: self.config.inactiveTextColor,
                inactiveBgColor: self.config.inactiveBgColor
            )
            self.config = newConfig
        }
    }
    
    /// 更新分段器颜色
    public func updateColors(
        activeTextColor: Color? = nil,
        activeBgColor: Color? = nil,
        inactiveTextColor: Color? = nil,
        inactiveBgColor: Color? = nil
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let newConfig = SubsectionConfig(
                title: self.config.title,
                items: self.config.items,
                current: self.config.current,
                fontSize: self.config.fontSize,
                bold: self.config.bold,
                cornerRadius: self.config.cornerRadius,
                height: self.config.height,
                width: self.config.width,
                activeTextColor: activeTextColor ?? self.config.activeTextColor,
                activeBgColor: activeBgColor ?? self.config.activeBgColor,
                inactiveTextColor: inactiveTextColor ?? self.config.inactiveTextColor,
                inactiveBgColor: inactiveBgColor ?? self.config.inactiveBgColor
            )
            self.config = newConfig
        }
    }
    
    /// 更新分段器字体
    public func updateFont(size: CGFloat? = nil, bold: Bool? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let newConfig = SubsectionConfig(
                title: self.config.title,
                items: self.config.items,
                current: self.config.current,
                fontSize: size ?? self.config.fontSize,
                bold: bold ?? self.config.bold,
                cornerRadius: self.config.cornerRadius,
                height: self.config.height,
                width: self.config.width,
                activeTextColor: self.config.activeTextColor,
                activeBgColor: self.config.activeBgColor,
                inactiveTextColor: self.config.inactiveTextColor,
                inactiveBgColor: self.config.inactiveBgColor
            )
            self.config = newConfig
        }
    }
    
    /// 重置分段器状态
    public func reset() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.currentIndex = 0
            self.config = SubsectionConfig(items: [])
        }
    }
} 