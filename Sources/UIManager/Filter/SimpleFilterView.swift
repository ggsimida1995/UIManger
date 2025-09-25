import SwiftUI

/// 简化的筛选按钮数据模型
public struct SimpleFilterButton: Identifiable {
    public let id = UUID()
    public let defaultTitle: String
    public let panelContent: (Binding<String>, @escaping () -> Void, @escaping (Any?) -> Void, @escaping () -> Any?, @escaping (FilterEvent) -> Void) -> AnyView
    
    fileprivate init(
        title: String,
        content: @escaping (Binding<String>, @escaping () -> Void, @escaping (Any?) -> Void, @escaping () -> Any?, @escaping (FilterEvent) -> Void) -> AnyView
    ) {
        self.defaultTitle = title
        self.panelContent = content
    }
}


/// 简化的筛选组件
public struct SimpleFilterView<Content: View>: View {
    let buttons: [SimpleFilterButton]
    let content: Content
    let onFilterEvent: FilterEventCallback?
    
    @State private var expandedButtonId: UUID?
    @State private var buttonTitles: [UUID: String] = [:]
    @State private var buttonCache: [UUID: Any] = [:]  // 添加状态缓存
    
    public init(
        buttons: [SimpleFilterButton],
        onFilterEvent: FilterEventCallback? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.buttons = buttons
        self.content = content()
        self.onFilterEvent = onFilterEvent
        
        // 初始化按钮标题
        _buttonTitles = State(initialValue: Dictionary(uniqueKeysWithValues: 
                                                        buttons.map { ($0.id, $0.defaultTitle) }
                                                      ))
    }
    
    public var body: some View {
        ZStack {
            // 主内容和按钮栏
            VStack(spacing: 0) {
                // 筛选按钮栏
                HStack(spacing: 0) {
                    ForEach(buttons) { button in
                        FilterButtonView(
                            title: buttonTitles[button.id] ?? button.defaultTitle,
                            isExpanded: expandedButtonId == button.id
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                toggleButton(button.id)
                            }
                        }
                    }
                }
                .background(Color.backgroundColor)
                // .glassEffect(in: RoundedRectangle(cornerRadius: 0))
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                
                
                
                // 下拉面板层
                VStack(spacing: 0) {
                    
                    // 下拉面板
                    if let expandedButtonId = expandedButtonId,
                       let button = buttons.first(where: { $0.id == expandedButtonId }) {
                        
                        button.panelContent(
                            Binding(
                                get: { buttonTitles[button.id] ?? button.defaultTitle },
                                set: { buttonTitles[button.id] = $0 }
                            ),
                            {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    self.expandedButtonId = nil
                                }
                            },
                            { data in
                                buttonCache[button.id] = data
                            },
                            {
                                buttonCache[button.id]
                            },
                            { filterEvent in
                                onFilterEvent?(filterEvent)
                            }
                        )
                        .id(button.id) // 添加唯一ID，确保不同按钮的面板不会被重用
                        .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .top)))
                    }
                    
                    
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
            }
            .zIndex(1000)
            
            
            VStack {
                Spacer().frame(height: 40)
                // 主内容
                content
            }
            .zIndex(1)
            
            // 蒙层
            if expandedButtonId != nil {
                Color.overlayColor
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            expandedButtonId = nil
                        }
                    }
                    .transition(.opacity)
                    .ignoresSafeArea(.container, edges: .bottom)
                    .zIndex(50)
            }
            
            
        }
    }
    
    private func toggleButton(_ buttonId: UUID) {
        expandedButtonId = (expandedButtonId == buttonId) ? nil : buttonId
    }
}

/// 筛选按钮视图
private struct FilterButtonView: View {
    let title: String
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isExpanded ? Color.primaryButtonText : Color.textColor)
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(isExpanded ? Color.primaryButtonText : Color.secondaryTextColor)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.easeInOut(duration: 0.2), value: isExpanded)
            }
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 两种筛选模式

public extension SimpleFilterButton {
    /// 方式1：简单下拉列表
    static func dropdown(
        title: String,
        options: [DropdownOption],
        onConfirm: ((DropdownOption) -> Void)? = nil
    ) -> SimpleFilterButton {
        // 如果有选项，使用第一个选项作为初始标题
        let initialTitle = options.first?.title ?? title
        
        return SimpleFilterButton(title: initialTitle) { titleBinding, closePanel, setCacheData, getCacheData, onFilterEvent in
            AnyView(SimpleDropdownView(
                options: options,
                titleBinding: titleBinding,
                closePanel: closePanel,
                setCacheData: setCacheData,
                getCacheData: getCacheData,
                onFilterEvent: onFilterEvent,
                onDropdownSelect: onConfirm
            ))
        }
    }
    
