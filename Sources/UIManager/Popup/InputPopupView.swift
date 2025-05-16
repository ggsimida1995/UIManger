import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// 自定义文本输入框组件
public struct GroupsTextField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var submitLabel: SubmitLabel = .done
    var onSubmit: (() -> Void)? = nil
    @FocusState private var isFocused: Bool
    
    public var body: some View {
        VStack(spacing: 0) {
            // 输入框
            HStack {
                TextField(placeholder, text: $text)
                    .font(.system(size: 16))
                    .padding(.vertical, 10)
                    .background(Color.clear)
                    .keyboardType(keyboardType)
                    .submitLabel(submitLabel)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                    .focused($isFocused)
                    .onSubmit {
                        onSubmit?()
                    }
                
                // 清除按钮
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray.opacity(0.7))
                    }
                    .transition(.opacity)
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            
            // 底部红色线条
            Rectangle()
                .fill(Color.red)
                .frame(height: 1)
        }
        .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
    }
}

/// 自定义安全文本输入框组件
public struct GroupsSecureField: View {
    let placeholder: String
    @Binding var text: String
    var submitLabel: SubmitLabel = .done
    var onSubmit: (() -> Void)? = nil
    @FocusState private var isFocused: Bool
    
    public var body: some View {
        VStack(spacing: 0) {
            // 输入框
            HStack {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 16))
                    .padding(.vertical, 10)
                    .background(Color.clear)
                    .submitLabel(submitLabel)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                    .focused($isFocused)
                    .onSubmit {
                        onSubmit?()
                    }
                
                // 清除按钮
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray.opacity(0.7))
                    }
                    .transition(.opacity)
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            
            // 底部红色线条
            Rectangle()
                .fill(Color.red)
                .frame(height: 1)
        }
        .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
    }
}

/// 自定义多行文本输入框组件
public struct GroupsTextEditor: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    public var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                // 输入框
                TextEditor(text: $text)
                    .font(.system(size: 16))
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(.horizontal, 8)
                    .frame(height: 100)
                    .focused($isFocused)
                
                // 清除按钮
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray.opacity(0.7))
                            .padding(8)
                    }
                    .transition(.opacity)
                    .buttonStyle(.plain)
                }
            }
            
            // 底部红色线条
            Rectangle()
                .fill(Color.red)
                .frame(height: 1)
        }
        .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
    }
}

/// 输入字段类型
public enum InputFieldType {
    case text           // 普通文本
    case number         // 数字
    case email          // 邮箱
    case password       // 密码
    case multiline      // 多行文本
    
    // 获取对应的键盘类型
    var keyboardType: UIKeyboardType {
        switch self {
        case .text, .multiline:
            return .default
        case .number:
            return .numbersAndPunctuation
        case .email:
            return .emailAddress
        case .password:
            return .default
        }
    }
    
    // 是否是安全输入
    var isSecure: Bool {
        self == .password
    }
}

/// 输入字段配置
public struct InputField: Identifiable {
    /// 字段ID（内部使用）
    public let id: String
    /// 字段标签
    public let label: String
    /// 提示文本
    public let placeholder: String
    /// 键（用于结果字典的键）
    public let key: String
    /// 默认值
    public let defaultValue: String
    /// 是否必填
    public let isRequired: Bool
    /// 输入类型
    public let inputType: InputFieldType
    /// 验证器
    public let validator: ((String) -> (isValid: Bool, message: String?))?
    
    public init(
        id: String = UUID().uuidString,
        label: String,
        placeholder: String = "",
        key: String,
        defaultValue: String = "",
        isRequired: Bool = false,
        inputType: InputFieldType = .text,
        validator: ((String) -> (isValid: Bool, message: String?))? = nil
    ) {
        self.id = id
        self.label = label
        self.placeholder = placeholder
        self.key = key
        self.defaultValue = defaultValue
        self.isRequired = isRequired
        self.inputType = inputType
        self.validator = validator
    }
}

