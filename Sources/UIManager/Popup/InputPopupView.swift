import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// 输入框弹窗配置
public struct InputPopupConfig {
    /// 标题
    public var title: String
    
    /// 占位符文本
    public var placeholder: String
    
    /// 确认按钮文本
    public var confirmText: String
    
    /// 取消按钮文本
    public var cancelText: String
    
    /// 是否自动显示键盘
    public var autoShowKeyboard: Bool
    
    /// 键盘类型
    public var keyboardType: UIKeyboardType
    
    /// 输入框配置
    public var textFieldConfig: TextFieldConfig
    
    /// 初始化方法
    public init(
        title: String = "请输入",
        placeholder: String = "请输入内容",
        confirmText: String = "确定",
        cancelText: String = "取消",
        autoShowKeyboard: Bool = true,
        keyboardType: UIKeyboardType = .default,
        textFieldConfig: TextFieldConfig = TextFieldConfig()
    ) {
        self.title = title
        self.placeholder = placeholder
        self.confirmText = confirmText
        self.cancelText = cancelText
        self.autoShowKeyboard = autoShowKeyboard
        self.keyboardType = keyboardType
        self.textFieldConfig = textFieldConfig
    }
}

/// 输入框配置
public struct TextFieldConfig {
    /// 文本颜色
    public var textColor: Color
    
    /// 字体
    public var font: Font
    
    /// 文本对齐方式
    public var textAlignment: TextAlignment
    
    /// 是否自动校正
    public var autocorrection: Bool
    
    /// 是否自动大写
    public var autocapitalization: TextInputAutocapitalization
    
    /// 初始化方法
    public init(
        textColor: Color = .primary,
        font: Font = .body,
        textAlignment: TextAlignment = .leading,
        autocorrection: Bool = true,
        autocapitalization: TextInputAutocapitalization = .sentences
    ) {
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.autocorrection = autocorrection
        self.autocapitalization = autocapitalization
    }
}

/// 输入框弹窗视图
public struct InputPopupView: View {
    @State private var text: String = ""
    @State private var isFirstResponder: Bool = false
    @FocusState private var isFocused: Bool
    
    let config: InputPopupConfig
    let onConfirm: (String) -> Void
    let onCancel: () -> Void
    
    public init(
        config: InputPopupConfig = InputPopupConfig(),
        onConfirm: @escaping (String) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.config = config
        self.onConfirm = onConfirm
        self.onCancel = onCancel
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            // 标题
            Text(config.title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            // 输入框容器
            VStack(spacing: 4) {
                // 输入框和清除按钮
                HStack {
                    TextField(config.placeholder, text: $text)
                        .font(config.textFieldConfig.font)
                        .foregroundColor(config.textFieldConfig.textColor)
                        .multilineTextAlignment(.leading)
                        .autocorrectionDisabled(!config.textFieldConfig.autocorrection)
                        .textInputAutocapitalization(config.textFieldConfig.autocapitalization)
                        .keyboardType(config.keyboardType)
                        .focused($isFocused)
                        .submitLabel(.done)
                    
                    // 清除按钮
                    if !text.isEmpty {
                        Button(action: {
                            text = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 4)
                        }
                    }
                }
                
                // 底部红色线条
                Rectangle()
                    .fill(Color.red)
                    .frame(height: 1)
            }
            Spacer()
            // 按钮组
            HStack(spacing: 16) {
                // 取消按钮
                Button(action: {
                    onCancel()
                }) {
                    Text(config.cancelText)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                
                // 确认按钮
                Button(action: {
                    onConfirm(text)
                }) {
                    Text(config.confirmText)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .onAppear {
            if config.autoShowKeyboard {
                isFocused = true
            }
        }
    }
}

// MARK: - 扩展 View 添加输入框弹窗方法
public extension View {
    /// 显示输入框弹窗
    func showInputPopup(
        config: InputPopupConfig = InputPopupConfig(),
        onConfirm: @escaping (String) -> Void,
        onCancel: @escaping () -> Void = {}
    ) {
        let popup = PopupData(
            content: InputPopupView(
                config: config,
                onConfirm: { text in
                    onConfirm(text)
                    PopupManager.shared.closePopup(id: popup.id)
                },
                onCancel: {
                    onCancel()
                    PopupManager.shared.closePopup(id: popup.id)
                }
            ),
            position: .center,
            size: .fixed(CGSize(width: 300, height: 200)),
            config: PopupConfig(
                backgroundColor: .clear,
                cornerRadius: 12,
                shadowEnabled: true,
                closeOnTapOutside: true
            )
        )
        
        PopupManager.shared.showPopup(popup)
    }
}

