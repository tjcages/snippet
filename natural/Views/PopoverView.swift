//
//  PopoverView.swift
//  natural
//
//  Created by Tyler Cagle on 1/3/22.
//

import SwiftUI

struct PopoverView: View {
    @ObservedObject var model: WebViewModel
    
    var item: Links
    
    init(mesgURL: String, item: Links) {
        self.model = WebViewModel(link: mesgURL)
        self.item = item
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SwiftUIWebView(viewModel: model)
                .frame(height: 180, alignment: .top)
                .cornerRadius(8)
                .padding([.horizontal, .top], 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(self.model.didFinishLoading ? self.model.pageTitle != "" ? self.model.pageTitle : item.name : item.name)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(self.model.didFinishLoading ? self.model.link : item.link?.absoluteString ?? "")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding(8)
        }
        .frame(width: 224, alignment: .topLeading)
    }
}
