//
//  ItemList.swift
//  natural
//
//  Created by Tyler Cagle on 1/2/22.
//

import SwiftUI

struct ItemList: View {
    var allData: [Links]
    @Environment(\.openURL) var openURL
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var keyInputSubject: KeyInputSubjectWrapper
    
    @Binding var addingLink: Bool
    @Binding var searchText: String
    
    @State var selectKeeper: Int? = 1
    
    var data: [Links] {
        let queryData = session.links.filter({ link in
            link.name.lowercased().contains(self.searchText.lowercased()) || searchText == ""
        })
        DispatchQueue.main.async {
            self.selectKeeper = 1
        }
        return queryData
    }
    
    func openCurrentLink(_ index: Int) {
        // open selected link
        let item = data[index - 1]
        guard let link = item.link else { return }
        openURL(link)
        NotificationCenter.default.post(name: Notification.Name("WebPageOpened"), object: nil)
    }
    
    func moveActiveTodos(fromOffsets source: IndexSet, toOffset destination: Int) {
        demoData.move(fromOffsets: source, toOffset: destination)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Search(searchText: $searchText) {
                if let index = selectKeeper, data.count > 0 {
                    openCurrentLink(index)
                } else {
                    // no links, open AddLink
                    addingLink.toggle()
                }
            }
            .zIndex(100)
            
            Divider()
                .frame(height: 1)
                .background(Color.white.opacity(0.1))
  
            List {
                ForEach(data.indexed(), id: \.1.self) { index, item in
                    ListItem(index: index + 1, item: item, selectKeeper: $selectKeeper)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .removeBackground()
            .contextMenu {
                Button {
                    if let index = selectKeeper {
                        let id = session.links[index - 1].id
                        session.deleteUserLink(id: id)
                    }
                } label: {
                    Text("Delete item")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.red)
                }
            }
            
            if searchText != "" {
                MainButton(type: .active) {
                    addingLink.toggle()
                }
            } else {
                BottomMenu()
            }
            
            Spacer()
        }
        .onReceive(keyInputSubject) {
            if let index = selectKeeper {
                if $0 == KeyEquivalent.downArrow {
                    // keystroke is down – if there are data items, move selector down
                    if index < data.count {
                        selectKeeper = index + 1
                    }
                } else if $0 == KeyEquivalent.upArrow {
                    // keystroke is up – if there are data items, move selector up
                    if index > 0 {
                        selectKeeper = index - 1
                    }
                }
                //                else if $0 == KeyEquivalent.return {
                //                    // keystroke is return – open link
                //                    if let index = selectKeeper {
                //                        openCurrentLink(index)
                //                    }
                //                }
            }
        }
    }
}

extension RandomAccessCollection {
    func indexed() -> IndexedCollection<Self> {
        IndexedCollection(base: self)
    }
}
