//
//  AppDelegate.swift
//  Tic Tac Toe
//
//  Created by Ozan Mirza on 2/9/19.
//  Copyright © 2019 Ozan Mirza. All rights reserved.
//
//  CREATE APP FOR THE TODO LIST PROCESSING
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        guard let window = NSApplication.shared.windows.first else { return }
        window.isOpaque = false
        window.backgroundColor = .clear
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

