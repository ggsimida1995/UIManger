#if DEBUG || PREVIEW
import SwiftUI
//import UIManager

/// 输入框弹窗演示组件
public struct InputPopupDemo: View {
    @StateObject private var popupManager = PopupManager.shared
    @State private var userName: String = "测试用户"
    @State private var email: String = "test@example.com"
    @State private var phoneNumber: String = "13812345678"
    @State private var address: String = "北京市朝阳区"
    @State private var remark: String = "这是一段备注信息，可以输入多行文本。"
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            // 信息展示区域
            VStack(alignment: .leading, spacing: 10) {
                Text("当前用户信息")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                InfoRow(title: "姓名", value: userName)
                InfoRow(title: "邮箱", value: email)
                InfoRow(title: "电话", value: phoneNumber)
                InfoRow(title: "地址", value: address)
                InfoRow(title: "备注", value: remark)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.vertical)
            
            // 按钮区域
            Text("输入框弹窗演示")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            // 单字段输入框
            Button(action: showSingleFieldPopup) {
                buttonLabel("单字段输入框", color: .blue)
            }
            
            // 编辑模式
            Button(action: showEditModePopup) {
                buttonLabel("编辑用户信息", color: .green)
            }
            
            // 登录表单
            Button(action: showLoginForm) {
                buttonLabel("登录表单", color: .orange)
            }
            
            // 多字段表单
            Button(action: showMultiFieldForm) {
                buttonLabel("完整用户资料", color: .purple)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .withPopups()
    }
    
    // 辅助视图构建方法
    private func buttonLabel(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(color)
            .cornerRadius(10)
    }
    
    private func InfoRow(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(title):")
                .foregroundColor(.secondary)
                .frame(width: 60, alignment: .leading)
            
            Text(value)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
    
    // 显示单字段输入框
    private func showSingleFieldPopup() {
        showInputPopup(
            title: "修改用户名",
            field: InputField(
                placeholder: "请输入新的用户名",
                value: userName,
                required: true,
                maxLength: 20
            ),
            confirmText: "保存",
            cancelText: "取消",
            onConfirm: { value in
                userName = value
            }
        )
    }
    
    // 显示编辑模式弹窗
    private func showEditModePopup() {
        // 创建要编辑的字段
        let config = InputPopupConfig(
            title: "编辑用户信息",
            fields: [
                InputField(
                    label: "用户名",
                    placeholder: "请输入用户名",
                    value: userName,
                    required: true
                ),
                InputField(
                    label: "电子邮箱",
                    placeholder: "请输入邮箱",
                    value: email,
                    type: .email
                )
            ],
            confirmText: "保存",
            cancelText: "取消",
            appearance: InputPopupAppearance(
                confirmButtonColor: .green
            )
        )
        
        showInputPopup(config: config) { values in
            // 更新状态
            userName = values["用户名"] ?? userName
            email = values["电子邮箱"] ?? email
        }
    }
    
    // 显示登录表单
    private func showLoginForm() {
        let config = InputPopupConfig(
            title: "用户登录",
            fields: [
                InputField(
                    label: "账号",
                    placeholder: "请输入账号/邮箱",
                    required: true
                ),
                InputField(
                    label: "密码",
                    placeholder: "请输入密码",
                    type: .password,
                    required: true
                )
            ],
            confirmText: "登录",
            cancelText: "取消",
            appearance: InputPopupAppearance(
                backgroundColor: Color(.systemBackground),
                titleColor: .blue,
                titleFont: .headline,
                confirmButtonColor: .blue
            )
        )
        
        showInputPopup(config: config) { values in
            print("登录账号: \(values["账号"] ?? "")")
            print("输入密码: \(values["密码"] ?? "")")
        }
    }
    
    // 显示多字段表单
    private func showMultiFieldForm() {
        let config = InputPopupConfig(
            title: "完整用户资料",
            fields: [
                InputField(
                    label: "姓名",
                    placeholder: "请输入姓名",
                    value: userName,
                    required: true
                ),
                InputField(
                    label: "邮箱",
                    placeholder: "请输入邮箱",
                    value: email,
                    type: .email,
                    validator: { email in
                        email.contains("@") && email.contains(".")
                    }
                ),
                InputField(
                    label: "手机号",
                    placeholder: "请输入手机号",
                    value: phoneNumber,
                    type: .number,
                    maxLength: 11
                ),
                InputField(
                    label: "地址",
                    placeholder: "请输入地址",
                    value: address
                ),
                InputField(
                    label: "备注",
                    placeholder: "请输入备注信息",
                    value: remark,
                    type: .multiline
                )
            ],
            confirmText: "提交",
            cancelText: "取消",
            appearance: InputPopupAppearance(
                confirmButtonColor: .purple
            )
        )
        
        showInputPopup(config: config) { values in
            userName = values["姓名"] ?? userName
            email = values["邮箱"] ?? email
            phoneNumber = values["手机号"] ?? phoneNumber
            address = values["地址"] ?? address
            remark = values["备注"] ?? remark
        }
    }
}

// 预览提供者
struct InputPopupDemo_Previews: PreviewProvider {
    static var previews: some View {
        InputPopupDemo()
    }
}
#endif 
