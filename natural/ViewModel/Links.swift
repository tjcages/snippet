//
//  Links.swift
//  natural
//
//  Created by Tyler Cagle on 1/2/22.
//

import Foundation

// A struct to store exactly one restaurant's data.
struct Links: Identifiable, Hashable {
    let id: String
    let name: String
    let link: URL?
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.name = dictionary["name"] as! String
        let linkString = dictionary["link"] as! String
        self.link = URL(string: linkString)!
    }
    
    init(name: String, link: String) {
        self.id = "\(UUID())"
        self.name = name
        let linkString = link
        self.link = URL(string: linkString)
    }
}