    /// 方式2：复杂分组面板
    static func sections(
        title: String,
        sections: [DropdownSection],
        globalSelectionMode: SelectionMode? = nil,
        onConfirm: (([DropdownItem]) -> Void)? = nil,
        onReset: (() -> Void)? = nil
    ) -> SimpleFilterButton {
        return SimpleFilterButton(title: title) { titleBinding, closePanel, setCacheData, getCacheData, onFilterEvent in
            AnyView(SimpleSectionView(
                sections: sections,
                globalSelectionMode: globalSelectionMode,
                titleBinding: titleBinding,
                closePanel: closePanel,
                setCacheData: setCacheData,
                getCacheData: getCacheData,
                onFilterEvent: onFilterEvent,
                onSectionsConfirm: onConfirm,
                onSectionsReset: onReset
            ))
        }
    }
}


// MARK: - 方式1：简单下拉列表视图

/// 简单下拉列表视图
private struct SimpleDropdownView: View {
    let options: [DropdownOption]
    let titleBinding: Binding<String>
    let closePanel: () -> Void
    let setCacheData: (Any?) -> Void
    let getCacheData: () -> Any?
    let onFilterEvent: (FilterEvent) -> Void
    let onDropdownSelect: ((DropdownOption) -> Void)?
    
    @State private var selectedOption: DropdownOption?
    
    init(
        options: [DropdownOption],
        titleBinding: Binding<String>,
        closePanel: @escaping () -> Void,
        setCacheData: @escaping (Any?) -> Void,
        getCacheData: @escaping () -> Any?,
        onFilterEvent: @escaping (FilterEvent) -> Void,
        onDropdownSelect: ((DropdownOption) -> Void)? = nil
    ) {
        self.options = options
        self.titleBinding = titleBinding
        self.closePanel = closePanel
        self.setCacheData = setCacheData
        self.getCacheData = getCacheData
        self.onFilterEvent = onFilterEvent
        self.onDropdownSelect = onDropdownSelect
        
        // 优先恢复缓存的选择，否则匹配当前title，最后默认第一个
        let cachedKey = getCacheData() as? String
        let cachedOption = cachedKey.flatMap { key in
            options.first { $0.key == key }
        }
        
        let currentTitle = titleBinding.wrappedValue
        let matchedOption = options.first { $0.title == currentTitle }
        let defaultOption = cachedOption ?? matchedOption ?? options.first
        
        self._selectedOption = State(initialValue: defaultOption)
    }
    
    var body: some View {
        VStack(spacing: 5) {
            ForEach(options, id: \.key) { option in
                HStack {
                    Text(option.title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.textColor)
                    Spacer()
                    if option.key == selectedOption?.key {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color.primaryButtonText)
                    }
                }
                .frame(height: 30)
                .padding(.vertical, 5)
                .padding(.horizontal, 20)
                .contentShape(Rectangle())
                .background(
                    Capsule()
                        .fill(option.key == selectedOption?.key ? Color.primaryButtonText.opacity(0.3) : Color.secondaryBackgroundColor)
                )
                .glassEffect(.clear.interactive())
                .onTapGesture {
                    selectedOption = option
                    titleBinding.wrappedValue = option.title
                    setCacheData(option.key) // 保存选择到缓存
                    
                    // 触发单独的事件回调
                    onDropdownSelect?(option)
                    
                    // 触发通用事件回调 (按钮ID将在上层修正)
                    let filterEvent = FilterEvent(
                        buttonId: UUID(), // 占位ID，将在上层被替换
                        buttonTitle: titleBinding.wrappedValue,
                        eventType: .dropdownSelected,
                        data: .dropdown(selectedOption: option)
                    )
                    onFilterEvent(filterEvent)
                    
                    closePanel()
                }
                
                if option.key != options.last?.key {
                    Divider()
                        .foregroundColor(Color.separatorColor)
                        .padding(.horizontal, 20)
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(Color.backgroundColor)
        // .glassEffect(in: RoundedRectangle(cornerRadius: 0))
        .onAppear {
            // 根据当前标题恢复正确的选中状态
            let currentTitle = titleBinding.wrappedValue
            if let matchedOption = options.first(where: { $0.title == currentTitle }) {
                selectedOption = matchedOption
            } else if selectedOption == nil, let firstOption = options.first {
                // 只有当没有选中项时才设置默认值
                selectedOption = firstOption
                titleBinding.wrappedValue = firstOption.title
            }
        }
    }
}

// MARK: - 方式2：复杂分组面板视图

/// 复杂分组面板视图
private struct SimpleSectionView: View {
    let initialSections: [DropdownSection]
    let globalSelectionMode: SelectionMode?
    let titleBinding: Binding<String>
    let closePanel: () -> Void
    let setCacheData: (Any?) -> Void
    let getCacheData: () -> Any?
    let onFilterEvent: (FilterEvent) -> Void
    let onSectionsConfirm: (([DropdownItem]) -> Void)?
    let onSectionsReset: (() -> Void)?
    
    @State private var workingSections: [DropdownSection]
    
    init(
        sections: [DropdownSection],
        globalSelectionMode: SelectionMode?,
        titleBinding: Binding<String>,
        closePanel: @escaping () -> Void,
        setCacheData: @escaping (Any?) -> Void,
        getCacheData: @escaping () -> Any?,
        onFilterEvent: @escaping (FilterEvent) -> Void,
        onSectionsConfirm: (([DropdownItem]) -> Void)? = nil,
        onSectionsReset: (() -> Void)? = nil
    ) {
        self.initialSections = sections
        self.globalSelectionMode = globalSelectionMode
        self.titleBinding = titleBinding
        self.closePanel = closePanel
        self.setCacheData = setCacheData
        self.getCacheData = getCacheData
        self.onFilterEvent = onFilterEvent
        self.onSectionsConfirm = onSectionsConfirm
        self.onSectionsReset = onSectionsReset
        
        var initializedSections = sections
        
        // 从缓存恢复选择状态
        if let cachedSelections = getCacheData() as? [[Bool]] {
            for (sectionIndex, section) in initializedSections.enumerated() {
                if sectionIndex < cachedSelections.count && cachedSelections[sectionIndex].count == section.items.count {
                    for (itemIndex, isSelected) in cachedSelections[sectionIndex].enumerated() {
                        initializedSections[sectionIndex].items[itemIndex].isSelected = isSelected
                    }
                }
            }
        }
        
        self._workingSections = State(initialValue: initializedSections)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(Array(workingSections.enumerated()), id: \.element.id) { sectionIndex, section in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(section.title)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textColor)
                                
                                Spacer()
                                
                                Text(getEffectiveSelectionMode(for: section) == .single ? "单选" : "多选")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.secondaryTextColor)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.secondaryBackgroundColor)
                                    .cornerRadius(4)
                            }
                            .padding(.horizontal, 16)
                            