/// 输入框弹窗配置
public struct InputPopupConfig {
    /// 标题
    public var title: String?
    
    /// 输入字段
    public var fields: [InputField]
    
    /// 确认按钮文本
    public var confirmText: String?
    
    /// 取消按钮文本
    public var cancelText: String?
    
    /// 是否自动显示键盘
    public var autoShowKeyboard: Bool
    
    /// 是否显示验证提示
    public var showValidation: Bool
    
    /// 动画
    public var animation: Animation
    
    /// 外观配置
    public var appearance: InputPopupAppearance
    
    /// 初始化方法
    public init(
        title: String? = nil,
        fields: [InputField]? = nil,
        confirmText: String? = nil,
        cancelText: String? = nil,
        autoShowKeyboard: Bool = true,
        showValidation: Bool = true,
        animation: Animation = .spring(response: 0.3, dampingFraction: 0.8),
        appearance: InputPopupAppearance = InputPopupAppearance()
    ) {
        self.title = title ?? "请输入"
        self.fields = fields ?? [InputField(label: "内容", placeholder: "请输入内容", key: "value")]
        self.confirmText = confirmText ?? "确定"
        self.cancelText = cancelText ?? "取消"
        self.autoShowKeyboard = autoShowKeyboard
        self.showValidation = showValidation
        self.animation = animation
        self.appearance = appearance
    }
}

/// 输入框外观配置
public struct InputPopupAppearance {
    /// 背景颜色
    public var backgroundColor: Color
    
    /// 标题颜色
    public var titleColor: Color
    
    /// 标题字体
    public var titleFont: Font
    
    /// 输入框背景颜色
    public var fieldBackgroundColor: Color
    
    /// 输入框边框颜色
    public var fieldBorderColor: Color
    
    /// 输入框文本颜色
    public var fieldTextColor: Color
    
    /// 输入框字体
    public var fieldFont: Font
    
    /// 标签颜色
    public var labelColor: Color
    
    /// 标签字体
    public var labelFont: Font
    
    /// 确认按钮颜色
    public var confirmButtonColor: Color
    
    /// 取消按钮颜色
    public var cancelButtonColor: Color
    
    /// 初始化方法
    public init(
        backgroundColor: Color = .backgroundColor,
        titleColor: Color = .textColor,
        titleFont: Font = .headline,
        fieldBackgroundColor: Color = .secondaryBackgroundColor,
        fieldBorderColor: Color = .borderColor,
        fieldTextColor: Color = .textColor,
        fieldFont: Font = .body,
        labelColor: Color = .secondaryTextColor,
        labelFont: Font = .subheadline,
        confirmButtonColor: Color = .primaryButtonBackground,
        cancelButtonColor: Color = .secondaryButtonBackground
    ) {
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.fieldBackgroundColor = fieldBackgroundColor
        self.fieldBorderColor = fieldBorderColor
        self.fieldTextColor = fieldTextColor
        self.fieldFont = fieldFont
        self.labelColor = labelColor
        self.labelFont = labelFont
        self.confirmButtonColor = confirmButtonColor
        self.cancelButtonColor = cancelButtonColor
    }
}

/// 输入框弹窗视图
public struct InputPopupView: View {
    // 配置和回调
    private let config: InputPopupConfig
    private let onConfirm: ([String: String]) -> Void
    private let onCancel: () -> Void
    
    // 状态变量
    @State private var values: [String: String] = [:]
    @State private var validationErrors: [String: String] = [:]
    @State private var currentFocusField: String?
    @FocusState private var focusedField: String?
    
    public init(
        config: InputPopupConfig,
        onConfirm: @escaping ([String: String]) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.config = config
        self.onConfirm = onConfirm
        self.onCancel = onCancel
        
        // 初始化值
        var initialValues: [String: String] = [:]
        for field in config.fields {
            initialValues[field.id] = field.defaultValue
        }
        self._values = State(initialValue: initialValues)
    }
    
