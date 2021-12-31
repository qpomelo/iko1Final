//
//  Cache.swift
//  Pigeon
//
//  Created by QPomelo on 2020/6/20.
//  Copyright © 2020 QPomelo. All rights reserved.
//

import UIKit
import SwiftyRequest
import Alamofire

class Cache {
    
    public static func loadImageAsync(_ urlString: String, completion: @escaping (UIImage?) -> ()) {
        
        // 是否为有效 URL
        guard let _ = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let saveName = Encryption.MD5(string: urlString)
        let localPath = Cache.getCacheDirectory().appendingPathComponent(saveName).path
        if FileManager.default.fileExists(atPath: localPath) {
            // 文件已缓存
            var data: Data!
            do {
                try data = Data(contentsOf: getCacheDirectory().appendingPathComponent(saveName))
                let img = UIImage(data: data)
                completion(img)
                return
            } catch {
                print(error.localizedDescription)
                completion(nil)
                return
            }
        } else {
            // 文件未缓存
            AF.request(urlString).responseData { (response) in
                if let data = response.data {
                    let filePath = getCacheDirectory().appendingPathComponent(saveName)
                    do {
                        try data.write(to: filePath)
                        guard let img = UIImage(data: data) else {
                            completion(nil)
                            return
                        }
                        completion(img)
                    } catch {
                        completion(nil)
                    }
                    return
                }
                completion(nil)
            }
        }
        return
    }
    
    public static func getCacheDirectory() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0].appendingPathComponent("caches")
        if !FileManager.default.fileExists(atPath: documentsDirectory.absoluteString) {
            do {
                try FileManager.default.createDirectory(at: documentsDirectory, withIntermediateDirectories: true)
            } catch {
                print(error.localizedDescription)
            }
        }
        return documentsDirectory
    }
    
}
