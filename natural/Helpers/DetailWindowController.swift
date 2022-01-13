//
//  DetailWindowController.swift
//  natural
//
//  Created by Tyler Cagle on 1/2/22.
//

import Cocoa
import SwiftUI

// A class to handle opening windows for posts when doubling clicking the entry
class DetailWindowController<RootView : View>: NSWindowController {
    convenience init(rootView: RootView) {
        let hostingController = NSHostingController(rootView: rootView.frame(width: 300, height: 300))
        let window = NSWindow(contentViewController: hostingController)
        window.setContentSize(NSSize(width: 300, height: 300))
        window.titleVisibility = .hidden
        window.toolbar = nil
        window.styleMask.insert(.fullSizeContentView)
        window.viewsNeedDisplay = true
        self.init(window: window)
    }
}
