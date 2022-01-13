//
//  AppDelegate.swift
//  natural
//
//  Created by Tyler Cagle on 1/11/22.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var popover = NSPopover.init()
    var statusBar: StatusBarController?
    private let keyInputSubject = KeyInputSubjectWrapper()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the contents
        let contentView = ContentView().environmentObject(SessionStore()).environmentObject(keyInputSubject)
        
        // Set the SwiftUI's ContentView to the Popover's ContentViewController
        popover.contentViewController = MainViewController()
        popover.contentSize = NSSize(width: 324, height: 400)
        DispatchQueue.main.async {
            self.popover.contentViewController?.view = NSHostingView(rootView: contentView)
            
            // Create the Status Bar Item with the Popover
            self.statusBar = StatusBarController.init(self.popover)
        }
        
        let application = NSApplication.shared
        application.presentationOptions = .autoHideMenuBar
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
