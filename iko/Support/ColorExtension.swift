//
//  ColorExtension.swift
//  iko
//
//  Created by QPomelo on 5/12/2020.
//

import UIKit

extension UIImage {
    public func isTransparent() -> Bool {
        guard let alpha = self.cgImage?.alphaInfo else { return true }
        return alpha == .first || alpha == .last || alpha == .premultipliedFirst || alpha == .premultipliedLast
    }
}
