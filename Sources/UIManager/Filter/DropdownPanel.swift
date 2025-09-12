import SwiftUI

/// 简单的下拉选项列表组件 - 支持缓存
public struct DropdownPanel: View {
    let options: [DropdownOption]
    @Binding var selectedTitle: String
    let onSelect: (DropdownOption) -> Void
    let setCacheData: (Any?) -> Void
    let getCacheData: () -> Any?
    
    @State private var currentSelection: DropdownOption
    
    public init(
        options: [DropdownOption],
        selectedTitle: Binding<String>,
        onSelect: @escaping (DropdownOption) -> Void,
        setCacheData: @escaping (Any?) -> Void,
        getCacheData: @escaping () -> Any?
    ) {
        self.options = options
        self._selectedTitle = selectedTitle
        self.onSelect = onSelect
        self.setCacheData = setCacheData
        self.getCacheData = getCacheData
        
        let defaultOption = options.first ?? DropdownOption(title: "", key: "", val: "")
        let cachedKey = getCacheData() as? String
        let cachedOption = cachedKey.flatMap { key in
            options.first { $0.key == key }
        } ?? defaultOption
        
        self._currentSelection = State(initialValue: cachedOption)
    }
    
    public var body: some View {
        VStack(spacing: 5) {
            ForEach(options, id: \.key) { option in
                Button(action: {
                    currentSelection = option
                    selectedTitle = option.title
                    setCacheData(option.key) // 缓存选择的key
                    onSelect(option)
                }) {
                    HStack {
                        Text(option.title)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color.textColor)
                        Spacer()
                        if option.key == currentSelection.key {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color.primaryButtonText)
                        }
                    }
                    .padding(5)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.glass)
                .background(
                    Capsule()
                        .fill(option.key == currentSelection.key ? Color.primaryButtonText : Color.secondaryBackgroundColor)
                ).padding(.horizontal, 20)
                
                if option.key != options.last?.key {
                    Divider()
                        .foregroundColor(Color.separatorColor)
                }
            }
        }.padding(.vertical, 10)
        .glassEffect(.clear,in: RoundedRectangle(cornerRadius: 0))
        .background(Color.backgroundColor)
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
