#if DEBUG || PREVIEW
#if canImport(UIKit)
import SwiftUI

/// 按钮组件预览
public struct ButtonDemo: View {
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                
                typeSection
                
                styleSection
                
                sizeSection
                
                combinationSection
            }
            .padding()
        }
        .navigationTitle("按钮组件")
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }
    
    // MARK: - UI组件
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("按钮组件")
                .font(.title)
                .fontWeight(.bold)
            
            Text("丰富的按钮样式和交互效果")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom)
    }
    
    private var typeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("按钮类型")
                .font(.headline)
            
            // 信息按钮
            UIButton(button: ButtonData(
                title: "信息按钮",
                type: .info,
                action: { print("信息按钮点击") }
            ))
            
            // 主要按钮
            UIButton(button: ButtonData(
                title: "主要按钮",
                type: .primary,
                action: { print("主要按钮点击") }
            ))
            
            // 成功按钮
            UIButton(button: ButtonData(
                title: "成功按钮",
                type: .success,
                action: { print("成功按钮点击") }
            ))
            
            // 警告按钮
            UIButton(button: ButtonData(
                title: "警告按钮",
                type: .warning,
                action: { print("警告按钮点击") }
            ))
            
            // 错误按钮
            UIButton(button: ButtonData(
                title: "错误按钮",
                type: .error,
                action: { print("错误按钮点击") }
            ))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private var styleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("按钮样式")
                .font(.headline)
            
            // 镂空按钮
            UIButton(button: ButtonData(
                title: "镂空按钮",
                type: .primary,
                plain: true,
                action: { print("镂空按钮点击") }
            ))
            
            // 细边按钮
            UIButton(button: ButtonData(
                title: "细边按钮",
                type: .primary,
                hairline: true,
                action: { print("细边按钮点击") }
            ))
            
            // 禁用按钮
            UIButton(button: ButtonData(
                title: "禁用按钮",
                type: .primary,
                disabled: true,
                action: { print("禁用按钮点击") }
            ))
            
            // 加载中按钮
            UIButton(button: ButtonData(
                title: "加载按钮",
                type: .primary,
                loading: true,
                loadingText: "加载中...",
                action: { print("加载按钮点击") }
            ))
            
            // 带图标的按钮
            UIButton(button: ButtonData(
                title: "图标按钮",
                type: .primary,
                icon: "star.fill",
                action: { print("图标按钮点击") }
            ))
            
            // 圆形按钮
            UIButton(button: ButtonData(
                title: "圆形按钮",
                type: .primary,
                shape: .circle,
                action: { print("圆形按钮点击") }
            ))
            
            // 渐变按钮
            UIButton(button: ButtonData(
                title: "渐变按钮",
                type: .primary,
                color: LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                action: { print("渐变按钮点击") }
            ))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private var sizeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("按钮尺寸")
                .font(.headline)
            
            HStack(spacing: 10) {
                UIButton(button: ButtonData(
                    title: "迷你",
                    type: .primary,
                    size: .mini,
                    action: { print("迷你按钮点击") }
                ))
                
                UIButton(button: ButtonData(
                    title: "标准",
                    type: .primary,
                    size: .normal,
                    action: { print("标准按钮点击") }
                ))
                
                UIButton(button: ButtonData(
                    title: "大型",
                    type: .primary,
                    size: .large,
                    action: { print("大型按钮点击") }
                ))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private var combinationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("样式组合")
                .font(.headline)
            
            // 镂空细边按钮
            UIButton(button: ButtonData(
                title: "镂空细边按钮",
                type: .primary,
                plain: true,
                hairline: true,
                action: { print("镂空细边按钮点击") }
            ))
            
            // 带图标的圆形按钮
            UIButton(button: ButtonData(
                title: "图标圆形按钮",
                type: .primary,
                icon: "star.fill",
                shape: .circle,
                action: { print("图标圆形按钮点击") }
            ))
            
            // 加载中的细边按钮
            UIButton(button: ButtonData(
                title: "加载细边按钮",
                type: .primary,
                hairline: true,
                loading: true,
                loadingText: "加载中...",
                action: { print("加载细边按钮点击") }
            ))
            
            // 禁用渐变按钮
            UIButton(button: ButtonData(
                title: "禁用渐变按钮",
                type: .primary,
                disabled: true,
                color: LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                action: { print("禁用渐变按钮点击") }
            ))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
}

// MARK: - 预览
// #Preview {
//     NavigationView {
//         ButtonDemo()
//     }
// }
#endif
#endif 