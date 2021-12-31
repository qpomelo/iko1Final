//
//  MakeIconConfig.swift
//  iko
//
//  Created by QPomelo on 3/12/2020.
//

import Foundation

func makeIconConfig() -> (Bool, String) {
    let path = Bundle.main.path(forResource: "MobileConfigTemplate", ofType: "xml")
    let iconPath = Bundle.main.path(forResource: "AppIconConfigTemplate", ofType: "xml")
    var configTemplate = "", appTemplate = ""
    do {
        configTemplate = try String(contentsOf: URL(fileURLWithPath: path!))
        appTemplate = try String(contentsOf: URL(fileURLWithPath: iconPath!))
    } catch {
        return (false, "读取描述文件模板遇到问题")
    }
    
    // 描述
    var iconNames = ""
    for app in IconTask.task {
        iconNames = "\(iconNames) \(app.appOrignalName)、"
    }
    iconNames = String(iconNames.prefix(iconNames.count - 1))
    configTemplate = configTemplate.replacingOccurrences(of: "#DESCRIPTION#", with: "由 iko 生成的替换图标，该文件包含以下 app 的替换图标: \(iconNames)。")
    
    // 名称
    var configName = ""
    if IconTask.task.count == 1 {
        configName = "“\(IconTask.task.first?.appOrignalName ?? "未知应用")” 的替代图标"
    } else {
        configName = "“\(IconTask.task.first?.appOrignalName ?? "未知应用")” 等 \(IconTask.task.count) 个应用的替代图标"
    }
    configTemplate = configTemplate.replacingOccurrences(of: "#DISPLAY_NAME#", with: configName)
    
    // UUID 与标识符
    let uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "")
    configTemplate = configTemplate.replacingOccurrences(of: "#CONFIG_IDENTIFIER#", with: "app.qpomelo.iko-\(uuid.lowercased())")
    configTemplate = configTemplate.replacingOccurrences(of: "#PAYLOAD_UUID#", with: uuid)
    
    // 图标内容
    var appList = ""
    for app in IconTask.task {
        var template = appTemplate
        if app.bundleId.replacingOccurrences(of: " ", with: "") == "" {
            template = template.replacingOccurrences(of: "<key>TargetApplicationBundleIdentifier</key>\n    <string>#BUNDLE_ID#</string>", with: "")
        }
        // 图标
        template = template.replacingOccurrences(of: "#ICON_BASE64#", with: app.editedAppIcon?.toBase64() ?? "")
        // 名称
        template = template.replacingOccurrences(of: "#APP_NAME#", with: app.appName)
        // Payload 名称
        template = template.replacingOccurrences(of: "#PAYLOAD_NAME#", with: app.appOrignalName.urlEncoded())
        // Payload 标识符
        template = template.replacingOccurrences(of: "#BUNDLE_ID#", with: app.bundleId)
        // UUID
        let uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        template = template.replacingOccurrences(of: "#UUID#", with: uuid)
        // Url
        var appUrl = " "
        if let url = app.urlScheme {
            appUrl = url
        }
        template = template.replacingOccurrences(of: "#URL#", with: appUrl)
        
        // 追加
        appList = "\(appList)\(template)\n"
    }
    
    configTemplate = configTemplate.replacingOccurrences(of: "#APP_ICON_LIST#", with: appList)
    
    return (true, configTemplate)
}
