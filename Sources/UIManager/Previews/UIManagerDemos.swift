#if canImport(UIKit)
import SwiftUI

/// UIManager 组件预览集合入口点
public struct UIManagerDemos: View {
    @StateObject private var themeManager = UIManagerThemeViewModel()
    
    public init() {
        // 确保只初始化一次
//        if PopupManager.shared.activePopups.isEmpty {
//            UIManager.initialize()
//        }
    }
    
    public var body: some View {
        PreviewPopupDemo()
            .environmentObject(themeManager)
            .environmentObject(PopupManager.shared)
            .environmentObject(ToastManager.shared)
            .withUIComponents()
    }
    
    /// 导航包装器
    struct NavWrapper<Content: View>: View {
        let title: String
        let content: Content
        
        init(title: String, @ViewBuilder content: () -> Content) {
            self.title = title
            self.content = content()
        }
        
        var body: some View {
            NavigationView {
                content
                    .navigationTitle(title)
            }
        }
    }
    
    // 内部ThemeViewModel实现
    public class UIManagerThemeViewModel: ObservableObject {
        @Published public var isDarkMode: Bool = false
        
        // 主题色
        public var themeColor: Color {
            Color.blue
        }
        
        // 背景色
        public var backgroundColor: Color {
            isDarkMode ? Color.black : Color(UIColor.systemGray6)
        }
        
        // 主要文本色
        public var primaryTextColor: Color {
            isDarkMode ? Color.white : Color.black
        }
        
        // 次要文本色
        public var secondaryTextColor: Color {
            isDarkMode ? Color.gray : Color.gray
        }
        
        // 切换暗黑模式
        public func toggleDarkMode() {
            isDarkMode.toggle()
        }
    }
    
    // 预览用的简化版 PopupDemoView
    struct PreviewPopupDemo: View {
        @EnvironmentObject private var themeManager: UIManagerThemeViewModel
        @EnvironmentObject private var popupManager: PopupManager
        @EnvironmentObject private var toastManager: ToastManager
        
        @State private var inputValue = ""
        @State private var customInputValue = ""
        @State private var multiLineText = ""
        @State private var pickerSelection = 0
        @State private var showOptions = false
        @FocusState private var focusedField: FocusField?
        
        // 防止重复调用的标志
        @State private var isProcessing = false
        
        enum FocusField {
            case standard, custom, multiLine
        }
        
        var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Popup 组件演示")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.primaryTextColor)
                        .padding(.vertical, 10)
                    
                    Group {
                        // 基础弹窗
                        sectionTitle("基础弹窗")
                        demoButton(title: "居中弹窗", action: showBasicPopup)
                        demoButton(title: "居中弹窗 + 关闭按钮", action: showBasicPopupWithCloseButton)
                        
                        // 输入弹窗
                        sectionTitle("输入弹窗")
                        demoButton(title: "标准输入弹窗", action: showInputPopup)
                        demoButton(title: "输入弹窗 + 关闭按钮", action: showInputPopupWithCloseButton)
                        
                        // 键盘管理弹窗
                        sectionTitle("键盘管理弹窗")
                        demoButton(title: "内置输入弹窗", action: showKeyboardPopup)
                        demoButton(title: "自定义输入弹窗", action: showCustomKeyboardPopup)
                        demoButton(title: "多字段表单弹窗", action: showMultiFieldFormPopup)
                        demoButton(title: "传统扩展方式弹窗", action: showExtensionKeyboardPopup)
                        
                        // 警告和成功弹窗
                        sectionTitle("提示弹窗")
                        demoButton(title: "警告弹窗", action: showAlertPopup)
                        demoButton(title: "成功弹窗", action: showSuccessPopup)
                        
                        // 位置弹窗
                        sectionTitle("位置弹窗")
                        demoButton(title: "顶部弹窗", action: showTopPopup)
                        demoButton(title: "底部弹窗", action: showBottomPopup)
                        demoButton(title: "右侧弹窗", action: showRightPopup)
                        demoButton(title: "左侧弹窗", action: showLeftPopup)
                        
                        // 特殊弹窗
                        sectionTitle("特殊弹窗")
                        demoButton(title: "底部菜单", action: showActionSheet)
                        demoButton(title: "侧边栏菜单", action: showSidebar)
                        demoButton(title: "自定义尺寸弹窗", action: showCustomSizePopup)
                        demoButton(title: "无背景弹窗", action: showNoBackgroundPopup)
                        
                        // Toast提示
                        sectionTitle("Toast 提示")
                        demoButton(title: "普通提示", action: showToast)
                        demoButton(title: "成功提示", action: showSuccessToast)
                        demoButton(title: "错误提示", action: showErrorToast)
                    }
                    
