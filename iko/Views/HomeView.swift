//
//  HomeView.swift
//  iko
//
//  Created by QPomelo on 19/11/2020.
//

import SwiftUI
import SafariServices

struct HomeView: View {
    
    var controller: UIViewController?
    
    var body: some View {
        ZStack {
            // Background
            Rectangle().foregroundColor(Color("Background Color")).edgesIgnoringSafeArea(.all)
            // Title
            VStack(alignment: .center, spacing: 0) {
                HStack(spacing: 0) {
                    Spacer()
                    Text("iko")
                        .font(Font.custom("PingFangSC-Medium", size: 17))
                        .foregroundColor(Color("Title Color"))
                    Spacer()
                }
                Spacer()
            }.padding(.top, 10)
            // Help
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        let helpView = HelpView()
                        let hostingView = UIHostingController(rootView: helpView)
                        controller?.present(hostingView, animated: true)
                        
                        /* let sfView = SFSafariViewController(url: URL(string: "https://qpomelo.app/iko/help")!)
                        self.controller?.present(sfView, animated: true) */
                    }) {
                        Text("帮助")
                            .font(Font.custom("PingFangSC-Medium", size: 17))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(Color("Theme Color"))
                    .padding(.trailing, 28)
                }.padding(.top, 10)
                Spacer()
            }
            
            VStack(alignment: .center, spacing: 60) {
                // Add Button
                Button(action: {
                    let vc = NewIconViewController()
                    controller?.present(vc, animated: true)
                }) {
                    VStack(alignment: .center, spacing: 24) {
                        Image("Empty Image Icon")
                        Text("创建替代图标")
                            .font(Font.custom("PingFangSC-Medium", size: 17))
                    }
                }
                .buttonStyle(PlainButtonStyle()).foregroundColor(Color("Title Color"))
                // Import Button
                /* Button(action: {
                }) {
                    VStack(alignment: .center, spacing: 24) {
                        Image("Import Image Icon")
                        Text("导入图标包")
                            .font(Font.custom("PingFangSC-Medium", size: 17))
                    }
                }.foregroundColor(Color("Title Color")) */
            }
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
