import SwiftUI

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

/// 复杂的下拉面板组件
public struct ComplexDropdownPanel: View {
    let sections: [DropdownSection]
    @Binding var selectedTitle: String
    let onSelectionChange: ([DropdownSection]) -> Void
    let onConfirm: ([DropdownItem]) -> Void
    let onReset: () -> Void
    let setCacheData: (Any?) -> Void
    let getCacheData: () -> Any?
    let globalSelectionMode: SelectionMode?
    
    @State private var workingSections: [DropdownSection]
    
    public init(
        sections: [DropdownSection],
        selectedTitle: Binding<String>,
        onSelectionChange: @escaping ([DropdownSection]) -> Void,
        onConfirm: @escaping ([DropdownItem]) -> Void,
        onReset: @escaping () -> Void,
        setCacheData: @escaping (Any?) -> Void,
        getCacheData: @escaping () -> Any?,
        globalSelectionMode: SelectionMode? = nil
    ) {
        self.sections = sections
        self._selectedTitle = selectedTitle
        self.onSelectionChange = onSelectionChange
        self.onConfirm = onConfirm
        self.onReset = onReset
        self.setCacheData = setCacheData
        self.getCacheData = getCacheData
        self.globalSelectionMode = globalSelectionMode
        
        var initialSections = sections
        
        if let cachedSelections = getCacheData() as? [[Bool]] {
            for (sectionIndex, section) in initialSections.enumerated() {
                if sectionIndex < cachedSelections.count && cachedSelections[sectionIndex].count == section.items.count {
                    for (itemIndex, isSelected) in cachedSelections[sectionIndex].enumerated() {
                        initialSections[sectionIndex].items[itemIndex].isSelected = isSelected
                    }
                }
            }
        }
        
        self._workingSections = State(initialValue: initialSections)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(Array(workingSections.enumerated()), id: \.element.id) { sectionIndex, section in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(section.title)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color.textColor)
                                
                                Spacer()
                                
                                Text(getEffectiveSelectionMode(for: section) == .single ? "单选" : "多选")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(Color.secondaryTextColor)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.secondaryBackgroundColor)
                                    .cornerRadius(4)
                            }
                            .padding(.horizontal, 16)
                            
                            TagGridView(
                                items: section.items,
                                onItemToggle: { itemIndex in
                                    toggleItem(sectionIndex: sectionIndex, itemIndex: itemIndex)
                                }
                            )
                            .padding(.horizontal, 16)
                        }
                    }
                }
                .padding(.vertical, 16)
                .padding(.bottom, 30)
            }
            .frame(height: 350)
            
            HStack {
                Spacer()
                
                HStack(spacing: 8) {
                    Button(action: {
                        resetSelections()
                        onReset()
                    }) {
                        Text("重置")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color.secondaryButtonText)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                    }.buttonStyle(.glass)
                    .background(
                        Capsule()
                            .fill(Color.secondaryButtonBackground)
                    )
                    
                    Button(action: {
                        let cacheData = workingSections.map { section in
                            section.items.map { $0.isSelected }
                        }
                        setCacheData(cacheData)
                        onSelectionChange(workingSections)
                        
                        let selectedItems = workingSections.flatMap { $0.items }.filter { $0.isSelected }
                        onConfirm(selectedItems)
                    }) {
                        Text("确定")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical,5)
                    }.buttonStyle(.glass)
                    .background(
                        Capsule()
                            .fill(Color.primaryButtonText)
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 12)
        }
        // .glassEffect(.clear,in: RoundedRectangle(cornerRadius: 0))
        .background(Color.backgroundColor)
    }
    
    private func toggleItem(sectionIndex: Int, itemIndex: Int) {
        let currentSection = workingSections[sectionIndex]
        let currentItem = currentSection.items[itemIndex]
        let effectiveMode = getEffectiveSelectionMode(for: currentSection)
        
        switch effectiveMode {
        case .single:
            if currentItem.isSelected {
                workingSections[sectionIndex].items[itemIndex].isSelected = false
            } else {
                for i in workingSections[sectionIndex].items.indices {
                    workingSections[sectionIndex].items[i].isSelected = false
                }
                workingSections[sectionIndex].items[itemIndex].isSelected = true
            }
            
        case .multiple:
            workingSections[sectionIndex].items[itemIndex].isSelected.toggle()
        }
        
        onSelectionChange(workingSections)
        updateSelectedTitle()
    }
    
    private func resetSelections() {
        for sectionIndex in workingSections.indices {
            for itemIndex in workingSections[sectionIndex].items.indices {
                workingSections[sectionIndex].items[itemIndex].isSelected = false
            }
        }
        setCacheData(nil)
        selectedTitle = "筛选"
        onSelectionChange(workingSections)
    }
    
    private func updateSelectedTitle() {
        let count = calculateSelectedCount()
        selectedTitle = count == 0 ? "筛选" : "筛选(\(count))"
    }
    
    private func calculateSelectedCount() -> Int {
        let hasMultipleSelectionSections = workingSections.contains { section in
            let effectiveMode = getEffectiveSelectionMode(for: section)
            return effectiveMode == .multiple && section.items.contains { $0.isSelected }
        }
        
        if hasMultipleSelectionSections {
            return workingSections.flatMap { $0.items }.filter { $0.isSelected }.count
        } else {
            return workingSections.filter { section in
                section.items.contains { $0.isSelected }
            }.count
        }
    }
    
    private func getEffectiveSelectionMode(for section: DropdownSection) -> SelectionMode {
        return globalSelectionMode ?? section.selectionMode
    }
}

/// 标签网格视图
private struct TagGridView: View {
    let items: [DropdownItem]
    let onItemToggle: (Int) -> Void
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                TagButton(
                    title: item.title,
                    isSelected: item.isSelected
                ) {
                    onItemToggle(index)
                }
            }
        }
    }
}

/// 单个标签按钮
private struct TagButton: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isSelected ? .white : Color.textColor)
                .frame(maxWidth: .infinity)
                .padding(2)
        }
        .buttonStyle(.glass)
        .background(
            Capsule()
                .fill(isSelected ? Color.primaryButtonText : Color.secondaryBackgroundColor)
        )
    }
}


