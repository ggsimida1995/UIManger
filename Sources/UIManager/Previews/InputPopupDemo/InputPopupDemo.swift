#if DEBUG || PREVIEW
import SwiftUI
//import UIManager

/// 输入框弹窗演示组件
public struct InputPopupDemo: View {
    @StateObject private var popupManager = PopupManager.shared
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("输入框弹窗演示")
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical, 10)
            
            // 基本输入框弹窗
            Button(action: showBasicInputPopup) {
                Text("显示基本输入框")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
              Button(action: showBasicPopup) {
                Text("显示基本弹窗")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            // 自定义样式输入框弹窗
            Button(action: showCustomInputPopup) {
                Text("显示自定义输入框")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.blue.opacity(0.8))
                    .cornerRadius(10)
            }
            
            // 数字输入框弹窗
            Button(action: showNumberInputPopup) {
                Text("显示数字输入框")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.blue.opacity(0.6))
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
        .withPopups()
    }
     private func showBasicPopup() {
        let popupID = UUID()
       
        
        popupManager.show(
            content: {
                Text("基本弹窗")
            },
            position: .center,
            width: 300,
            height: 200,
            config: PopupConfig(
                cornerRadius: 16,
                shadowEnabled: true,
                showCloseButton: false,
                closeButtonPosition: .topTrailing,
                closeButtonStyle: .circular,
                closeOnTapOutside: true
            ),
            id: popupID
        )
    }
    
    // 显示基本输入框弹窗
    private func showBasicInputPopup() {
        let popupID = UUID()
        let config = InputPopupConfig(
            title: "请输入内容",
            placeholder: "在这里输入...",
            confirmText: "确定",
            cancelText: "取消"
        )
        
        popupManager.show(
            content: {
                InputPopupView(
                    config: config,
                    onConfirm: { text in
                        print("用户输入: \(text)")
                        popupManager.closePopup(id: popupID)
                    },
                    onCancel: {
                        print("用户取消了输入")
                        popupManager.closePopup(id: popupID)
                    }
                )
            },
            position: .center,
            width: 300,
            height: 200,
            config: PopupConfig(
                cornerRadius: 16,
                shadowEnabled: true,
                showCloseButton: false,
                closeButtonPosition: .topTrailing,
                closeButtonStyle: .circular,
                closeOnTapOutside: true
            ),
            id: popupID
        )
    }
    
    // 显示自定义样式输入框弹窗
    private func showCustomInputPopup() {
        let popupID = UUID()
        let config = InputPopupConfig(
            title: "修改昵称",
            placeholder: "请输入新昵称",
            confirmText: "保存",
            cancelText: "放弃",
            keyboardType: .default,
            textFieldConfig: TextFieldConfig(
                textColor: .blue,
                font: .title3,
                textAlignment: .leading,
                autocorrection: false,
                autocapitalization: .words
            )
        )
        
        popupManager.show(
            content: {
                InputPopupView(
                    config: config,
                    onConfirm: { text in
                        print("新昵称: \(text)")
                        popupManager.closePopup(id: popupID)
                    },
                    onCancel: {
                        print("用户放弃了修改")
                        popupManager.closePopup(id: popupID)
                    }
                )
            },
            position: .center,
            width: 300,
            height: 200,
            config: PopupConfig(
                cornerRadius: 16,
                shadowEnabled: true,
                showCloseButton: false,
                closeButtonPosition: .topTrailing,
                closeButtonStyle: .circular,
                closeOnTapOutside: true
            ),
            id: popupID
        )
    }
    
    // 显示数字输入框弹窗
    private func showNumberInputPopup() {
        let popupID = UUID()
        let config = InputPopupConfig(
            title: "请输入数量",
            placeholder: "请输入数字",
            confirmText: "确定",
            cancelText: "取消",
            keyboardType: .numberPad,
            textFieldConfig: TextFieldConfig(
                textColor: .primary,
                font: .body,
                textAlignment: .leading,
                autocorrection: false,
                autocapitalization: .never
            )
        )
        
        popupManager.show(
            content: {
                InputPopupView(
                    config: config,
                    onConfirm: { text in
                        print("输入的数量: \(text)")
                        popupManager.closePopup(id: popupID)
                    },
                    onCancel: {
                        print("用户取消了输入")
                        popupManager.closePopup(id: popupID)
                    }
                )
            },
            position: .center,
            width: 300,
            height: 200,
            config: PopupConfig(
                cornerRadius: 16,
                shadowEnabled: true,
                showCloseButton: false,
                closeButtonPosition: .topTrailing,
                closeButtonStyle: .circular,
                closeOnTapOutside: true
            ),
            id: popupID
        )
    }
}

// 预览提供者
struct InputPopupDemo_Previews: PreviewProvider {
    static var previews: some View {
        InputPopupDemo()
    }
}
#endif 
