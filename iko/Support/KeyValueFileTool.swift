//
//  KeyValueFileTool.swift
//  iko
//
//  Created by QPomelo on 4/12/2020.
//

import Foundation

class KeyValue {
    
    public static func load(fileName: String) -> [String: String] {
        let path = Bundle.main.path(forResource: fileName, ofType: "key-value")
        var body = ""
        do {
            body = try String(contentsOf: URL(fileURLWithPath: path ?? ""))
        } catch {
            return [:]
        }
        
        var dict: [String: String] = [:]
        for line in body.split(separator: "\n") {
            if line.split(separator: "=").count == 2 { // 是一条记录
                let key: String = String(line.split(separator: "=")[0])
                let value: String = String(line.split(separator: "=")[1])
                dict[key] = value
            }
        }
        
        return dict
    }
    
}
