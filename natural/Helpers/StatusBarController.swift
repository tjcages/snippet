//
//  StatusBarController.swift
//  Ambar
//
//  Created by Anagh Sharma on 12/11/19.
//  Copyright © 2019 Anagh Sharma. All rights reserved.
//

// Pulled from https://github.com/WilliamD47/JustClick

import AppKit

class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private var eventMonitor: EventMonitor?
    
    init(_ popover: NSPopover)
    {
        self.popover = popover
        popover.behavior = .transient
        statusBar = NSStatusBar.init()
        statusItem = statusBar.statusItem(withLength: 28.0)
        
        if let statusBarButton = statusItem.button {
            statusBarButton.image = NSImage(imageLiteralResourceName: "StatusBarIcon")
            statusBarButton.image?.size = NSSize(width: 15.0, height: 15.0)
            statusBarButton.image?.isTemplate = true
            
            statusBarButton.action = #selector(togglePopover(sender:))
            statusBarButton.target = self
        }
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: mouseEventHandler)
        eventMonitor = EventMonitor(mask: [.keyDown, .keyUp], handler: keyEventHandler)
        
        // Add a notification if a webpage is opened
        NotificationCenter.default.addObserver(self, selector: #selector(self.hidePopover), name: Notification.Name("WebPageOpened"), object: nil)
    }
    
    @objc func togglePopover(sender: AnyObject) {
        if(popover.isShown) {
            hidePopover(sender)
        }
        else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject) {
        if let statusBarButton = statusItem.button {
            popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
            print("Start")
            eventMonitor?.start()
        }
    }
    
    @objc func hidePopover(_ sender: AnyObject) {
        print("Stop")
        popover.performClose(sender)
        NSApp.sendAction(#selector(NSPopover.performClose(_:)), to: nil, from: nil)
//        eventMonitor?.stop()
    }
    
    func mouseEventHandler(_ event: NSEvent?) {
        hidePopover(event!)
//        if (popover.isShown) {
//            hidePopover(event!)
//        }
    }
    
    func keyEventHandler(_ event: NSEvent?) {
        print(event)
        print(event?.keyCode)
    }
}
