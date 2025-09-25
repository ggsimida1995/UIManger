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

// MARK: - 筛选事件定义

/// 筛选事件类型
public enum FilterEventType {
    case dropdownSelected  // 下拉列表选择
    case sectionsConfirmed // 分组面板确认
    case sectionsReset     // 分组面板重置
}

/// 筛选事件数据
public struct FilterEvent {
    public let buttonId: UUID
    public let buttonTitle: String
    public let eventType: FilterEventType
    public let data: FilterEventData
    
    public init(buttonId: UUID, buttonTitle: String, eventType: FilterEventType, data: FilterEventData) {
        self.buttonId = buttonId
        self.buttonTitle = buttonTitle
        self.eventType = eventType
        self.data = data
    }
}

/// 筛选事件数据联合体
public enum FilterEventData {
    case dropdown(selectedOption: DropdownOption)
    case sections(selectedItems: [DropdownItem])
}

/// 筛选事件回调类型
public typealias FilterEventCallback = (FilterEvent) -> Void
