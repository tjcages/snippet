//
//  Button.swift
//  natural
//
//  Created by Tyler Cagle on 1/2/22.
//

import SwiftUI

enum MainButtonType {
    case highlighted
    case active
    case disabled
}

struct MainButton: View {
    var type: MainButtonType
    var disabled: Bool? = false
    var handler: () -> Void
    
    var body: some View {
        Button {
            handler()
//          addingLink.toggle()
//            let newLink = Links(name: searchText, index: demoData.count + 1, imageURL: "", link: URL(string: ""))
//            demoData.append(newLink)
//            searchText = ""
        } label: {
          HStack {
            Spacer()
            
            Image(nsImage: NSImage(imageLiteralResourceName: NSImage.touchBarAddTemplateName))
              .frame(width: 24, height: 24, alignment: .trailing)
              .foregroundColor(type == .highlighted ? Color.black : Color.primary)
            
            Text("Add a link")
              .font(.system(size: 14, weight: .regular, design: .rounded))
              .foregroundColor(type == .highlighted ? Color.black : Color.primary)
            
            Spacer()
          }
          .padding(12)
          .background(Color.white.opacity(type == .highlighted ? 1 : 0.1))
          .cornerRadius(5)
        }
        .disabled(disabled ?? false)
        .buttonStyle(PlainButtonStyle())
        .padding([.horizontal], 12)
    }
}
