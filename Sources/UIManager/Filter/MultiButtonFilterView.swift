import SwiftUI

/// 筛选按钮数据模型 - 支持动态标题和缓存
public struct FilterButton: Identifiable {
    public let id = UUID()
    public let defaultTitle: String
    public let cacheKey: String?
    public let dropdownContent: (Binding<String>, @escaping () -> Void, @escaping (Any?) -> Void, @escaping () -> Any?) -> AnyView
    
    public init<DropdownContent: View>(
        title: String,
        cacheKey: String? = nil,
        @ViewBuilder dropdownContent: @escaping (Binding<String>, @escaping () -> Void, @escaping (Any?) -> Void, @escaping () -> Any?) -> DropdownContent
    ) {
        self.defaultTitle = title
        self.cacheKey = cacheKey
        self.dropdownContent = { titleBinding, closePanel, setCacheData, getCacheData in
            AnyView(dropdownContent(titleBinding, closePanel, setCacheData, getCacheData))
        }
    }
}

/// 多按钮下拉筛选组件
public struct MultiButtonFilterView<Content: View>: View {
    let buttons: [FilterButton]
    let buttonStyle: FilterButtonStyle
    let content: Content
    
    @State private var expandedButtonId: UUID?
    @State private var buttonTitles: [UUID: String] = [:]
    @State private var buttonCache: [String: Any] = [:]
    
    private var springAnimation: Animation {
        .spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)
    }
    
    public init(
        buttons: [FilterButton], 
        buttonStyle: FilterButtonStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.buttons = buttons
        self.buttonStyle = buttonStyle
        self.content = content()
        
        _buttonTitles = State(initialValue: Dictionary(uniqueKeysWithValues: 
                                                        buttons.map { ($0.id, $0.defaultTitle) }
                                                      ))
    }
    
    public var body: some View {
        ZStack {
            GlassEffectContainer(spacing: 8.0) {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(Array(buttons.enumerated()), id: \.element.id) { index, button in
                            FilterButtonView(
                                title: buttonTitles[button.id] ?? button.defaultTitle,
                                isExpanded: expandedButtonId == button.id,
                                style: buttonStyle
                            ) {
                                withAnimation(springAnimation) {
                                    toggleButton(button.id)
                                }
                            }
                        }
                    }
                    .glassEffect(in: RoundedRectangle(cornerRadius: 0))
                    .background(Color.backgroundColor)
                    
                    
                    if let expandedButtonId = expandedButtonId,
                       let button = buttons.first(where: { $0.id == expandedButtonId }) {
                        
                        button.dropdownContent(
                            Binding(
                                get: { buttonTitles[button.id] ?? button.defaultTitle },
                                set: { buttonTitles[button.id] = $0 }
                            ),
                            {
                                withAnimation(springAnimation) {
                                    closeAllPanels()
                                }
                            },
                            { data in
                                setCachedData(data, for: button)
                            },
                            {
                                getCachedData(for: button)
                            }
                        )
                        // .background(Color.backgroundColor)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .offset(y: -20)),
                            removal: .opacity.combined(with: .offset(y: -20))
                        ))
                        .zIndex(1000)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .zIndex(100)
                
                content
                    .background(Color.backgroundColor)
                    .zIndex(10)
                
                if expandedButtonId != nil {
                    Color.overlayColor
                        .onTapGesture {
                            withAnimation(springAnimation) {
                                closeAllPanels()
                            }
                        }
                        .transition(.opacity)
                        .zIndex(50)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(.container, edges: .bottom)
    }
    
    private func toggleButton(_ buttonId: UUID) {
        expandedButtonId = (expandedButtonId == buttonId) ? nil : buttonId
    }
    
    private func closeAllPanels() {
        expandedButtonId = nil
    }
    
    private func getCachedData(for button: FilterButton) -> Any? {
        let key = button.cacheKey ?? button.id.uuidString
        return buttonCache[key]
    }
    
    private func setCachedData(_ data: Any?, for button: FilterButton) {
        let key = button.cacheKey ?? button.id.uuidString
        buttonCache[key] = data
    }
    
    /// 公共方法：清除所有筛选按钮的缓存
    public func clearAllFiltersCache() {
        buttonCache.removeAll()
        buttonTitles = Dictionary(uniqueKeysWithValues: 
                                    buttons.map { ($0.id, $0.defaultTitle) }
        )
    }
}

/// 筛选按钮视图
private struct FilterButtonView: View {
    let title: String
    let isExpanded: Bool
    let style: FilterButtonStyle
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 2) {
                Text(title)
                    .font(.system(size: style.fontSize, weight: .medium))
                    .foregroundColor(isExpanded ? style.selectedColor : Color.textColor)
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isExpanded ? style.selectedColor : Color.secondaryTextColor)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.easeInOut(duration: 0.35), value: isExpanded)
            }
            .padding(.vertical, style.verticalPadding)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        // .buttonStyle(.glass)
    }
}

/// 筛选按钮样式
public enum FilterButtonStyle {
    case `default`
    case compact
    case large
    
    var verticalPadding: CGFloat {
        switch self {
        case .default: return 12
        case .compact: return 8
        case .large: return 16
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .default: return 14
        case .compact: return 12
        case .large: return 16
        }
    }
    
    var selectedColor: Color {
        switch self {
        case .default: return Color.primaryButtonText
        case .compact: return Color.primaryColor
        case .large: return Color.successColor
        }
    }
}
