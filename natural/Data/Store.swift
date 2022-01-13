//
//  Store.swift
//  natural
//
//  Created by Tyler Cagle on 1/2/22.
//

import SwiftUI
import Firebase
import Combine
import FirebaseFirestore

class SessionStore: ObservableObject {
    
    @Published var links: [Links] = []
    
    var db: Firestore
    
    var didChange = PassthroughSubject<SessionStore, Never>()
    var session: User? { didSet { self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        // Configure the Firestore database
        FirebaseApp.configure()
        
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
                
        db = Firestore.firestore()
        db.settings = settings
        
        // Add a notification if a webpage is opened
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadStore), name: Notification.Name("ViewDidAppear"), object: nil)
    }
    
    @objc func loadStore() {
        if session != nil {
            listen()
        } else {
            signInAnonymously()
        }
    }
    
    func listen () {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                self.session = User(
                    uid: user.uid
                )
                
                if self.links.count == 0 {
                    self.getUserLinks()
                }
            } else {
                // if we don't have a user, set our session to nil
                self.session = nil
            }
        }
    }
    
    func signInAnonymously() {
        Auth.auth().signInAnonymously { authResult, error in
            if let err = error {
                print(err.localizedDescription)
            }
            guard let user = authResult?.user else { return }
            //            let isAnonymous = user.isAnonymous  // true
            
            self.session = User(
                uid: user.uid
            )
            
            self.getUserLinks()
        }
    }
    
    func signOut () -> Bool {
        do {
            try Auth.auth().signOut()
            self.session = nil
            return true
        } catch {
            return false
        }
    }
    
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func addLink(name: String, link: String) {
        guard let currentUser = session else { return print("No luck chuck") }
        let ref = db.collection("links").document()
        let data = [
            "name": name,
            "link": link,
            "created_by": currentUser.uid,
            "created_at": Timestamp(date: Date())
        ] as [String : Any]
        ref.setData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                let link = Links(id: ref.documentID, dictionary: data)
                self.links.insert(link, at: 0)
            }
        }
    }
    
    func getUserLinks() {
        guard let currentUser = session else { return print("No luck chuck") }
        db.collection("links").whereField("created_by", isEqualTo: currentUser.uid).order(by: "created_at", descending: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let link = Links(id: document.documentID, dictionary: document.data())
                        self.links.append(link)
                    }
                }
            }
    }
    
    func deleteUserLink(id: String) {
        db.collection("links").document(id).delete() { err in
            if let err = err {
                print("Error deleting document: \(err)")
            } else {
                let filtered = self.links.filter { link in
                    link.id != id
                }
                self.links = filtered
            }
        }
    }
}
