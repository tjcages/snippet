//
//  TextField.swift
//  natural
//
//  Created by Tyler Cagle on 1/2/22.
//

import SwiftUI

enum FocusFields: Hashable {
  case name
  case link
}

struct TextView: View {
  @Binding var text: String
  var icon: String?
  
  @FocusState var focusedField: FocusFields?
  
  @State private var isEditing = false
  
  var handler: () -> Void
  
  var body: some View {
    HStack {
      if let icon = icon {
        Image(nsImage: NSImage(imageLiteralResourceName: icon))
          .frame(width: 24, height: 24, alignment: .trailing)
      }
      
      
      TextField("Link name", text: $text)
        .font(.system(size: 16, weight: .regular, design: .rounded))
        .textFieldStyle(PlainTextFieldStyle())
        .padding([.vertical], 8)
        .padding([.horizontal], 16)
        .focused($focusedField, equals: .link)
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.control, lineWidth: 1)
        )
        .onTapGesture {
          self.isEditing = true
        }
        .onSubmit {
          handler()
        }
        .onAppear {
          self.focusedField = .link
        }
    }
  }
}
