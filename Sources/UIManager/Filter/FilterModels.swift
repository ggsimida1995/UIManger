import SwiftUI

// MARK: - 筛选组件数据模型

/// 选择模式枚举
public enum SelectionMode {
    case single    // 单选
    case multiple  // 多选
}

/// 复杂下拉面板的分组数据模型
public struct DropdownSection: Identifiable {
    public let id = UUID()
    public let title: String
    public var items: [DropdownItem]
    public let selectionMode: SelectionMode
    
    public init(title: String, items: [DropdownItem], selectionMode: SelectionMode = .single) {
        self.title = title
        self.items = items
        self.selectionMode = selectionMode
    }
}

/// 下拉面板项目数据模型
public struct DropdownItem: Identifiable {
    public let id = UUID()
    public let title: String
    public let key: String
    public let val: String
    public var isSelected: Bool
    
    public init(title: String, key: String, val: String, isSelected: Bool = false) {
        self.title = title
        self.key = key
        self.val = val
        self.isSelected = isSelected
    }
}

/// 简单下拉选项数据模型
public struct DropdownOption {
    public let title: String
    public let key: String
    public let val: String
    
    public init(title: String, key: String, val: String) {
        self.title = title
        self.key = key
        self.val = val
    }
}
