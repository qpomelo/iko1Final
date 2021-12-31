//
//  SettingsView.swift
//  iko
//
//  Created by QPomelo on 19/11/2020.
//

import SwiftUI
import SafariServices

struct SettingsView: View {
    
    @State var controller: UIViewController?
    
    var body: some View {
        ZStack {
            // Background
            Rectangle().foregroundColor(Color("Background Color")).edgesIgnoringSafeArea(.all)
            ScrollView {
                
                VStack(alignment: .center, spacing: 0) {
                    
                    // Title
                    VStack(alignment: .center, spacing: 0) {
                        Text("设置")
                            .font(Font.custom("PingFangSC-Medium", size: 17))
                            .foregroundColor(Color("Title Color"))
                        Spacer()
                    }.padding(.top, 10)
                    
                    VStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            Text("版本: #version#"
                                    .replacingOccurrences(of: "#version#", with: "\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0") (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"))"))
                                .foregroundColor(Color("Main Color").opacity(0.4))
                                .font(Font.custom("PingFangSC-Medium", size: 14))
                                .padding(.top, 16)
                                .padding(.leading, 12)
                            Spacer()
                        }
                    }.padding([.leading, .trailing], 30)
                    
                    // 地区
                    /* Button(action: {
                        
                    }) {
                        SettingsItem(icon: Image("Language24"), text: "切换搜索地区")
                    }.padding(.top, 6)
                    .buttonStyle(PlainButtonStyle()) */
                    // 评分
                    Button(action: {
                        UIApplication.shared.open(URL(string: "itms-apps://apple.com/app/id1540407396")!)
                    }) {
                        SettingsItem(icon: Image("Rate24"), text: "为 iko 评分")
                    }.padding(.top, 3)
                    .buttonStyle(PlainButtonStyle())
                    // 隐私政策
                    Button(action: {
                        let safari = SFSafariViewController(url: URL(string: "https://qpomelo.app/iko/privacyPolicy/zh")!)
                        self.controller?.present(safari, animated: true)
                    }) {
                        SettingsItem(icon: Image("Privacy24"), text: "隐私政策")
                    }.padding(.top, 3)
                    .buttonStyle(PlainButtonStyle())
                    
                    
                    /*VStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            Text("关注开发者")
                                .foregroundColor(Color("Main Color").opacity(0.4))
                                .font(Font.custom("PingFangSC-Medium", size: 14))
                                .padding(.top, 16)
                                .padding(.leading, 12)
                            Spacer()
                        }
                    }.padding([.leading, .trailing], 30)
                    FollowDeveloperView() */
                    
                    VStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            Text("反馈问题")
                                .foregroundColor(Color("Main Color").opacity(0.4))
                                .font(Font.custom("PingFangSC-Medium", size: 14))
                                .padding(.top, 16)
                                .padding(.leading, 12)
                            Spacer()
                        }
                    }.padding([.leading, .trailing], 30)
                    ReportView()
                    
                    HStack(spacing: 4) {
                        Text("iko - Mini tool for you made with")
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color("Delete Color"))
                            .opacity(0.4)
                    }
                    .foregroundColor(Color("Main Color").opacity(0.4))
                    .font(Font.custom("PingFangSC-Medium", size: 14))
                    .padding(.top, 40)
                    .padding(.bottom, 100)
                    .padding(.leading, 12)
                    
                }
                
            }
            
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct FollowDeveloperView: View {
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                UIApplication.shared.open(URL(string: "https://twitter.com/realQPomelo")!)
            }) {
                SettingsItem(icon: Image("Twitter24"), text: "Twitter")
            }.padding(.top, 6)
            .buttonStyle(PlainButtonStyle())
            Button(action: {
                UIApplication.shared.open(URL(string: "https://weibo.com/realQPomelo")!)
            }) {
                SettingsItem(icon: Image("Weibo24"), text: "新浪微博")
            }.padding(.top, 3)
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct ReportView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Report a bug
            Button(action: {
                UIApplication.shared.open(URL(string: "mailto:support@qpomelo.app")!)
            }) {
                SettingsItem(icon: Image("Ant24"), text: "反馈 bug")
            }.padding(.top, 3)
            .buttonStyle(PlainButtonStyle())
            
            // Request a feature
            Button(action: {
                UIApplication.shared.open(URL(string: "mailto:support@qpomelo.app")!)
            }) {
                SettingsItem(icon: Image("AskFeature24"), text: "请求新功能")
            }.padding(.top, 3)
            .buttonStyle(PlainButtonStyle())
        }
    }
}
