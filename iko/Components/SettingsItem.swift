//
//  SettingsItem.swift
//  Pigeon
//
//  Created by QPomelo on 2020/7/17.
//  Copyright © 2020 QPomelo. All rights reserved.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct SettingsItem: View {
    
    @State var tintColor: Color?
    @State var icon: Image
    @State var text: String
    
    var body: some View {
        ZStack {
            // Background
            Rectangle()
                .foregroundColor(tintColor != nil ? tintColor?.opacity(0.1) : Color("Button Background Color"))
                .cornerRadius(10)
                .frame(height: 52)
            HStack(alignment: .center, spacing: 0) {
                
                icon
                    .resizable()
                    .frame(width: 24, height: 24)
                    .scaledToFit()
                    .foregroundColor(tintColor)
                    .padding(.leading, 24)
                
                Text(text)
                    .font(Font.custom("PingFangSC-Regular", size: 16))
                    .foregroundColor(Color("Main Color"))
                    .padding(.leading, 24)
                
                Spacer()
                
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
    
}
