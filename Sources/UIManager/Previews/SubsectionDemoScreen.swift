#if DEBUG || PREVIEW
#if canImport(UIKit)
import SwiftUI
import UIKit

/// 分段器演示屏幕
struct SubsectionDemoScreen: View {
    @State private var selectedIndex = 0
    
    // 配置数据
    private let defaultConfig = SubsectionConfig(
        items: [
            SubsectionItem(title: "选项1", value: "1"),
            SubsectionItem(title: "选项2", value: "2"),
            SubsectionItem(title: "选项3", value: "3")
        ],
        current: 0
    )
    
    private let customColorConfig = SubsectionConfig(
        items: [
            SubsectionItem(title: "选项1", value: "1"),
            SubsectionItem(title: "选项2", value: "2"),
            SubsectionItem(title: "选项3", value: "3")
        ],
        current: 0,
        colorConfig:  ColorMode(
            activeTextColor: Color.black
        )
    )
    
    private let customFontConfig = SubsectionConfig(
        items: [
            SubsectionItem(title: "选项1", value: "1"),
            SubsectionItem(title: "选项2", value: "2"),
            SubsectionItem(title: "选项3", value: "3")
        ],
        current: 1,
        fontSize: 16
    )
    
    private let fontWeightExampleConfig = SubsectionConfig(
        title: "自定义粗细",
        items: [
            SubsectionItem(title: "常规字体", value: "regular"),
            SubsectionItem(title: "中等字体", value: "medium"),
            SubsectionItem(title: "粗体字体", value: "bold")
        ],
        current: 1,
        fontSize: 15
    )
    
    private let customCornerConfig = SubsectionConfig(
        items: [
            SubsectionItem(title: "选项1", value: "1"),
            SubsectionItem(title: "选项2", value: "2"),
            SubsectionItem(title: "选项3", value: "3")
        ],
        current: 2,
        cornerRadius: 20
    )
    
    private let customHeightConfig = SubsectionConfig(
        items: [
            SubsectionItem(title: "选项1", value: "1"),
            SubsectionItem(title: "选项2", value: "2"),
            SubsectionItem(title: "选项3", value: "3")
        ],
        current: 0,
        height: 44
    )
    
    private let customWidthConfig = SubsectionConfig(
        items: [
            SubsectionItem(title: "选项1", value: "1"),
            SubsectionItem(title: "选项2", value: "2"),
            SubsectionItem(title: "选项3", value: "3")
        ],
        current: 0,
        width: 200
    )
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                
                styleSection
                
                customizationSection
            }
            .padding()
        }
        .navigationTitle("分段器")
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }
    
    // MARK: - UI组件
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("分段器组件")
                .font(.title)
                .fontWeight(.bold)
            
            Text("灵活的分段选择组件，支持多种样式和配置")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom)
    }
    
    private var styleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("基础样式")
                .font(.headline)
            
            // 默认样式
            VStack(alignment: .leading, spacing: 8) {
                Text("默认样式")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                SubsectionView(config: defaultConfig) { index in
                    print("默认样式选中: \(index)")
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            )
        }
    }
    
    private var customizationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("自定义配置")
                .font(.headline)
            
            // 自定义颜色
            VStack(alignment: .leading, spacing: 8) {
                Text("自定义颜色")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                SubsectionView(config: customColorConfig) { index in
                    print("自定义颜色选中: \(index)")
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            )
            
            // 自定义字体
            VStack(alignment: .leading, spacing: 8) {
                Text("自定义字体")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                SubsectionView(config: customFontConfig) { index in
                    print("自定义字体选中: \(index)")
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            )
            
            // 字体粗细
            VStack(alignment: .leading, spacing: 8) {
                Text("字体粗细")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                SubsectionView(config: fontWeightExampleConfig) { index in
                    print("字体粗细选中: \(index)")
                }
                
                HStack(spacing: 12) {
                    Text("可用粗细:")
                        .font(.caption)
                    
                    Text("ultraLight")
                        .font(.system(size: 12, weight: .ultraLight))
                    
                    Text("light")
                        .font(.system(size: 12, weight: .light))
                    
                    Text("regular")
                        .font(.system(size: 12, weight: .regular))
                    
                    Text("medium")
                        .font(.system(size: 12, weight: .medium))
                    
                    Text("semibold")
                        .font(.system(size: 12, weight: .semibold))
                    
                    Text("bold")
                        .font(.system(size: 12, weight: .bold))
                    
                    Text("heavy")
                        .font(.system(size: 12, weight: .heavy))
                    
                    Text("black")
                        .font(.system(size: 12, weight: .black))
                }
                .padding(.top, 4)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            )
            
            // 自定义圆角
            VStack(alignment: .leading, spacing: 8) {
                Text("自定义圆角")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                SubsectionView(config: customCornerConfig) { index in
                    print("自定义圆角选中: \(index)")
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            )
            
            // 自定义高度
            VStack(alignment: .leading, spacing: 8) {
                Text("自定义高度")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                SubsectionView(config: customHeightConfig) { index in
                    print("自定义高度选中: \(index)")
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            )
            
            // 自定义宽度
            VStack(alignment: .leading, spacing: 8) {
                Text("自定义宽度")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                SubsectionView(config: customWidthConfig) { index in
                    print("自定义宽度选中: \(index)")
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            )
        }
    }
}

#Preview {
    SubsectionDemoScreen()
}
#endif
#endif 
