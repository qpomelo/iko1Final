//
//  QPTabBar.swift
//  Pigeon
//
//  Created by QPomelo on 18/11/2020.
//

import UIKit
import SwiftUI
import SnapKit
import SafariServices

class QPTabBar: UIView {
    
    var bottomSpacing: CGFloat = 80
    let cornerRadiusSize: CGFloat = 30
    let itemPadding: CGFloat = 24
    
    var viewController: RootViewController?
    var selectedIndex: Int = 0
    
    var backgroundBlur: UIVisualEffectView!
    var itemsContainer: UIView!
    
    var homeTabButton: QPButton!
    var listTabButton: QPButton!
    var shopTabButton: QPButton!
    var settingsTabButton: QPButton!
    var makeButton: UIButton!
    
    var feedbackGenerator: UIImpactFeedbackGenerator!
    
    func load() {
        
        if #available(iOS 13.0, *) {
            feedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
        } else {
            feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        }
        
        backgroundColor = .clear
        layer.masksToBounds = false
        snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-bottomSpacing)
        }
        
        backgroundBlur = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        backgroundBlur.layer.cornerRadius = cornerRadiusSize
        backgroundBlur.layer.masksToBounds = true
        addSubview(backgroundBlur)
        backgroundBlur.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        itemsContainer = UIView()
        itemsContainer.backgroundColor = UIColor(named: "TabBar Background Color")
        itemsContainer.layer.cornerRadius = cornerRadiusSize
        itemsContainer.layer.shadowColor = UIColor(named: "TabBar Shadow Color")!.cgColor
        itemsContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        itemsContainer.layer.shadowOpacity = 1
        itemsContainer.layer.shadowRadius = 15
        addSubview(itemsContainer)
        itemsContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(60)
        }
        
        
        var anchorView: UIView!
        
        homeTabButton = QPButton()
        itemsContainer.addSubview(homeTabButton)
        homeTabButton.tag = 0
        homeTabButton.setImage(UIImage(named: "Home 28"), for: .normal)
        homeTabButton.tintColor = UIColor(named: "TabBar Unselected Color")
        homeTabButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(itemPadding)
            make.centerY.equalToSuperview()
            make.size.equalTo(28)
        }
        homeTabButton.addTarget(self, action: #selector(tabItemPressed(_:)), for: .touchUpInside)
        anchorView = homeTabButton
        
        listTabButton = QPButton()
        itemsContainer.addSubview(listTabButton)
        listTabButton.tag = 1
        listTabButton.setImage(UIImage(named: "List 28"), for: .normal)
        listTabButton.tintColor = UIColor(named: "TabBar Unselected Color")
        listTabButton.snp.makeConstraints { (make) in
            make.leading.equalTo(anchorView.snp.trailing).offset(itemPadding)
            make.centerY.equalToSuperview()
            make.size.equalTo(28)
        }
        listTabButton.addTarget(self, action: #selector(tabItemPressed(_:)), for: .touchUpInside)
        anchorView = listTabButton
        
        /* shopTabButton = QPButton()
        itemsContainer.addSubview(shopTabButton)
        shopTabButton.tag = 2
        shopTabButton.setImage(UIImage(named: "Shop 28"), for: .normal)
        shopTabButton.tintColor = UIColor(named: "TabBar Unselected Color")
        shopTabButton.snp.makeConstraints { (make) in
            make.leading.equalTo(anchorView.snp.trailing).offset(itemPadding)
            make.centerY.equalToSuperview()
            make.size.equalTo(28)
        }
        shopTabButton.addTarget(self, action: #selector(tabItemPressed(_:)), for: .touchUpInside)
        anchorView = shopTabButton */
        
        settingsTabButton = QPButton()
        itemsContainer.addSubview(settingsTabButton)
        settingsTabButton.tag = 3
        settingsTabButton.setImage(UIImage(named: "Settings 28"), for: .normal)
        settingsTabButton.tintColor = UIColor(named: "TabBar Unselected Color")
        settingsTabButton.snp.makeConstraints { (make) in
            make.leading.equalTo(anchorView.snp.trailing).offset(itemPadding)
            make.centerY.equalToSuperview()
            make.size.equalTo(28)
        }
        settingsTabButton.addTarget(self, action: #selector(tabItemPressed(_:)), for: .touchUpInside)
        anchorView = settingsTabButton
        
        makeButton = UIButton()
        itemsContainer.addSubview(makeButton)
        makeButton.setImage(UIImage(named: "Make 28"), for: .normal)
        makeButton.tintColor = UIColor(named: "Theme Color")
        makeButton.addTarget(self, action: #selector(makeButtonPressed(_:)), for: .touchUpInside)
        makeButton.snp.makeConstraints { (make) in
            make.leading.equalTo(anchorView.snp.trailing).offset(itemPadding)
            make.trailing.equalToSuperview().offset(-itemPadding)
            make.centerY.equalToSuperview()
            make.size.equalTo(28)
        }
        anchorView = makeButton
        
        let themeChangedNotification = Notification.Name(rawValue: "Pigeon.Settings.ThemeChanged")
        NotificationCenter.default.addObserver(self, selector: #selector(updateComponents), name: themeChangedNotification, object: nil)
        updateComponents()
    }
    
    @objc func tabItemPressed(_ sender: UIButton) {
        feedbackGenerator.impactOccurred()
        viewController?.selectedIndex = sender.tag
        updateComponents()
    }
    
    func tabBarSelected(at: Int) {
        selectedIndex = at
        updateComponents()
    }
    
    @objc func makeButtonPressed(_ sender: UIButton) {
        if IconTask.task.count >= 1 {
            if UIDevice.current.userInterfaceIdiom == .mac {
                self.makeConfig(false, mac: true)
                return
            }
            let alert = UIAlertController(title: "图标配置文件已生成", message: "请注意: 删除此文件将会移除这些图标", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "安装", style: .default, handler: { _ in
                if #available(iOS 14.5, *) {
                    alert.dismiss(animated: true) {
                        let limitAlert = UIAlertController(title: "在 iOS 14.5 或更新版本中，iko 无法直接安装图标", message: "请您导出配置文件后，使用 Mac 上的 “Apple Configurator 2” 工具安装。", preferredStyle: .alert)
                        limitAlert.addAction(UIAlertAction(title: "好", style: .default, handler: nil))
                        self.viewController?.present(limitAlert, animated: true)
                    }
                } else {
                    self.makeConfig(true)
                }
            }))
            alert.addAction(UIAlertAction(title: "导出", style: .default, handler: { _ in
                self.makeConfig(false)
            }))
            alert.addAction(UIAlertAction(title: "安装教程", style: .default, handler: { _ in
                alert.dismiss(animated: true) {
                    let view = HelpView()
                    let hostingView = UIHostingController(rootView: view)
                    self.viewController?.present(hostingView, animated: true)
                }
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            viewController?.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "请先创建替代图标", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好", style: .cancel))
            viewController?.present(alert, animated: true)
        }
    }
    
    func makeConfig(_ installAtThisDevice: Bool, mac: Bool = false) {
        let result = makeIconConfig()
        if !result.0 {
            let alert = UIAlertController(title: "生成失败, 请稍后再试", message: result.1, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好", style: .cancel))
            viewController?.present(alert, animated: true)
        } else {
            if !installAtThisDevice {
                // 导出以在其他设备上安装
                let appName = IconTask.task.first?.appName ?? "未知"
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy年MM月dd日 hh:mm:ss"
                var fileName = ""
                if IconTask.task.count == 1 {
                    fileName = "\(appName) 的图标 (\(formatter.string(from: Date())).mobileconfig"
                } else {
                    fileName = "\(appName) 及另外 \(IconTask.task.count - 1) 个应用的图标 (\(formatter.string(from: Date())).mobileconfig"
                }
                let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                let filePath = paths.appendingPathComponent(fileName)
                // 是否有旧文件 -> 删除
                if FileManager.default.fileExists(atPath: filePath.absoluteString) {
                    do {
                        try FileManager.default.removeItem(atPath: filePath.absoluteString)
                    } catch {
                        let alert = UIAlertController(title: "生成失败", message: "未能移除先前创建的描述文件", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "好", style: .cancel))
                        viewController?.present(alert, animated: true)
                    }
                }
                // 写入新的文件
                do {
                    try result.1.data(using: .utf8)?.write(to: filePath)
                } catch {
                    let alert = UIAlertController(title: "生成失败", message: "未能创建描述文件, 可能是设备存储空间不足", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "好", style: .cancel))
                    viewController?.present(alert, animated: true)
                }
                // 根据用户选择决定分享
                
                if mac {
                    let docVC = UIDocumentPickerViewController.init(forExporting: [filePath], asCopy: true)
                    viewController?.present(docVC, animated: true)
                    return
                }
                
                let activityView = UIActivityViewController(activityItems: [filePath], applicationActivities: nil)
                self.viewController?.present(activityView, animated: true)
            } else {
                // 在此设备安装
                let path = UUID().uuidString.replacingOccurrences(of: "-", with: "")
                if MobileConfigServer.shared.registerConfigPath(path, configXML: result.1) {
                    let safariView = SFSafariViewController(url: URL(string: "http://localhost:8800/\(path)")!)
                    self.viewController?.present(safariView, animated: true)
                    // UIApplication.shared.open(URL(string: "http://localhost:8800/\(path)")!)
                } else {
                    let alert = UIAlertController(title: "安装失败", message: "未能启动本地配置文件下发服务器, 请尝试选择「导出」并通过文件 app 保存到本地后手动安装", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "好", style: .cancel))
                    viewController?.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc func updateComponents() {
        itemsContainer.layer.shadowColor = UIColor(named: "TabBar Shadow Color")!.cgColor
        
        let unselectedColor = UIColor(named: "TabBar Unselected Color")
        let selectedColor = UIColor(named: "Theme Color")
        selectedIndex = viewController?.selectedIndex ?? 0
        
        homeTabButton.tintColor = selectedIndex == 0 ? selectedColor : unselectedColor
        listTabButton.tintColor = selectedIndex == 1 ? selectedColor : unselectedColor
        // shopTabButton.tintColor = selectedIndex == 2 ? selectedColor : unselectedColor
        settingsTabButton.tintColor = selectedIndex == 3 ? selectedColor : unselectedColor
        
        makeButton.tintColor = UIColor(named: "Theme Color")
    }
    
}