    public var body: some View {
        VStack(spacing: 10) {
            // 标题
            Text(config.title ?? "")
                .font(config.appearance.titleFont)
                .foregroundColor(config.appearance.titleColor)
                .padding(.bottom, 12)
            // 滚动区域，包含所有输入字段
            ScrollView{
                VStack(spacing: 12) {
                    ForEach(config.fields) { field in
                        inputField(for: field)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            // 按钮区域
            HStack(spacing: 12) {
                // 取消按钮
                Button {
                    onCancel()
                } label: {
                    Text(config.cancelText ?? "取消")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(config.appearance.cancelButtonColor)
                        .cornerRadius(8)
                        .foregroundColor(.secondaryButtonText)
                }
                
                // 确认按钮
                Button {
                    submitForm()
                } label: {
                    Text(config.confirmText ?? "确定")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(config.appearance.confirmButtonColor)
                        .cornerRadius(8)
                        .foregroundColor(.primaryButtonText)
                }
            }
            .padding(.horizontal, 16)
        }
        .fixedSize(horizontal: false, vertical: false)  // 不固定水平方向，使用外部容器宽度
        .onChange(of: focusedField) { newValue in
            currentFocusField = newValue
        }
        .onAppear {
            if config.autoShowKeyboard, let firstField = config.fields.first {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    focusedField = firstField.id
                }
            }
        }
    }
    
    // 创建输入字段视图
    @ViewBuilder
    private func inputField(for field: InputField) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            // 标签
            if !field.label.isEmpty {
                Text(field.label)
                    .font(config.appearance.labelFont)
                    .foregroundColor(config.appearance.labelColor)
            }
            
            // 根据类型选择不同的输入控件
            switch field.inputType {
            case .multiline:
                multilineTextField(for: field)
            case .password:
                secureTextField(for: field)
            default:
                standardTextField(for: field)
            }
            
            // 验证错误信息
            if config.showValidation, let error = validationErrors[field.id], !error.isEmpty {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 2)
            }
        }
    }
    
    // 标准文本输入框
    private func standardTextField(for field: InputField) -> some View {
        GroupsTextField(
            placeholder: field.placeholder,
            text: binding(for: field.id),
            keyboardType: field.inputType.keyboardType,
            submitLabel: nextSubmitLabel(for: field),
            onSubmit: { moveToNextField(after: field) }
        )
        .foregroundColor(config.appearance.fieldTextColor)
        .focused($focusedField, equals: field.id)
        .onChange(of: values[field.id] ?? "") { newValue in
            validateField(field, value: newValue)
        }
    }
    
    // 密码输入框
    private func secureTextField(for field: InputField) -> some View {
        GroupsSecureField(
            placeholder: field.placeholder, 
            text: binding(for: field.id),
            submitLabel: nextSubmitLabel(for: field),
            onSubmit: { moveToNextField(after: field) }
        )
        .foregroundColor(config.appearance.fieldTextColor)
        .focused($focusedField, equals: field.id)
        .onChange(of: values[field.id] ?? "") { newValue in
            validateField(field, value: newValue)
        }
    }
    
    // 多行文本输入框
    private func multilineTextField(for field: InputField) -> some View {
        GroupsTextEditor(text: binding(for: field.id))
            .foregroundColor(config.appearance.fieldTextColor)
            .focused($focusedField, equals: field.id)
            .onChange(of: values[field.id] ?? "") { newValue in
                validateField(field, value: newValue)
            }
    }
    
    // 创建绑定
    private func binding(for id: String) -> Binding<String> {
        Binding(
            get: { values[id] ?? "" },
            set: { values[id] = $0 }
        )
    }
    
    // 获取下一个提交按钮的标签
    private func nextSubmitLabel(for field: InputField) -> SubmitLabel {
        if let index = config.fields.firstIndex(where: { $0.id == field.id }),
           index < config.fields.count - 1 {
            return .next
        } else {
            return .done
        }
    }
    
    // 焦点移动到下一个字段
    private func moveToNextField(after field: InputField) {
        if let index = config.fields.firstIndex(where: { $0.id == field.id }) {
            if index < config.fields.count - 1 {
                // 移动到下一个字段
                let nextField = config.fields[index + 1]
                focusedField = nextField.id
            } else {
                // 是最后一个字段，提交表单
                submitForm()
            }
        }
    }
    
    // 验证字段
    private func validateField(_ field: InputField, value: String) {
        var error = ""
        
        // 检查必填
        if field.isRequired && value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            error = "此项不能为空"
        } 
        // 自定义验证
        else if let validator = field.validator, !validator(value).isValid {
            error = validator(value).message ?? "输入格式不正确"
        }
        
        // 更新验证错误
        validationErrors[field.id] = error
    }
    
    // 检查所有字段是否有效
    private func isFormValid() -> Bool {
        var allValid = true
        
        for field in config.fields {
            validateField(field, value: values[field.id] ?? "")
            if let error = validationErrors[field.id], !error.isEmpty {
                allValid = false
            }
        }
        
        return allValid
    }
    
    // 提交表单
    private func submitForm() {
        // 移除键盘焦点
        focusedField = nil
        
        // 验证表单
        if !isFormValid() {
            // 表单无效，不提交
            return
        }
        
        // 准备数据
        var result: [String: String] = [:]
        for field in config.fields {
            // 使用key作为标识符
            result[field.key] = values[field.id] ?? field.defaultValue
        }
        
        // 提交
        onConfirm(result)
    }
}

