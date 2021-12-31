//
//  HelpView.swift
//  iko
//
//  Created by QPomelo on 5/12/2020.
//

import SwiftUI
import Introspect

struct HelpView: View {
    
    @State var controller: UIViewController?
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink("如何制作替代图标", destination: HelpUI(title: "如何制作替代图标", image: "Quick Start"))
                NavigationLink("如何将图标安装在此设备上", destination: HelpUI(title: "如何将图标安装在此设备上", image: "Install Introduction"))
                NavigationLink("如何将图标安装到其他设备上", destination: HelpUI(title: "如何将图标安装到其他设备上", image: "Export Introduction"))
                Text("自 iOS 14.5 或更新版本，iko 不再支持直接在设备上安装替代图标，请您导出描述文件后在 Mac 上使用 Apple Configurator 2 工具安装到您的设备上。")
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("帮助", displayMode: .inline)
            .toolbar {
                Button("关闭") {
                    self.controller?.dismiss(animated: true)
                }
            }
            .introspectViewController { controller in
                self.controller = controller
            }
        }
        
    }
    
}

struct HelpUI: View {
    
    @State var title: String
    @State var image: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("Background Color"))
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                Image(image)
            }
        }.navigationBarTitle(title, displayMode: .inline)
    }
    
}
