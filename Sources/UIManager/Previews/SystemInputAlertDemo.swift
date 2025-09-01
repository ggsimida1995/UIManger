import SwiftUI

/// iOS 系统原生弹窗输入框演示
public struct SystemInputAlertDemo: View {
    @State private var showSimpleAlert = false
    @State private var showMultiFieldAlert = false
    @State private var showSecureAlert = false
    @State private var showValidationAlert = false
    @State private var showSheetForm = false
    
    @State private var simpleInput = ""
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    
    // Sheet + Form 的输入字段
    @State private var sheetUsername = ""
    @State private var sheetPassword = ""
    @State private var sheetEmail = ""
    @State private var sheetPhone = ""
    
    @State private var resultText = "暂无输入结果"
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            Text("iOS 系统原生弹窗输入框演示")
                .font(.headline)
            
            resultDisplayView
            
            buttonAreaView
            
            Spacer()
        }
        .padding()
        .alert("请输入内容", isPresented: $showSimpleAlert) {
            TextField("请输入内容", text: $simpleInput)
            Button("确定") {
                if !simpleInput.isEmpty {
                    resultText = "简单输入：\(simpleInput)"
                }
            }
            Button("取消", role: .cancel) {
                simpleInput = ""
            }
        } message: {
            Text("这是一个系统原生的输入弹窗")
        }
        .alert("用户信息", isPresented: $showMultiFieldAlert) {
            TextField("用户名", text: $username)
            Button("确定") {
                if !username.isEmpty {
                    resultText = "用户名：\(username)"
                }
            }
            Button("取消", role: .cancel) {
                username = ""
            }
        } message: {
            Text("系统 Alert 只能包含一个输入框")
        }
        .alert("请输入密码", isPresented: $showSecureAlert) {
            SecureField("密码", text: $password)
            Button("确定") {
                if !password.isEmpty {
                    resultText = "密码长度：\(password.count) 位"
                }
            }
            Button("取消", role: .cancel) {
                password = ""
            }
        } message: {
            Text("使用 SecureField 隐藏密码内容")
        }
        .alert("邮箱验证", isPresented: $showValidationAlert) {
            TextField("邮箱地址", text: $email)
            Button("验证") {
                if !email.isEmpty {
                    if isValidEmail(email) {
                        resultText = "邮箱有效：\(email)"
                    } else {
                        resultText = "邮箱格式无效：\(email)"
                    }
                }
            }
            Button("取消", role: .cancel) {
                email = ""
            }
        } message: {
            Text("输入邮箱地址进行格式验证")
        }
        .sheet(isPresented: $showSheetForm) {
            sheetFormView
        }
    }
    
    // 结果显示视图
    private var resultDisplayView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("输入结果：")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(resultText)
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
    
    // 按钮区域视图
    private var buttonAreaView: some View {
        VStack(spacing: 16) {
            Button("简单输入弹窗") {
                showSimpleAlert = true
            }
            .buttonStyle(.borderedProminent)
            
            Button("用户名输入弹窗") {
                showMultiFieldAlert = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            
            Button("密码输入弹窗") {
                showSecureAlert = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            
            Button("邮箱验证弹窗") {
                showValidationAlert = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            
            Button("Sheet + Form 多输入框") {
                showSheetForm = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            
            Button("清空结果") {
                clearAllResults()
            }
            .buttonStyle(.bordered)
            .foregroundColor(.secondary)
        }
    }
    
    // Sheet + Form 视图（三分之一屏幕高度，移除操作按钮）
    private var sheetFormView: some View {
        NavigationView {
            Form {
                Section("用户信息") {
                    TextField("用户名", text: $sheetUsername)
                        .textContentType(.username)
                    
                    SecureField("密码", text: $sheetPassword)
                        .textContentType(.password)
                }
            }
            .navigationTitle("用户注册")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        showSheetForm = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("确定") {
                        submitSheetForm()
                    }
                }
            }
        }
        .presentationDetents([.fraction(0.4)])
        .presentationDragIndicator(.visible)
    }
    
    // 简单的邮箱格式验证
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // 提交 Sheet + Form 表单（只处理两个输入框）
    private func submitSheetForm() {
        var results: [String] = []
        
        if !sheetUsername.isEmpty {
            results.append("用户名：\(sheetUsername)")
        }
        if !sheetPassword.isEmpty {
            results.append("密码：\(String(repeating: "*", count: sheetPassword.count))")
        }
        
        if results.isEmpty {
            resultText = "请至少填写一个字段"
        } else {
            resultText = results.joined(separator: "\n")
        }
        
        showSheetForm = false
    }
    
    // 清空所有结果
    private func clearAllResults() {
        resultText = "暂无输入结果"
        simpleInput = ""
        username = ""
        password = ""
        email = ""
        sheetUsername = ""
        sheetPassword = ""
        // 移除不再使用的邮箱和手机字段
        // sheetEmail = ""
        // sheetPhone = ""
    }
}

#if DEBUG
#Preview("系统原生输入弹窗 Demo") {
    SystemInputAlertDemo()
}
#endif
