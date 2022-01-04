//
//  Search.swift
//  natural
//
//  Created by Tyler Cagle on 1/2/22.
//

import SwiftUI

struct Search: View {
    @Binding var searchText: String
    @State private var isEditing = false
    
    var handler: () -> Void
    
    var body: some View {
        HStack {
          Image(nsImage: NSImage(imageLiteralResourceName: NSImage.touchBarSearchTemplateName))
            .frame(width: 24, height: 24, alignment: .trailing)
          
          
          TextField("Search ..", text: $searchText)
            .font(.system(size: 16, weight: .regular, design: .rounded))
            .textFieldStyle(PlainTextFieldStyle())
            .padding([.top, .bottom, .trailing], 16)
            .cornerRadius(8)
            .onTapGesture {
              self.isEditing = true
            }
            .onSubmit {
                handler()
            }
            
            if searchText != "" {
                Button {
                    searchText = ""
                } label: {
                    Image(nsImage: NSImage(imageLiteralResourceName: NSImage.stopProgressFreestandingTemplateName))
                      .frame(width: 24, height: 24, alignment: .trailing)
                }
                .buttonStyle(PlainButtonStyle())
            }

        }
        .padding([.trailing], 20)
        .padding([.leading], 16)
    }
}
