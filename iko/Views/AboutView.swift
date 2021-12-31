//
//  SettingsAboutView.swift
//  Pigeon
//
//  Created by QPomelo on 2020/7/18.
//  Copyright © 2020 QPomelo. All rights reserved.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct SettingsAboutView: View {
    
    @State var isRootView: Bool = false
    
    var body: some View {
        ZStack {
            
            // Background
            Rectangle().foregroundColor(Color("Background Color")).edgesIgnoringSafeArea(.all)
            
            // Content
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
                            Text("图标小工具")
                                .font(Font.custom("PingFangSC-Medium", size: 28))
                                .opacity(0.8)
                            
                            Spacer()
                        }
                        .padding(.top, 38)
                        
                        HStack(spacing: 0) {
                            Text("iko")
                                .font(Font.custom("Futura-Medium", size: 36))
                                .foregroundColor(Color("Theme Color"))
                            Spacer()
                        }
                        
                            Text("版本: #version#"
                                    .replacingOccurrences(of: "#version#", with: "\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0") (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"))"))
                            .font(Font.custom("PingFangSC-Medium", size: 15))
                            .opacity(0.4)
                        
                    }
                    .padding([.leading, .trailing], 30)
                    
                    // Report a bug
                    Button(action: {
                        UIApplication.shared.open(URL(string: "mailto:")!)
                    }) {
                        SettingsItem(icon: Image("Ant24"), text: "[iko] 反馈 bug")
                    }.padding(.top, 6)
                    .buttonStyle(PlainButtonStyle())
                    
                    // Request a feature
                    Button(action: {
                        UIApplication.shared.open(URL(string: "mailto:")!)
                    }) {
                        SettingsItem(icon: Image("AskFeature24"), text: "[iko] 请求新功能")
                    }.padding(.top, 3)
                    .buttonStyle(PlainButtonStyle())
                    
                    
                    // Privacy Policy
                    Button(action: {
                        UIApplication.shared.open(URL(string: "")!)
                    }) {
                        SettingsItem(icon: Image("Privacy24"), text: "隐私政策")
                    }.padding(.top, 3)
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }
                .padding(.top, 76)
                
            }
            
            // Navigation Bar
            VStack(spacing: 0) {
                ZStack {
                    // BlurView(style: .regular)
                    HStack(spacing: 0) {
                        Rectangle()
                            .opacity(0)
                            .frame(width: 30)
                        
                        Text("关于")
                            .font(Font.custom("PingFangSC-Medium", size: 15))
                            .foregroundColor(Color("Main Color"))
                            .opacity(0.8)
                        
                        
                        Spacer()
                    }.frame(height: 76)
                }.frame(height: 76)
                Spacer()
            }
            
        }.edgesIgnoringSafeArea(.top)
    }
    
}
