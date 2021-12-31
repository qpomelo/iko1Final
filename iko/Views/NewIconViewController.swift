//
//  NewIconViewController.swift
//  iko
//
//  Created by QPomelo on 19/11/2020.
//

import UIKit
import SwiftUI

class NewIconViewController: QPSheetViewController {
    
    var rootNavigationController = UINavigationController()
    var editViewController = EditIconInfoViewController()
    
    var editAppIcon: AppInfo?
    
    var _sheetHeight: CGFloat = 500
    var sheetHeight: CGFloat {
        get { return _sheetHeight }
        set {
            _sheetHeight = newValue
            UIView.animate(withDuration: 0.5) {
                self.rootNavigationController.view.snp.updateConstraints { make in
                    make.height.greaterThanOrEqualTo(self._sheetHeight)
                }
                self.rootNavigationController.view.layoutIfNeeded()
            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initComponents() {
        super.initComponents()
        
        sheetTitle = ""
        
        editViewController.editAppIcon = editAppIcon
        editViewController.sheetController = self
        rootNavigationController = UINavigationController(rootViewController: editViewController)
        addChild(rootNavigationController)
        contentView.addSubview(rootNavigationController.view)
        rootNavigationController.navigationBar.isHidden = true
        rootNavigationController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(_sheetHeight)
        }
        
    }
    
    override func askForDismiss() -> Bool {
        return editViewController.askForDissmiss() 
    }
    
    
}
