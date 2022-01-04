//
//  naturalApp.swift
//  natural
//
//  Created by Tyler Cagle on 1/1/22.
//

import SwiftUI
import Firebase

@main
struct naturalApp: App {
    
    private let keyInputSubject = KeyInputSubjectWrapper()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environmentObject(SessionStore())
                .environmentObject(keyInputSubject)
        }
        .commands {
            CommandMenu("Input") {
                keyInput(.leftArrow)
                keyInput(.rightArrow)
                keyInput(.upArrow)
                keyInput(.downArrow)
                keyInput(.space)
                keyInput(.return)
            }
        }
    }
}

private extension naturalApp {
    func keyInput(_ key: KeyEquivalent, modifiers: EventModifiers = .none) -> some View {
        keyboardShortcut(key, sender: keyInputSubject, modifiers: modifiers)
    }
}