                    if !inputValue.isEmpty {
                        Text("输入的值: \(inputValue)")
                            .padding()
                            .background(themeManager.backgroundColor.opacity(0.8))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .padding(.top, 20)
                    }
                    
                    if !customInputValue.isEmpty {
                        Text("自定义输入: \(customInputValue)")
                            .padding()
                            .background(themeManager.backgroundColor.opacity(0.8))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    if !multiLineText.isEmpty {
                        Text("多行文本: \(multiLineText)")
                            .padding()
                            .background(themeManager.backgroundColor.opacity(0.8))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    Spacer().frame(height: 30)
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .background(themeManager.backgroundColor)
            // .navigationTitle("Popup 演示")
        }
        
        // 章节标题
        private func sectionTitle(_ title: String) -> some View {
            Text(title)
                .font(.headline)
                .foregroundColor(themeManager.primaryTextColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 15)
                .padding(.bottom, 5)
        }
        
        // 样式化的按钮
        private func demoButton(title: String, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(themeManager.themeColor)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        
        // 基础弹窗
        private func showBasicPopup() {
            guard !isProcessing else { return }
            isProcessing = true
            
            popupManager.show {
                VStack(spacing: 16) {
                    Text("基础弹窗")
                        .font(.headline)
                        .foregroundColor(themeManager.primaryTextColor)
                    
                    Text("这是一个基础弹窗示例，可以显示任意内容。")
                        .font(.subheadline)
                        .foregroundColor(themeManager.secondaryTextColor)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        popupManager.closeAllPopups()
                        isProcessing = false
                    }) {
                        Text("关闭")
                            .frame(width: 100, height: 40)
                            .background(themeManager.themeColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
        
        // 带关闭按钮的基础弹窗
        private func showBasicPopupWithCloseButton() {
            guard !isProcessing else { return }
            isProcessing = true
            
            let config = PopupBaseConfig(
                showCloseButton: true,
                closeButtonPosition: .topTrailing,
                onClose: {
                    isProcessing = false
                }
            )
            
            popupManager.show(
                content: {
                    VStack(spacing: 16) {
                        Text("带关闭按钮的弹窗")
                            .font(.headline)
                            .foregroundColor(themeManager.primaryTextColor)
                        
                        Text("这个弹窗在右上角有一个关闭按钮，点击即可关闭弹窗。")
                            .font(.subheadline)
                            .foregroundColor(themeManager.secondaryTextColor)
                            .multilineTextAlignment(.center)
                        
                        Text("也可以点击外部区域关闭弹窗。")
                            .font(.caption)
                            .foregroundColor(themeManager.secondaryTextColor)
                            .padding(.top, 8)
                    }
                    .padding()
                },
                config: config
            )
        }
        
        // 输入弹窗
        private func showInputPopup() {
            guard !isProcessing else { return }
            isProcessing = true
            
            popupManager.show(
                content: {
                    VStack(spacing: 16) {
                        Text("请输入内容")
                            .font(.headline)
                            .foregroundColor(themeManager.primaryTextColor)
                        
                        Text("这是一个输入弹窗示例，用于获取用户输入。")
                            .font(.subheadline)
                            .foregroundColor(themeManager.secondaryTextColor)
                            .multilineTextAlignment(.center)
                        
                        TextField("请输入...", text: .constant(""))
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        
                        HStack {
                            Button("取消") {
                                popupManager.closeAllPopups()
                                isProcessing = false
                                toastManager.showToast(message: "取消输入")
                            }
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(themeManager.primaryTextColor)
                            .cornerRadius(8)
                            
                            Button("确定") {
                                popupManager.closeAllPopups()
                                isProcessing = false
                                inputValue = "示例输入值"
                                toastManager.showSuccess(message: "输入成功")
                            }
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .background(themeManager.themeColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                }
            )
        }
        
        // 带关闭按钮的输入弹窗
        private func showInputPopupWithCloseButton() {
            let config = PopupBaseConfig(
                showCloseButton: true
            )
            
            popupManager.show(
                content: {
                    VStack(spacing: 16) {
                        Text("请输入内容")
                            .font(.headline)
                            .foregroundColor(themeManager.primaryTextColor)
                        
                        Text("这是一个带关闭按钮的输入弹窗示例。")
                            .font(.subheadline)
                            .foregroundColor(themeManager.secondaryTextColor)
                            .multilineTextAlignment(.center)
                        
                        TextField("请输入...", text: .constant(""))
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        
                        HStack {
                            Button("取消") {
                                popupManager.closeAllPopups()
                                toastManager.showToast(message: "取消输入")
                            }
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(themeManager.primaryTextColor)
                            .cornerRadius(8)
                            
                            Button("确定") {
                                popupManager.closeAllPopups()
                                inputValue = "示例输入值"
                                toastManager.showSuccess(message: "输入成功")
                            }
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .background(themeManager.themeColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                },
                config: config
            )
        }
        
        // 内置键盘管理弹窗
        private func showKeyboardPopup() {
            popupManager.showStandardInput(
                title: "内置输入弹窗",
                message: "这是使用内置API的输入弹窗，支持键盘自适应",
                placeholder: "请输入内容...",
                initialText: "",
                keyboardType: .default,
                submitLabel: .done,
                onCancel: {
                    toastManager.showToast(message: "取消输入")
                },
                onSubmit: { text in
                    if text.isEmpty {
                        toastManager.showError(message: "输入内容不能为空")
                    } else {
                        inputValue = text
                        toastManager.showSuccess(message: "输入成功: \(text)")
                    }
                }
            )
        }
        
        // 自定义键盘管理弹窗
        private func showCustomKeyboardPopup() {
            popupManager.showInput { keyboardObserver in
                VStack(spacing: 16) {
                    Text("自定义输入弹窗")
                        .font(.headline)
                        .foregroundColor(themeManager.primaryTextColor)
                    
                    Text("这是一个带键盘管理的自定义输入弹窗")
                        .font(.subheadline)
                        .foregroundColor(themeManager.secondaryTextColor)
                        .multilineTextAlignment(.center)
                    
                    TextField("请输入内容...", text: $customInputValue)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .focused($focusedField, equals: .custom)
                    
                    // 显示键盘高度
                    Text("键盘高度: \(Int(keyboardObserver.keyboardHeight))")
                        .font(.caption)
                        .foregroundColor(themeManager.secondaryTextColor)
                    
                    Picker("选择类型", selection: $pickerSelection) {
                        Text("选项1").tag(0)
                        Text("选项2").tag(1)
                        Text("选项3").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(.vertical, 8)
                    
                    HStack {
                        Button("取消") {
                            keyboardObserver.hideKeyboard()
                            popupManager.closeAllPopups()
                            toastManager.showToast(message: "取消自定义输入")
                        }
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(themeManager.primaryTextColor)
                        .cornerRadius(8)
                        
                        Button("确定") {
                            keyboardObserver.hideKeyboard()
                            popupManager.closeAllPopups()
                            toastManager.showSuccess(message: "自定义输入: \(customInputValue)")
                        }
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .background(themeManager.themeColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        focusedField = .custom
                    }
                }
            }
        }
        
        // 多字段表单弹窗
        private func showMultiFieldFormPopup() {
            @State var name = ""
            @State var email = ""
            @State var description = ""
            @FocusState var focusedFormField: FormField?
            
            enum FormField {
                case name, email, description
            }
            
            popupManager.showInput { keyboardObserver in
                VStack(spacing: 16) {
                    Text("多字段表单")
                        .font(.headline)
                        .foregroundColor(themeManager.primaryTextColor)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            TextField("姓名", text: $name)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .focused($focusedFormField, equals: .name)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedFormField = .email
                                }
                            
                            TextField("邮箱", text: $email)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .focused($focusedFormField, equals: .email)
                                .keyboardType(.emailAddress)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedFormField = .description
                                }
                            
                            TextEditor(text: $description)
                                .padding(8)
                                .frame(height: 100)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .focused($focusedFormField, equals: .description)
                        }
                    }
                    
                    HStack {
                        Button("取消") {
                            keyboardObserver.hideKeyboard()
                            popupManager.closeAllPopups()
                            toastManager.showToast(message: "取消多字段表单")
                        }
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(themeManager.primaryTextColor)
                        .cornerRadius(8)
                        
                        Button("提交") {
                            keyboardObserver.hideKeyboard()
                            popupManager.closeAllPopups()
                            multiLineText = description
                            toastManager.showSuccess(message: "表单已提交")
                        }
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .background(themeManager.themeColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        focusedFormField = .name
                    }
                }
            }
        }
        
        // 传统扩展方式弹窗
        private func showExtensionKeyboardPopup() {
            self.uiPopup {
                VStack(spacing: 16) {
                    Text("传统方式弹窗")
                        .font(.headline)
                        .foregroundColor(themeManager.primaryTextColor)
                    
                    Text("这个弹窗使用View扩展方法uiPopup实现")
                        .font(.subheadline)
                        .foregroundColor(themeManager.secondaryTextColor)
                        .multilineTextAlignment(.center)
                    
                    TextField("输入内容", text: $inputValue)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .focused($focusedField, equals: .standard)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                focusedField = .standard
                            }
                        }
                    
                    HStack {
                        Button("取消") {
                            // 手动隐藏键盘
                            UIApplication.shared.sendAction(
                                #selector(UIResponder.resignFirstResponder),
                                to: nil, from: nil, for: nil
                            )
                            
                            // 延迟关闭弹窗，让键盘有时间收起
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.uiCloseAllPopups()
                                toastManager.showToast(message: "取消传统弹窗")
                            }
                        }
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(themeManager.primaryTextColor)
                        .cornerRadius(8)
                        
                        Button("确定") {
                            // 手动隐藏键盘
                            UIApplication.shared.sendAction(
                                #selector(UIResponder.resignFirstResponder),
                                to: nil, from: nil, for: nil
                            )
                            
                            // 延迟关闭弹窗，让键盘有时间收起
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.uiCloseAllPopups()
                                toastManager.showSuccess(message: "传统弹窗输入: \(inputValue)")
                            }
                        }
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .background(themeManager.themeColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
        
        // 警告弹窗
        private func showAlertPopup() {
            popupManager.show {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    
                    Text("警告")
                        .font(.headline)
                        .foregroundColor(themeManager.primaryTextColor)
                    
                    Text("这是一个警告弹窗示例，用于提示用户确认重要操作。")
                        .font(.subheadline)
                        .foregroundColor(themeManager.secondaryTextColor)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Button("取消") {
                            popupManager.closeAllPopups()
                            toastManager.showToast(message: "操作已取消")
                        }
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(themeManager.primaryTextColor)
                        .cornerRadius(8)
                        
                        Button("确定") {
                            popupManager.closeAllPopups()
                            toastManager.showSuccess(message: "操作已确认")
                        }
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(themeManager.themeColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
        
        // 成功弹窗
        private func showSuccessPopup() {
            popupManager.show {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                    
                    Text("操作成功")
                        .font(.headline)
                        .foregroundColor(themeManager.primaryTextColor)
                    
                    Text("这是一个成功弹窗示例，用于通知用户操作已成功完成。")
                        .font(.subheadline)
                        .foregroundColor(themeManager.secondaryTextColor)
                        .multilineTextAlignment(.center)
                    
                    Button("确定") {
                        popupManager.closeAllPopups()
                        toastManager.showToast(message: "关闭成功弹窗")
                    }
                    .frame(width: 120, height: 40)
                    .background(themeManager.themeColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            }
        }
        
        // 顶部弹窗
        private func showTopPopup() {
            let config = PopupBaseConfig(
                backgroundColor: .blue,
                cornerRadius: 16,
                showCloseButton: true
            )
            
            popupManager.show(
                content: {
                    VStack {
                        Text("顶部弹窗")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("这是一个显示在顶部的弹窗")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Button("关闭") {
                            popupManager.closeAllPopups()
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(20)
                        .padding(.top, 8)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                },
                position: .top,
                size: .fullWidth(nil),
                config: config
            )
        }
        
        // 底部弹窗
        private func showBottomPopup() {
            let config = PopupBaseConfig(
                backgroundColor: themeManager.backgroundColor,
                cornerRadius: 16
            )
            
            popupManager.show(
                content: {
                    VStack(spacing: 12) {
                        // 拖动条
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 40, height: 4)
                            .padding(.top, 8)
                            .padding(.bottom, 16)
                        
                        Text("底部弹窗")
                            .font(.headline)
                            .foregroundColor(themeManager.primaryTextColor)
                        
                        Text("这是一个从底部弹出的视图，常用于展示附加信息或菜单。")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(themeManager.secondaryTextColor)
                            .padding(.vertical, 8)
                        
                        Button("关闭") {
                            popupManager.closeAllPopups()
                        }
                        .frame(width: 120, height: 40)
                        .background(themeManager.themeColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 8)
                        .padding(.bottom, 16)
                    }
                    .padding()
                },
                position: .bottom,
                size: .fullWidth(nil),
                config: config
            )
        }
        
        // 右侧弹窗
        private func showRightPopup() {
            let config = PopupBaseConfig(
                backgroundColor: themeManager.backgroundColor,
                cornerRadius: 0,
                showCloseButton: true,
                closeButtonPosition: .topLeading
            )
            
            popupManager.show(
                content: {
                    VStack(spacing: 16) {
                        Text("右侧弹窗")
                            .font(.headline)
                            .foregroundColor(themeManager.primaryTextColor)
                        
                        Text("这是一个从右侧弹出的视图，可用于临时操作区域。")
                            .font(.body)
                            .foregroundColor(themeManager.secondaryTextColor)
                            .multilineTextAlignment(.center)
                        
                        Button("关闭") {
                            popupManager.closeAllPopups()
                        }
                        .frame(width: 100, height: 40)
                        .background(themeManager.themeColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 16)
                    }
                    .padding()
                    .frame(maxHeight: .infinity)
                },
                position: .right,
                size: .fullHeight(200),
                config: config
            )
        }
        
        // 左侧弹窗
        private func showLeftPopup() {
            let config = PopupBaseConfig(
                backgroundColor: themeManager.backgroundColor,
                cornerRadius: 0,
                showCloseButton: true,
                closeButtonPosition: .topTrailing
            )
            
            popupManager.show(
                content: {
                    VStack(spacing: 16) {
                        Text("左侧弹窗")
                            .font(.headline)
                            .foregroundColor(themeManager.primaryTextColor)
                        
                        Text("这是一个从左侧弹出的视图，常用于导航菜单。")
                            .font(.body)
                            .foregroundColor(themeManager.secondaryTextColor)
                            .multilineTextAlignment(.center)
                        
                        Button("关闭") {
                            popupManager.closeAllPopups()
                        }
                        .frame(width: 100, height: 40)
                        .background(themeManager.themeColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 16)
                    }
                    .padding()
                    .frame(maxHeight: .infinity)
                },
                position: .left,
                size: .fullHeight(200),
                config: config
            )
        }
        
        // 侧边栏菜单
        private func showSidebar() {
            let config = PopupBaseConfig(
                backgroundColor: themeManager.backgroundColor,
                cornerRadius: 0
            )
            
            popupManager.show(
                content: {
                    VStack(spacing: 0) {
                        // 顶部区域
                        VStack(spacing: 10) {
                            Text("菜单")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(themeManager.primaryTextColor)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        
                        Divider()
                        
                        // 菜单项
                        menuItem(title: "首页", icon: "house", isSelected: true) {
                            popupManager.closeAllPopups()
                            toastManager.showToast(message: "选择了: 首页")
                        }
                        
                        menuItem(title: "收藏", icon: "star", isSelected: false) {
                            popupManager.closeAllPopups()
                            toastManager.showToast(message: "选择了: 收藏")
                        }
                        
                        menuItem(title: "历史记录", icon: "clock", isSelected: false) {
                            popupManager.closeAllPopups()
                            toastManager.showToast(message: "选择了: 历史记录")
                        }
                        
                        menuItem(title: "设置", icon: "gear", isSelected: false) {
                            popupManager.closeAllPopups()
                            toastManager.showToast(message: "选择了: 设置")
                        }
                        
                        menuItem(title: "关于我们", icon: "info.circle", isSelected: false) {
                            popupManager.closeAllPopups()
                            toastManager.showToast(message: "选择了: 关于我们")
                        }
                        
                        Spacer()
                        
                        Divider()
                        
                        // 底部关闭按钮
                        Button {
                            popupManager.closeAllPopups()
                        } label: {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                Text("关闭菜单")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(themeManager.themeColor)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .background(themeManager.backgroundColor)
                },
                position: .right,
                size: .fullHeight(250),
                config: config
            )
        }
        
        // 菜单项
        private func menuItem(title: String, icon: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .frame(width: 24)
                    
                    Text(title)
                        .font(.body)
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14))
                            .foregroundColor(themeManager.themeColor)
                    }
                }
                .contentShape(Rectangle())
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(isSelected ? themeManager.themeColor.opacity(0.1) : Color.clear)
                .foregroundColor(isSelected ? themeManager.themeColor : themeManager.primaryTextColor)
            }
        }
        
        // 自定义尺寸弹窗
        private func showCustomSizePopup() {
            let config = PopupBaseConfig(
                backgroundColor: themeManager.backgroundColor,
                showCloseButton: true
            )
            
            popupManager.show(
                content: {
                    VStack {
                        Text("自定义尺寸弹窗")
                            .font(.headline)
                            .foregroundColor(themeManager.primaryTextColor)
                        
                        Text("这个弹窗使用了自定义尺寸")
                            .font(.subheadline)
                            .foregroundColor(themeManager.secondaryTextColor)
                        
                        Button("关闭") {
                            popupManager.closeAllPopups()
                        }
                        .padding(8)
                        .background(themeManager.themeColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 8)
                    }
                    .padding()
                },
                size: .fixed(CGSize(width: 200, height: 160)),
                config: config
            )
        }
        
        // 底部菜单
        private func showActionSheet() {
            let config = PopupBaseConfig(
                backgroundColor: themeManager.backgroundColor,
                cornerRadius: 16
            )
            
            popupManager.show(
                content: {
                    VStack(spacing: 0) {
                        VStack(spacing: 12) {
                            Text("选择操作")
                                .font(.headline)
                                .foregroundColor(themeManager.primaryTextColor)
                            
                            Text("请选择以下操作之一")
                                .font(.subheadline)
                                .foregroundColor(themeManager.secondaryTextColor)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        
                        Divider()
                        
                        // 选项
                        Button {
                            popupManager.closeAllPopups()
                            toastManager.showToast(message: "选择了拍照")
                        } label: {
                            HStack {
                                Image(systemName: "camera")
                                    .foregroundColor(themeManager.themeColor)
                                    .frame(width: 30)
                                
                                Text("拍照")
                                    .foregroundColor(themeManager.primaryTextColor)
                                
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .padding(.horizontal)
                        }
                        
                        Divider()
                        
                        Button {
                            popupManager.closeAllPopups()
                            toastManager.showToast(message: "选择了从相册选择")
                        } label: {
                            HStack {
                                Image(systemName: "photo")
                                    .foregroundColor(themeManager.themeColor)
                                    .frame(width: 30)
                                
                                Text("从相册选择")
                                    .foregroundColor(themeManager.primaryTextColor)
                                
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .padding(.horizontal)
                        }
                        
                        Divider()
                        
                        Button {
                            popupManager.closeAllPopups()
                            toastManager.showError(message: "选择了删除操作")
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .frame(width: 30)
                                
                                Text("删除")
                                    .foregroundColor(.red)
                                
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .padding(.horizontal)
                        }
                        
                        Divider()
                        
                        // 取消按钮
                        Button {
                            popupManager.closeAllPopups()
                        } label: {
                            Text("取消")
                                .font(.headline)
                                .foregroundColor(themeManager.themeColor)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        }
                    }
                    .background(themeManager.backgroundColor)
                },
                position: .bottom,
                size: .fullWidth(nil),
                config: config
            )
        }
        
        // 无背景弹窗
        private func showNoBackgroundPopup() {
            let config = PopupBaseConfig(
                closeOnTapOutside: true,
                onClose: {
                    // 在关闭后执行操作
                }
            )
            
            popupManager.show(
                content: {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(40)
                        .shadow(radius: 10)
                },
                config: config
            )
        }
        
        // 显示普通Toast
        private func showToast() {
            guard !isProcessing else { return }
            isProcessing = true
            
            toastManager.showToast(message: "这是一条普通提示信息")
            
            // Toast显示后重置状态
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isProcessing = false
            }
        }
        
        // 显示成功Toast
        private func showSuccessToast() {
            toastManager.showSuccess(message: "操作成功")
        }
        
        // 显示错误Toast
        private func showErrorToast() {
            toastManager.showError(message: "发生错误")
        }
    }
}

// MARK: - 预览
#Preview {
    UIManagerDemos()
        .environment(\.popupManager, PopupManager.shared) // 确保预览使用相同的实例
}
#endif
