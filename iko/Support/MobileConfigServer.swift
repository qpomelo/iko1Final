//
//  MobileConfigServer.swift
//  iko
//
//  Created by QPomelo on 4/12/2020.
//

import Foundation
import Swifter

class MobileConfigServer {
    
    public static var shared = MobileConfigServer()
    
    var server = HttpServer()

    func registerConfigPath(_ configName: String, configXML: String) -> Bool {
        do {
            server.stop()
            let html = MobileConfigServer.loadTemplateHtml().replacingOccurrences(of: "#CONFIG#", with: configXML.toBase64())
            server["/\(configName)"] = { request in
                return HttpResponse.ok(.htmlBody(html))
            }
            try server.start(8800, forceIPv4: false)
        } catch(let error) {
            print("HTTP Server can't start: \(error.localizedDescription)")
            return false
        }
        return true
    }
    
    public static func loadTemplateHtml() -> String {
        let path = Bundle.main.path(forResource: "InstallMobileConfig", ofType: "html")
        var htmlBody = ""
        do {
            htmlBody = try String(contentsOf: URL(fileURLWithPath: path ?? ""))
        } catch {
            return ""
        }
        return htmlBody
    }
    
}
