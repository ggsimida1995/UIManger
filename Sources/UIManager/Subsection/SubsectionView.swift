import SwiftUI

/// 分段器视图
public struct SubsectionView: View {
    @StateObject private var manager = SubsectionManager.shared
    private let config: SubsectionConfig
    private let onChange: ((Int) -> Void)?
    
    // 动画配置
    private let animation: Animation = .spring(response: 0.3, dampingFraction: 0.8)
    private let spacing: CGFloat = 0
    private let padding: CGFloat = 2
    
    public init(
        config: SubsectionConfig? = nil,
        onChange: ((Int) -> Void)? = nil
    ) {
        self.config = config ?? SubsectionConfig(items: [])
        self.onChange = onChange
        
        // 设置默认选中索引
        if let config = config {
            manager.currentIndex = config.current
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !config.title.isEmpty {
                Text(config.title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            GeometryReader { proxy in
                ZStack(alignment: .bottomLeading) {
                    // 背景容器
                    HStack(spacing: spacing) {
                        ForEach(config.items.indices, id: \.self) { index in
                            SubsectionButton(
                                title: config.items[index].title,
                                isSelected: manager.currentIndex == index,
                                action: { selectItem(index) },
                                width: proxy.size.width / CGFloat(config.items.count),
                                height: proxy.size.height,
                                config: config
                            )
                        }
                    }
                    
                    // 滑动指示器
                    Rectangle()
                        .foregroundColor(config.activeBgColor)
                        .frame(width: proxy.size.width / CGFloat(config.items.count) - 2 * padding, height: proxy.size.height - 4)
                        .cornerRadius(config.cornerRadius)
                        .offset(x: CGFloat(manager.currentIndex) * (proxy.size.width / CGFloat(config.items.count)) + padding, y: 0)
                    
                    // 显示选中的文字
                    if let selectedItem = config.items[safe: manager.currentIndex] {
                        Text(selectedItem.title)
                            .font(.system(size: config.fontSize, weight: config.bold ? .bold : .regular))
                            .foregroundColor(config.activeTextColor)
                            .frame(width: proxy.size.width / CGFloat(config.items.count) - 2 * padding, height: proxy.size.height - 4)
                            .offset(x: CGFloat(manager.currentIndex) * (proxy.size.width / CGFloat(config.items.count)) + padding, y: 0)
                            .zIndex(1)
                    }
                }
                .frame(height: proxy.size.height)
                .background(config.inactiveBgColor)
                .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
            }
            .frame(height: 40)
        }
        .padding()
    }
    
    private func selectItem(_ index: Int) {
        withAnimation(animation) {
            manager.currentIndex = index
            onChange?(index)
        }
    }
}

/// 分段器按钮
private struct SubsectionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    let width: CGFloat
    let height: CGFloat
    let config: SubsectionConfig
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: config.fontSize, weight: config.bold ? .bold : .regular))
                .foregroundColor(isSelected ? config.activeTextColor : config.inactiveTextColor)
                .frame(width: width, height: height - 4)
        }
    }
}

// MARK: - 数组安全访问扩展
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}