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
  @EnvironmentObject var session: SessionStore
  @EnvironmentObject var keyInputSubject: KeyInputSubjectWrapper
  
  @State private var searchText = ""
  @State var addingLink = false
  
  func signInUser() {
    session.signInAnonymously()
  }
  
  func getUser () {
    session.listen()
  }
  
  var body: some View {
    NavigationView {
      VStack(alignment: .leading, spacing: 0) {
        if !addingLink {
          ItemList(allData: demoData, addingLink: $addingLink, searchText: $searchText)
        } else {
          AddItem(starterText: searchText, addingLink: $addingLink)
        }
      }
      .frame(minWidth: 324, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
    }
    .navigationTitle("")
    .frame(width: 324, height: 400, alignment: .bottom)
    .onAppear {
      if session.session != nil {
//        print("SESSIOn")
//        print(session.session)
        getUser()
      } else {
        signInUser()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
