#if DEBUG || PREVIEW
import SwiftUI

public struct ThemeDemoView: View {
    @EnvironmentObject private var themeManager: UIManagerThemeViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            Text("主题设置")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(themeManager.primaryTextColor)
            
            // 主题切换开关
            Toggle("跟随系统外观", isOn: $themeManager.followsSystem)
                .foregroundColor(themeManager.primaryTextColor)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(themeManager.backgroundColor)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                )
            
            if !themeManager.followsSystem {
                Toggle("暗黑模式", isOn: $themeManager.isDarkMode)
                    .foregroundColor(themeManager.primaryTextColor)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(themeManager.backgroundColor)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
            } else {
                Text("当前系统外观：\(colorScheme == .dark ? "暗色" : "亮色")")
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            
            // 颜色预览
            VStack(spacing: 15) {
                colorPreviewRow(title: "背景色", color: themeManager.backgroundColor)
                colorPreviewRow(title: "主要文本色", color: themeManager.primaryTextColor)
                colorPreviewRow(title: "次要文本色", color: themeManager.secondaryTextColor)
                colorPreviewRow(title: "主题色", color: themeManager.themeColor)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(themeManager.backgroundColor)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
            
            Spacer()
        }
        .padding()
        .background(themeManager.backgroundColor.edgesIgnoringSafeArea(.all))
        .onChange(of: colorScheme) { newColorScheme in
            themeManager.updateWithColorScheme(newColorScheme)
        }
        .onAppear {
            themeManager.updateWithColorScheme(colorScheme)
        }
    }
    
    private func colorPreviewRow(title: String, color: Color) -> some View {
        HStack {
            Text(title)
                .foregroundColor(themeManager.primaryTextColor)
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 5)
                .fill(color)
                .frame(width: 30, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(themeManager.isDarkMode ? Color.white.opacity(0.2) : Color.black.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

// MARK: - Previews
struct ThemeDemoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ThemeDemoView()
                .environmentObject(UIManagerThemeViewModel.shared)
                .preferredColorScheme(.light)
            
            ThemeDemoView()
                .environmentObject(UIManagerThemeViewModel.shared)
                .preferredColorScheme(.dark)
        }
    }
}
#endif 