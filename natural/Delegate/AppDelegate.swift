//
//  AppDelegate.swift
//  natural
//
//  Created by Tyler Cagle on 1/11/22.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    
    private var window: NSWindow!
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private let keyInputSubject = KeyInputSubjectWrapper()
    
    @MainActor func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the window and set the content view.
        let contentView = ContentView().environmentObject(SessionStore()).environmentObject(keyInputSubject)
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.contentView?.postsFrameChangedNotifications = true
        window.makeKeyAndOrderFront(self)
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let statusButton = statusItem.button {
            statusButton.image = NSImage(imageLiteralResourceName: "StatusBarIcon")
            statusButton.image?.size = NSSize(width: 15.0, height: 15.0)
            statusButton.image?.isTemplate = true
            statusButton.action = #selector(togglePopover)
            statusButton.target = self
        }
        
        popover = NSPopover()
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 324, height: 400)
        
        popover.contentViewController = NSHostingController(rootView: contentView)
    }
    
    @objc func togglePopover() {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.maxY)
            }
        }
    }
}


//@NSApplicationMain
//class AppDelegate: NSObject, NSApplicationDelegate {
//    var popover = NSPopover.init()
//    var statusBar: StatusBarController?
//    private let keyInputSubject = KeyInputSubjectWrapper()
//
//    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        // Create the SwiftUI view that provides the contents
//        let contentView = ContentView().environmentObject(SessionStore()).environmentObject(keyInputSubject)
//
//        // Set the SwiftUI's ContentView to the Popover's ContentViewController
//        popover.contentViewController = MainViewController()
//        popover.contentSize = NSSize(width: 324, height: 400)
//        DispatchQueue.main.async {
//            self.popover.contentViewController?.view = NSHostingView(rootView: contentView)
//
//            // Create the Status Bar Item with the Popover
//            self.statusBar = StatusBarController.init(self.popover)
//        }
//
//        let application = NSApplication.shared
//        application.presentationOptions = .autoHideMenuBar
//    }
//
//    func applicationWillTerminate(_ aNotification: Notification) {
//        // Insert code here to tear down your application
//    }
//}
