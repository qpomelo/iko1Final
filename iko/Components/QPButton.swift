//
//  QPButton.swift
//  Pigeon
//
//  Created by QPomelo on 18/11/2020.
//

import UIKit

class QPButton: UIButton {

    var loaded: Bool = false
    
    override var tintColor: UIColor! {
        get {
            return super.tintColor
        }
        set {
            super.tintColor = newValue
            update()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if loaded { return }
        update()
        
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonPressed), for: .touchDragEnter)
        addTarget(self, action: #selector(buttonPressed), for: .touchDragInside)
        
        addTarget(self, action: #selector(buttonUnpressed), for: .touchCancel)
        addTarget(self, action: #selector(buttonUnpressed), for: .touchDragExit)
        addTarget(self, action: #selector(buttonUnpressed), for: .touchDragOutside)
        addTarget(self, action: #selector(buttonUnpressed), for: .touchUpInside)
        addTarget(self, action: #selector(buttonUnpressed), for: .touchUpOutside)
        loaded = true
    }
    
    func update() {
        setTitleColor(tintColor, for: .normal)
        
        if titleLabel != nil {
            titleLabel!.font = UIFont(name: "PingFangSC-Medium", size: 14 + 1)!
        }
        
    }
    
    @objc func buttonPressed() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.4
        }
    }
    
    @objc func buttonUnpressed() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
    
}

