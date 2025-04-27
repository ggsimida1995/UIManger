import SwiftUI

/// 按钮视图
public struct UIButton: View {
    public var button: ButtonData
    
    public var body: some View {
        SwiftUI.Button(action: button.action) {
            HStack(spacing: 8) {
                if button.loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: button.plain ? button.type.themeColor : button.type.textColor))
                        .scaleEffect(0.8)
                }
                
                if let icon = button.icon {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                
                Text(button.loading ? (button.loadingText ?? button.title) : button.title)
                    .font(.system(size: button.size.fontSize, weight: .medium))
                    .foregroundColor(button.plain ? button.type.themeColor : button.type.textColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: button.size.height)
            .background(
                Group {
                    if button.plain {
                        // 镂空样式
                        Color.clear
                    } else if let gradient = button.color {
                        // 渐变背景
                        gradient
                    } else {
                        // 普通背景
                        button.type.themeColor
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: button.shape.cornerRadius)
                    .stroke(button.plain ? button.type.themeColor : button.type.textColor, lineWidth: button.plain ? 1 : (button.hairline ? 1 : 0))
            )
            .cornerRadius(button.shape.cornerRadius)
            .opacity(button.disabled ? 0.5 : 1)
        }
        .disabled(button.disabled || button.loading)
    }
}

/// 按钮视图修饰器
public struct ButtonModifier: ViewModifier {
    @Binding var button: ButtonData?
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    if let button = button {
                        UIButton(button: button)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: button != nil)
            )
    }
}

/// 全局按钮视图修饰器
public struct ButtonViewModifier: ViewModifier {
    @ObservedObject private var buttonManager = ButtonManager.shared
    
    public func body(content: Content) -> some View {
        content
            .modifier(ButtonModifier(button: $buttonManager.currentButton))
    }
}

/// 扩展View以便使用按钮
public extension View {
    /// 在视图中添加按钮显示功能
    func withButton() -> some View {
        self.modifier(ButtonViewModifier())
    }
    
    /// 便捷方法：显示按钮
    func showButton(button: Binding<ButtonData?>) -> some View {
        self.modifier(ButtonModifier(button: button))
    }
}
