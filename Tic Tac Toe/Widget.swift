//
//  Widget.swift
//  Tic Tac Toe
//
//  Created by Ozan Mirza on 7/5/19.
//  Copyright © 2019 Ozan Mirza. All rights reserved.
//

import Cocoa

class Widget: NSView {
    
    var firstMouseDownPoint: NSPoint = NSPoint.zero
    var availableHolders: [NSView]!

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        
        self.wantsLayer = true
        self.layer!.cornerRadius = 15
        self.layer!.backgroundColor = NSColor.lightGray.withAlphaComponent(0.3).cgColor
        
        let letter = NSTextField(frame: NSRect(x: 5, y: 5, width: self.frame.size.width - 10, height: self.frame.size.width - 10))
        letter.isBezeled = false
        letter.isBordered = false
        letter.isEditable = false
        letter.font = NSFont.systemFont(ofSize: 40)
        letter.textColor = NSColor.white
        self.addSubview(letter)
    }
    
    func set(type: TicTacToeBoard.Card, holders: [NSView]) {
        (self.subviews[0] as? NSTextField)?.stringValue = String(describing: type)
        self.availableHolders = holders
    }
    
    override func mouseDown(with event: NSEvent) {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0.5
        self.animator().alphaValue = 0.6
        NSAnimationContext.endGrouping()
        firstMouseDownPoint = (self.window?.contentView?.convert(event.locationInWindow, to: self))!
    }
    
    override func mouseDragged(with event: NSEvent) {
        let newPoint = (self.window?.contentView?.convert(event.locationInWindow, to: self))!
        let offset = NSPoint(x: newPoint.x - firstMouseDownPoint.x, y: newPoint.y - firstMouseDownPoint.y)
        let origin = self.frame.origin
        let size = self.frame.size
        self.frame = NSRect(x: origin.x + offset.x, y: origin.y + offset.y, width: size.width, height: size.height)
    }
    
    override func mouseUp(with event: NSEvent) {
        self.availableHolders.forEach { holder in
            if holder.frame.contains(self.frame.origin) {
                NSAnimationContext.beginGrouping()
                NSAnimationContext.current.duration = 0.5
                self.animator().alphaValue = 1.0
                NSAnimationContext.endGrouping()
            } else {
                NSAnimationContext.beginGrouping()
                NSAnimationContext.current.duration = 0.5
                self.animator().frame.origin = firstMouseDownPoint
                NSAnimationContext.endGrouping()
            }
        }
    }
}
