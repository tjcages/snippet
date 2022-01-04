//
//  SafariPreview.swift
//  natural
//
//  Created by Tyler Cagle on 1/3/22.
//

import SwiftUI

struct SafariPreview: View {
    @ObservedObject var model: WebViewModel
    
    var body: some View {
        //Create a VStack that contains the buttons in a preview as well a the webpage itself
        VStack {
            HStack(alignment: .center) {
                Spacer()
                Spacer()
                //The title of the webpage
                Text(self.model.didFinishLoading ? self.model.pageTitle : "")
                Spacer()
                //The "Open with Safari" button on the top right side of the preview
                Button(action: {
                    if let url = URL(string: self.model.link) {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    Text("Open with Safari")
                }
            }
            //The webpage itself
            SwiftUIWebView(viewModel: model)
        }.frame(width: 800, height: 450, alignment: .bottom)
            .padding(5.0)
    }
}
