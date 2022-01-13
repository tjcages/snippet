//
//  BottomMenu.swift
//  natural
//
//  Created by Tyler Cagle on 1/12/22.
//

import SwiftUI

struct BottomMenu: View {
    @Environment(\.openURL) var openURL
    @State private var showPicker = false
    
    var body: some View {
        HStack {
            Menu {
                Button(action: {
                    NSApp.terminate(self)
                }) {
                    Label("Quit", systemImage: "plus.circle")
                }
            } label: {
                Image(systemName: "gearshape")
            }
            .menuStyle(BorderlessButtonMenuStyle())
            .fixedSize() // Otherwise will be the width of your menu options.
            
            Spacer()
            
            Button(action: {
                if let url = URL(string: "https://www.tylerj.me/works/natural") {
                    openURL(url)
                }
            }) {
                Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: 14, height: 14)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding([.horizontal, .top], 10)
    }
}
