//
//  RootViewController.swift
//  iko
//
//  Created by QPomelo on 18/11/2020.
//

import UIKit
import SwiftUI
import Alamofire

class RootViewController: UITabBarController {
    
    var floatingTabBar: QPTabBar = QPTabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Mac Catalyst fix
        func bitSet(_ bits: [Int]) -> UInt {
                return bits.reduce(0) { $0 | (1 << $1) }
            }

            func property(_ property: String, object: NSObject, set: [Int], clear: [Int]) {
                if let value = object.value(forKey: property) as? UInt {
                    object.setValue((value & ~bitSet(clear)) | bitSet(set), forKey: property)
                }
            }

            // disable full-screen button
            if  let NSApplication = NSClassFromString("NSApplication") as? NSObject.Type,
                let sharedApplication = NSApplication.value(forKeyPath: "sharedApplication") as? NSObject,
                let windows = sharedApplication.value(forKeyPath: "windows") as? [NSObject]
            {
                for window in windows {
                    let resizable = 3
                    property("styleMask", object: window, set: [], clear: [resizable])
                    let fullScreenPrimary = 7
                    let fullScreenAuxiliary = 8
                    let fullScreenNone = 9
                    property("collectionBehavior", object: window, set: [fullScreenNone], clear: [fullScreenPrimary, fullScreenAuxiliary])
                }
            }
    }
    
    func initComponents() {
        view.backgroundColor = UIColor(named: "Background Color")
        viewControllers = [UIHostingController(rootView: HomeView(controller: self)),
                           UIHostingController(rootView: TaskListView(controller: self)),
                           UIViewController(),
                           UIHostingController(rootView: SettingsView(controller: self)),
        ]
        
        tabBar.isHidden = true
        
        floatingTabBar.viewController = self
        view.addSubview(floatingTabBar)
        floatingTabBar.load()

        NotificationCenter.default.addObserver(self, selector: #selector(revicedTaskAddNotification), name: Notification.Name("iko.updateTask"), object: nil)
    }
    
    @objc func revicedTaskAddNotification() {
        selectedIndex = 1
        floatingTabBar.selectedIndex = 1
        floatingTabBar.updateComponents()
    }
    
}
