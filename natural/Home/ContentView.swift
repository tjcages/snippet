//
//  ContentView.swift
//  natural
//
//  Created by Tyler Cagle on 1/1/22.
//

import SwiftUI
import SystemColors
//import OpenGraph

struct ContentView: View {
  @EnvironmentObject var keyInputSubject: KeyInputSubjectWrapper
  
  @State private var searchText = ""
  @State var addingLink = false
  
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
          if !addingLink {
            ItemList(allData: demoData, addingLink: $addingLink, searchText: $searchText)
          } else {
            AddItem(starterText: searchText, addingLink: $addingLink)
          }
        }
        .padding(0)
    }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
