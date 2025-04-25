#if DEBUG || PREVIEW
import SwiftUI
import UIManager

// 弹窗演示的帮助方法
public extension PreviewPopupDemo {
    // 显示基础弹窗
    func showPopup() {
        // 根据位置和设置决定尺寸
        var popupWidth: CGFloat? = nil
        var popupHeight: CGFloat? = nil
        
        if showSizeControls {
            // 使用自定义尺寸
            popupWidth = width
            popupHeight = height
        } else {
            // 使用默认尺寸逻辑
            switch selectedPositionOption {
            case .left, .right:
                popupWidth = 250
            case .bottom, .top:
                popupHeight = 250
            case .center:
                popupWidth = 280
                popupHeight = 200
            }
        }
        
        // 创建一个自定义ID，用于后续更新弹窗
        let popupID = UUID()
        
        // 创建配置，添加关闭按钮设置和动画设置
        var entryConfig = PopupConfig(
            cornerRadius: 12,
            shadowEnabled: true,
            offsetY: offsetY,
            showCloseButton: showCloseButton,
            closeButtonPosition: .topTrailing,
            closeButtonStyle: selectedButtonStyle.toStyle(themeColor: themeManager.themeColor),
            closeOnTapOutside: true
        )
        
        // 设置进入动画 - 使用用户选择的进入动画类型
        if showAnimationControls {
            entryConfig.animation = selectedEntryAnimation.toAnimation(duration: animationDuration)
            entryConfig.customTransition = getEntryTransition()
        }
        
        // 将位置选项转换为PopupPosition
        var position: PopupPosition
        switch selectedPositionOption {
        case .center:
            position = .center
        case .top:
            position = .top
        case .bottom:
            position = .bottom
        case .left:
            position = .left
        case .right:
            position = .right
        }
        
        // 使用显式的动画包装显示弹窗操作
        withAnimation(entryConfig.animation) {
            // 显示具有进入动画的弹窗
            popupManager.show(
                content: {
                    VStack(spacing: 16) {
                        // 标题区域
                        Text(getPositionName(selectedPositionOption))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.isDarkMode ? .white : .black)
                            .padding(.top, 4)
                        
                        // 信息区块，增加分隔和背景
                        VStack(spacing: 10) {
                            if showSizeControls {
                                HStack {
                                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                                        .foregroundColor(themeManager.themeColor)
                                    Text("尺寸: \(Int(popupWidth ?? 0)) × \(Int(popupHeight ?? 0))")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(themeManager.isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.05))
                        )
                        
                        // 动画信息区块
                        if showAnimationControls {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("动画设置")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(themeManager.themeColor)
                                    .padding(.bottom, 2)
                                
                                HStack {
                                    Text("过渡效果:")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.isDarkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.6))
                                    Text(selectedTransitionType.rawValue)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                                }
                                
                                // 高级设置信息
                                if showAdvancedAnimation {
                                    if selectedTransitionType == .move || selectedTransitionType == .slide {
                                        HStack {
                                            Text("方向:")
                                                .font(.subheadline)
                                                .foregroundColor(themeManager.isDarkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.6))
                                            Text(selectedDirection.rawValue)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .foregroundColor(themeManager.isDarkMode ? .white : .black)
                                        }
                                    } else if selectedTransitionType == .scale {
                                        HStack {
                                            Text("缩放方式:")
                                                .font(.subheadline)
                                                .foregroundColor(themeManager.isDarkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.6))
                                            Text(selectedScaleType.rawValue)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .foregroundColor(themeManager.isDarkMode ? .white : .black)
                                        }
                                    }
                                }
                                
                                HStack {
                                    Text("进入动画:")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.isDarkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.6))
                                    Text(selectedEntryAnimation.rawValue)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                                }
                                
