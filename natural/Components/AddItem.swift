//
//  AddItem.swift
//  natural
//
//  Created by Tyler Cagle on 1/2/22.
//

import SwiftUI

struct AddItem: View {
    @EnvironmentObject var session: SessionStore
    
    var starterText: String?
    @Binding var addingLink: Bool
    
    @FocusState var focusedField: FocusFields?
    @State var nameText = ""
    @State var linkText = ""
    
    func submitNewLink() {
        var newLinkText = linkText
        
        if !newLinkText.hasPrefix("https://") && !newLinkText.hasPrefix("http://") {
            var correctedURL = newLinkText
            if !correctedURL.hasPrefix("www.") { correctedURL = "www.\(correctedURL)" }
            correctedURL = "https://\(correctedURL)"
            newLinkText = correctedURL
        }
        
        let newLink = Links(name: nameText, link: newLinkText)
        demoData.append(newLink)
        addingLink.toggle()
        
//        session.signInAnonymously()
        session.addLink(name: nameText, link: newLinkText)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    addingLink.toggle()
                } label: {
                    Image(nsImage: NSImage(imageLiteralResourceName: NSImage.touchBarGoBackTemplateName))
                        .frame(width: 28, height: 28, alignment: .center)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(50)
                }
                .buttonStyle(PlainButtonStyle())
                
                
                Spacer()
            }
            .padding(16)
            
            Group {
                HStack {
                    Text("Name")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(Color.secondary)
                        .frame(width: 48, height: 20, alignment: .leading)
                    TextView(text: $nameText) {
                        focusedField = .link
                    }
                }
                
                HStack {
                    Text("Link")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(Color.secondary)
                        .frame(width: 48, height: 20, alignment: .leading)
                    
                    TextView(text: $linkText) {
                        submitNewLink()
                    }
                }
            }
            .padding([.horizontal, .bottom], 16)
            
            Spacer()
            
            MainButton(type: .highlighted, disabled: linkText == "") {
                submitNewLink()
            }
        }
        .padding([.vertical], 8)
        .onAppear {
            nameText = starterText ?? ""
            focusedField = .link
        }
    }
}
