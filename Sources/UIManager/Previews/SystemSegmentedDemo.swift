import SwiftUI

/// 系统自带分段器（Segmented Control）演示
public struct SystemSegmentedDemo: View {
    private enum Segment: String, CaseIterable, Identifiable {
        case comprehensive
        case sales
        case price
        var id: String { rawValue }
        var title: String {
            switch self {
            case .comprehensive: return "综合"
            case .sales: return "销量"
            case .price: return "价格"
            }
        }
    }

    @State private var selected: Segment = .comprehensive

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("系统分段器 Picker(.segmented)")
                .font(.headline)

            Picker("排序方式", selection: $selected) {
                ForEach(Segment.allCases) { seg in
                    Text(seg.title).tag(seg)
                }
            }
            .pickerStyle(.segmented)

            Group {
                Text("当前选择：\(selected.title)")
                Text("这是系统提供的原生样式，可自动适配平台与暗色模式。")
                    .foregroundColor(.secondary)
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
        }
        .padding()
    }
}

#if DEBUG
#Preview("系统分段器 Demo") {
    SystemSegmentedDemo()
}
#endif