// MARK: - 扩展 View 添加输入框弹窗方法
public extension View {
    /// 显示输入框弹窗 - 单字段便捷方法
    func showInputPopup(
        title: String? = nil,
        field: InputField? = nil,
        key: String? = nil,
        confirmText: String? = nil,
        cancelText: String? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        onConfirm: @escaping (String) -> Void = { _ in },
        onCancel: @escaping () -> Void = {}
    ) {
        // 创建默认字段
        let defaultField = field ?? InputField(
            label: "内容", 
            placeholder: "请输入内容",
            key: key ?? "value"
        )
        
        let config = InputPopupConfig(
            title: title,
            fields: [defaultField],
            confirmText: confirmText,
            cancelText: cancelText
        )
        
        showInputPopup(config: config, width: width, height: height) { result in
            // 使用key作为标识符
            let identifier = defaultField.key
            if let value = result[identifier] {
                onConfirm(value)
            } else {
                onConfirm("")
            }
        } onCancel: {
            onCancel()
        }
    }
    
    /// 显示输入框弹窗 - 完整方法
    func showInputPopup(
        config: InputPopupConfig,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        onConfirm: @escaping ([String: String]) -> Void = { _ in },
        onCancel: @escaping () -> Void = {}
    ) {
        // 配置弹窗
        var popupConfig = PopupConfig(
            cornerRadius: 15,
            shadowEnabled: false,
            closeOnTapOutside: true
        )
        
        // 设置默认的过渡效果
        popupConfig.customTransition = AnyTransition.scale(scale: 1.05)
            .combined(with: .opacity)
        
        // 创建弹窗ID
        let popupId = UUID()
        
        // 创建弹窗内容
        let content = {
            InputPopupView(
                config: config,
                onConfirm: { values in
                    onConfirm(values)
                    withAnimation(config.animation) {
                        PopupManager.shared.closePopup(id: popupId)
                    }
                },
                onCancel: {
                    onCancel()
                    withAnimation(config.animation) {
                        PopupManager.shared.closePopup(id: popupId)
                    }
                }
            )
        }
        
        // 使用动画显示弹窗
        withAnimation(config.animation) {
            PopupManager.shared.show(
                content: content,
                position: .center,
                width: width ?? 350,  // 默认宽度350
                height: height ?? 220,  // 默认高度220
                config: popupConfig,
                id: popupId
            )
        }
    }
}

