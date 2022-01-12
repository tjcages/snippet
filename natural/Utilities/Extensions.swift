//
//  Extensions.swift
//  natural
//
//  Created by Tyler Cagle on 1/1/22.
//

import Combine
import SwiftUI
import Introspect

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
}

// This is taken from the Release Notes, with a typo correction, marked below
struct IndexedCollection<Base: RandomAccessCollection>: RandomAccessCollection {
    typealias Index = Base.Index
    typealias Element = (index: Index, element: Base.Element)
    
    let base: Base
    
    var startIndex: Index { base.startIndex }
    
    // corrected typo: base.endIndex, instead of base.startIndex
    var endIndex: Index { base.endIndex }
    
    func index(after i: Index) -> Index {
        base.index(after: i)
    }
    
    func index(before i: Index) -> Index {
        base.index(before: i)
    }
    
    func index(_ i: Index, offsetBy distance: Int) -> Index {
        base.index(i, offsetBy: distance)
    }
    
    subscript(position: Index) -> Element {
        (index: position, element: base[position])
    }
}

extension List {
    /// List on macOS uses an opaque background with no option for
    /// removing/changing it. listRowBackground() doesn't work either.
    /// This workaround works because List is backed by NSTableView.
    func removeBackground() -> some View {
        return introspectTableView { tableView in
            tableView.backgroundColor = .clear
            tableView.enclosingScrollView!.drawsBackground = false
        }
    }
}


extension View {
    func onLongHover(duration: Double, perform action: @escaping (Bool) -> Void) -> some View {
        var timer: Timer?
        var interval: Double = 0.0
        var isHovering = false
        
        func checkHoverState() {
            if isHovering {
                action(true)
                timer?.invalidate()
            }
        }
        
        return self
            .onHover { hovering in
                isHovering = hovering
                if hovering {
                    let startTime = Date()
                    timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                        interval = Date().timeIntervalSince(startTime)
                        if interval >= duration {
                            checkHoverState()
                        } else {
                            action(false)
                        }
                    }
                } else {
                    action(hovering)
                    timer?.invalidate()
                }
            }
    }
}