                                HStack {
                                    Text("退出动画:")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.isDarkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.6))
                                    Text(selectedExitAnimation.rawValue)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                                }
                                
                                HStack {
                                    Text("持续时间:")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.isDarkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.6))
                                    Text("\(String(format: "%.1f", animationDuration))秒")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                                }
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(themeManager.isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.05))
                            )
                        }
                        
                        // 描述文本区域
                        Text("这是一个基础弹窗示例，您可以选择不同的位置和动画来展示。")
                            .font(.subheadline)
                            .foregroundColor(themeManager.isDarkMode ? .white : .black)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 4)
                        
                        Button(action: {
                            withAnimation {
                                popupManager.closePopup(id: popupID)
                            }
                        }) {
                            Text("关闭")
                                .frame(width: 100, height: 40)
                                .background(themeManager.themeColor)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                },
                position: position,
                width: popupWidth,
                height: popupHeight,
                config: entryConfig,
                id: popupID
            )
        }
    }
    
    // 显示输入框弹窗
    func showInputPopup() {
        // 创建一个自定义ID，用于后续更新弹窗
        let popupID = UUID()
        
        // 初始弹窗配置，开始时不设置偏移
        var entryConfig = PopupConfig(
            cornerRadius: 16,
            shadowEnabled: true,
            offsetY: 0, // 初始不偏移
            showCloseButton: showCloseButton,
            closeButtonPosition: .topTrailing,
            closeButtonStyle: selectedButtonStyle.toStyle(themeColor: themeManager.themeColor),
            closeOnTapOutside: true
        )
        
        // 设置进入动画 - 使用用户选择的进入动画类型
        if showAnimationControls {
            entryConfig.animation = selectedEntryAnimation.toAnimation(duration: animationDuration)
            entryConfig.customTransition = getEntryTransition()
        }
        
        // 使用进入动画包装显示操作
        withAnimation(entryConfig.animation) {
            popupManager.show(
                content: {
                    VStack(spacing: 20) {
                        ScrollView {
                            VStack(spacing: 20) {
                                ForEach(0..<2) { index in
                                    TextField("输入框 \(index)", text: .constant(""))
                                        .textFieldStyle(.roundedBorder)
                                        .focused($isTextFieldFocused)
                                        .padding(.horizontal)
                                        .disableAutocorrection(true)
                                }
                            }
                            .padding(.top, 40)
                            .padding(.bottom, 20)
                        }
                        .simultaneousGesture(
                            TapGesture()
                                .onEnded { _ in
                                    // 点击ScrollView内部的空白区域不会关闭键盘
                                }
                        )
                        
                        // 添加一个完成按钮，方便用户关闭键盘
                        Button(action: {
                            isTextFieldFocused = false
                            // 使用短延迟更好地配合键盘动画
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation {
                                    popupManager.closePopup(id: popupID)
                                }
                            }
                        }) {
                            Text("完成")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 44)
                                .frame(maxWidth: .infinity)
                                .background(themeManager.themeColor)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                    .onAppear {
                        // 先等弹窗完全显示
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            // 再聚焦输入框，触发键盘显示
                            isTextFieldFocused = true
                        }
                    }
                    .onDisappear {
                        // 确保弹窗关闭时键盘也会收起
                        isTextFieldFocused = false
                    }
                },
                position: .center,
                width: 300,
                height: 280, // 增加高度以容纳按钮
                config: entryConfig,
                id: popupID
            )
        }
    }
    
    // 显示标准方向弹窗，使用默认的线性动画和滑动效果
    func showDirectionalPopup(position: PopupPosition) {
        // 创建一个自定义ID
        let popupID = UUID()
        
        // 根据位置确定合适的尺寸
        var popupWidth: CGFloat? = nil
        var popupHeight: CGFloat? = nil
        
        switch position {
        case .top, .bottom:
            popupHeight = 200
        case .left, .right:
            popupWidth = 200
        case .center, .absolute:
            popupWidth = 250
            popupHeight = 200
        }
        
        // 创建一个简单的配置，不使用任何自定义设置，让系统使用默认配置
        let config = PopupConfig(
            cornerRadius: 12,
            shadowEnabled: true,
            showCloseButton: true,
            closeOnTapOutside: true
        )
        
        // 显示弹窗，不传递任何自定义动画或过渡效果，让系统使用默认值
        popupManager.show(
            content: {
                VStack(spacing: 16) {
                    Text(getPositionName(position))
                        .font(.headline)
                        .foregroundColor(themeManager.primaryTextColor)
                    
                    Text("使用系统默认的线性动画和滑动效果")
                        .font(.subheadline)
                        .foregroundColor(themeManager.secondaryTextColor)
                        .multilineTextAlignment(.center)
                    
                    Text("动画过渡效果使用了线性动画和方向性滑动")
                        .font(.caption)
                        .foregroundColor(themeManager.secondaryTextColor)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        popupManager.closePopup(id: popupID)
                    }) {
                        Text("关闭")
                            .frame(width: 100, height: 40)
                            .background(themeManager.themeColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            },
            position: position,
            width: popupWidth,
            height: popupHeight,
            config: config,
            id: popupID
        )
    }
    
    // 显示绝对位置演示
    func showAbsolutePositionPopup(left: CGFloat? = nil, top: CGFloat? = nil, right: CGFloat? = nil, bottom: CGFloat? = nil) {
        // 创建绝对位置
        let position = PopupPosition.absolute(left: left, top: top, right: right, bottom: bottom)
        
        // 弹窗尺寸
        let popupWidth: CGFloat = 250
        let popupHeight: CGFloat = 200
        
        // 弹窗ID
        let popupID = UUID()
        
        // 创建配置
        let config = PopupConfig(
            cornerRadius: 12,
            shadowEnabled: true,
            showCloseButton: true,
            closeOnTapOutside: true
        )
        
        // 确定位置描述
        var positionDesc = ""
        if let left = left {
            positionDesc = "距左边: \(Int(left))px"
        } else if let right = right {
            positionDesc = "距右边: \(Int(right))px"
        }
        
        if let top = top {
            if !positionDesc.isEmpty {
                positionDesc += ", "
            }
            positionDesc += "距顶部: \(Int(top))px"
        } else if let bottom = bottom {
            if !positionDesc.isEmpty {
                positionDesc += ", "
            }
            positionDesc += "距底部: \(Int(bottom))px"
        }
        
        // 显示弹窗
        popupManager.show(
            content: {
                VStack(spacing: 16) {
                    Text(getPositionName(position))
                        .font(.headline)
                        .foregroundColor(themeManager.primaryTextColor)
                    
                    VStack(spacing: 8) {
                        Text("绝对位置弹窗")
                            .font(.subheadline)
                            .foregroundColor(themeManager.secondaryTextColor)
                        
                        Text(positionDesc)
                            .font(.caption)
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                    .multilineTextAlignment(.center)
                    
                    Button(action: {
                        popupManager.closePopup(id: popupID)
                    }) {
                        Text("关闭")
                            .frame(width: 100, height: 40)
                            .background(themeManager.themeColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            },
            position: position,
            width: popupWidth,
            height: popupHeight,
            config: config,
            id: popupID
        )
    }
    
    // 获取位置名称
    func getPositionName(_ position: PopupPosition) -> String {
        switch position {
        case .center:
            return "中间弹窗"
        case .top:
            return "顶部弹窗"
        case .bottom:
            return "底部弹窗"
        case .left:
            return "左侧弹窗"
        case .right:
            return "右侧弹窗"
        case .absolute(let left, let top, let right, let bottom):
            // 根据设置的边距描述位置
            if let left = left, left == 0 {
                return "左边贴边弹窗"
            } else if let right = right, right == 0 {
                return "右边贴边弹窗"
            } else if let top = top, top == 0 {
                return "顶部贴边弹窗"
            } else if let bottom = bottom, bottom == 0 {
                return "底部贴边弹窗"
            } else if let left = left, let top = top {
                return "自定义位置弹窗 (左\(Int(left))px, 上\(Int(top))px)"
            } else if let right = right, let bottom = bottom {
                return "自定义位置弹窗 (右\(Int(right))px, 下\(Int(bottom))px)"
            } else {
                return "自定义位置弹窗"
            }
        }
    }
    
    // 获取位置名称 - PositionOption版本
    func getPositionName(_ position: PositionOption) -> String {
        switch position {
        case .center:
            return "中间弹窗"
        case .top:
            return "顶部弹窗"
        case .bottom:
            return "底部弹窗"
        case .left:
            return "左侧弹窗"
        case .right:
            return "右侧弹窗"
        }
    }
} #endif
