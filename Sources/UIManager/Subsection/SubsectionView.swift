import SwiftUI
import UIKit

/// 分段器视图
public struct SubsectionView: View {
    @State private var currentIndex: Int
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
        self._currentIndex = State(initialValue: config?.current ?? 0)
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
                                isSelected: currentIndex == index,
                                action: { selectItem(index) },
                                width: proxy.size.width / CGFloat(config.items.count),
                                height: proxy.size.height,
                                config: config,
                                colorConfig: config.colorConfig
                            )
                        }
                    }
                    
                    // 滑动指示器
                    Rectangle()
                        .foregroundColor(config.colorConfig.activeBgColor)
                        .frame(width: proxy.size.width / CGFloat(config.items.count) - 2 * padding, height: proxy.size.height - 4)
                        .cornerRadius(config.cornerRadius)
                        .offset(x: CGFloat(currentIndex) * (proxy.size.width / CGFloat(config.items.count)) + padding, y: 0)
                    
                    // 显示选中的文字
                    if let selectedItem = config.items[safe: currentIndex] {
                        Text(selectedItem.title)
                            .font(.system(size: config.fontSize, weight: config.bold ? .bold : .regular))
                            .foregroundColor(config.colorConfig.activeTextColor)
                            .frame(width: proxy.size.width / CGFloat(config.items.count) - 2 * padding, height: proxy.size.height - 4)
                            .offset(x: CGFloat(currentIndex) * (proxy.size.width / CGFloat(config.items.count)) + padding, y: 0)
                            .zIndex(1)
                    }
                }
                .frame(height: proxy.size.height)
                .background(config.colorConfig.inactiveBgColor)
                .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
            }
            .frame(height: config.height)
            .frame(maxWidth: config.width)
            .padding(10)
        }
    }
    
    private func selectItem(_ index: Int) {
        withAnimation(animation) {
            currentIndex = index
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
    let colorConfig: ColorMode
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: config.fontSize, weight: config.bold ? .bold : .regular))
                .foregroundColor(isSelected ? colorConfig.activeTextColor : colorConfig.inactiveTextColor)
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
