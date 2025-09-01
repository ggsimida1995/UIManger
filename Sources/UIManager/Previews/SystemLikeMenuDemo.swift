import SwiftUI

/// 自定义系统风格下拉菜单 Demo：左下角，固定宽度，8 个图标项
public struct SystemLikeMenuDemo: View {
    private enum Option: String, CaseIterable, Identifiable {
        case all, new, promotion, hot, discount, topRated, nearby, inStock
        var id: String { rawValue }
        var title: String {
            switch self {
            case .all: return "全部商品"
            case .new: return "新款商品"
            case .promotion: return "活动商品"
            case .hot: return "热销商品"
            case .discount: return "折扣商品"
            case .topRated: return "高评分"
            case .nearby: return "附近"
            case .inStock: return "有货"
            }
        }
        var icon: String {
            switch self {
            case .all: return "bag.fill"
            case .new: return "sparkles"
            case .promotion: return "tag.fill"
            case .hot: return "flame.fill"
            case .discount: return "percent"
            case .topRated: return "star.fill"
            case .nearby: return "location.fill"
            case .inStock: return "checkmark.seal.fill"
            }
        }
    }

    @State private var selected: Option = .all

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("系统默认 Menu")
                .font(.headline)

            // 系统默认 Menu
            Menu {
                ForEach(Option.allCases) { option in
                    Button(action: { selected = option }) {
                        Label(option.title, systemImage: option.icon)
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "ellipsis.circle")
                    Text("选择分类")
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.25))
                )
            }

            Spacer()
        }
        .padding()
    }
}

#if DEBUG
#Preview("系统风格自定义菜单 Demo") {
    SystemLikeMenuDemo()
}
#endif