                            SectionItemsView(
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
            
            // 底部按钮
            HStack {
                Spacer()
                
                HStack(spacing: 8) {
                    
                    Text("重置")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color.secondaryButtonText)
                        .frame(width: 60, height: 30)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color.secondaryButtonBackground)
                        )
                        .glassEffect(.clear.interactive())
                        .onTapGesture {
                            
                            // 触发单独的重置回调
                            onSectionsReset?()
                            
                            // 触发通用重置事件 (按钮ID将在上层修正)
                            let filterEvent = FilterEvent(
                                buttonId: UUID(), // 占位ID，将在上层被替换
                                buttonTitle: titleBinding.wrappedValue,
                                eventType: .sectionsReset,
                                data: .sections(selectedItems: [])
                            )
                            onFilterEvent(filterEvent)
                        }
                    
                    Text("确定")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 30)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color.primaryButtonText)
                        )
                        .glassEffect(.clear.interactive())
                        .onTapGesture {
                            let cacheData = workingSections.map { section in
                                section.items.map { $0.isSelected }
                            }
                            setCacheData(cacheData) // 保存选择状态到缓存
                            updateTitle()
                            
                            // 获取所有选中的项目
                            let selectedItems = workingSections.flatMap { $0.items }.filter { $0.isSelected }
                            
                            // 触发单独的确认回调
                            onSectionsConfirm?(selectedItems)
                            
                            // 触发通用确认事件 (按钮ID将在上层修正)
                            let filterEvent = FilterEvent(
                                buttonId: UUID(), // 占位ID，将在上层被替换
                                buttonTitle: titleBinding.wrappedValue,
                                eventType: .sectionsConfirmed,
                                data: .sections(selectedItems: selectedItems)
                            )
                            onFilterEvent(filterEvent)
                            
                            closePanel()
                        }
                    
                    
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 12)
        }
        .background(Color.backgroundColor)
        // .glassEffect(in: RoundedRectangle(cornerRadius: 0))
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
                // 清除该分组的其他选择
                for i in workingSections[sectionIndex].items.indices {
                    workingSections[sectionIndex].items[i].isSelected = false
                }
                workingSections[sectionIndex].items[itemIndex].isSelected = true
            }
            
        case .multiple:
            workingSections[sectionIndex].items[itemIndex].isSelected.toggle()
        }
        
        // 不实时更新title，等待用户确定
    }
    
    private func resetSelections() {
        for sectionIndex in workingSections.indices {
            for itemIndex in workingSections[sectionIndex].items.indices {
                workingSections[sectionIndex].items[itemIndex].isSelected = false
            }
        }
        setCacheData(nil) // 清除缓存
        // 重置后立即更新title
        updateTitle()
    }
    
    private func updateTitle() {
        let selectedCount = calculateSelectedCount()
        // 获取按钮的原始标题（去掉计数后缀）
        let originalTitle = titleBinding.wrappedValue.components(separatedBy: "(").first ?? "筛选"
        
        if selectedCount == 0 {
            titleBinding.wrappedValue = originalTitle
        } else {
            titleBinding.wrappedValue = "\(originalTitle)(\(selectedCount))"
        }
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

/// 分组项目网格视图
private struct SectionItemsView: View {
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
                Text(item.title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(item.isSelected ? .white : Color.textColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .padding(2)
                    .background(
                        Capsule()
                            .fill(item.isSelected ? Color.primaryButtonText.opacity(0.3) : Color.secondaryBackgroundColor)
                    )
                    .glassEffect(.clear.interactive())
                    .onTapGesture {
                        onItemToggle(index)
                    }
            }
        }
    }
}
