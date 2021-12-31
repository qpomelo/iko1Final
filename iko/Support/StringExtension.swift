//
//  StringExtension.swift
//  Pigeon
//
//  Created by QPomelo on 2020/2/13.
//  Copyright © 2020 QPomelo. All rights reserved.
//

import Foundation

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func ranges(of string: String) -> [Range<String.Index>] {
        var rangeArray = [Range<String.Index>]()
        var searchedRange: Range<String.Index>
        guard let sr = self.range(of: self) else {
            return rangeArray
        }
        searchedRange = sr
        
        var resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        while let range = resultRange {
            rangeArray.append(range)
            searchedRange = Range(uncheckedBounds: (range.upperBound, searchedRange.upperBound))
            resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        }
        return rangeArray
    }
    
    func isIncludeChinese() -> Bool {
        for ch in self.unicodeScalars {
            if (0x4e00 < ch.value  && ch.value < 0x9fff) { return true } // 中文字符范围：0x4e00 ~ 0x9fff
        }
        return false
    }
    
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlPathAllowed)!.replacingOccurrences(of: "&", with: "%26").replacingOccurrences(of: "=", with: "%3d").replacingOccurrences(of: "*", with: "%2A").replacingOccurrences(of: "+", with: "%2B").replacingOccurrences(of: "_", with: "%5F").replacingOccurrences(of: "~", with: "%7E").replacingOccurrences(of: ".", with: "%2E").replacingOccurrences(of: ",", with: "%2C").replacingOccurrences(of: "!", with: "%21").replacingOccurrences(of: "'", with: "%27").replacingOccurrences(of: "-", with: "%2D").replacingOccurrences(of: "/", with: "%2F").replacingOccurrences(of: ":", with: "%3A").replacingOccurrences(of: "$", with: "%24").replacingOccurrences(of: "@", with: "%40").replacingOccurrences(of: "(", with: "%28").replacingOccurrences(of: ")", with: "%29")
        
        // .replacingOccurrences(of: "%", with: "%25")
        return encodeUrlString
    }
    
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return (self.removingPercentEncoding ?? "").replacingOccurrences(of: "&lt;", with: "<").replacingOccurrences(of: "&gt;", with: ">")
    }
}
