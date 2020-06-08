//
//  MultiplayerGame.swift
//  Tic Tac Toe
//
//  Created by Ozan Mirza on 7/14/19.
//  Copyright © 2019 Ozan Mirza. All rights reserved.
//

import Cocoa
import WebKit

class MultiplayerGameWindowController: NSWindowController, NSWindowDelegate {
    convenience init() {
        // Creating Standard window
        self.init(window: NSWindow(contentRect: NSRect(x: 0, y: 0, width: 750, height: 755), styleMask: [.titled, .fullSizeContentView, .closable, .miniaturizable], backing: .buffered, defer: false))
        window!.delegate = self // Manipulating the window
        window!.contentViewController = MultiplayerGameViewController() // Content inside window
        // Styling the window
        window!.titleVisibility = .hidden
        window!.titlebarAppearsTransparent = true
        window!.hasShadow = false
        window!.invalidateShadow()
        
        // Customizing properties for interation
        window!.center()
        window!.isMovableByWindowBackground = true
        window!.isOpaque = false
        window!.backgroundColor = NSColor.clear
        
        // Lowering buttons
        let customToolbar = NSToolbar()
        customToolbar.showsBaselineSeparator = false
        window!.toolbar = customToolbar
    }
}

class MultiplayerGameViewController: NSViewController, WKNavigationDelegate {
    
    let gameView = WKWebView(frame: NSRect(x: 0, y: 0, width: 750, height: 725))
    
    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 750, height: 755))
        self.view.wantsLayer = true
        self.view.layer!.backgroundColor = NSColor(red: (59 / 255), green: (72 / 255), blue: (93 / 255), alpha: 1).cgColor
    }
    
    override func viewDidLoad() {
        NetworkManager.isReachable { _ in
            self.initiateGame()
        }
        
        NetworkManager.isUnreachable { _ in
            self.displayInfo()
        }
        
        NetworkManager.sharedInstance.reachability.whenReachable = { _ in
            self.removeHelper((self.view.subviews.last! as? NSButton)!)
            self.initiateGame()
        }
        
        NetworkManager.sharedInstance.reachability.whenUnreachable = { _ in
            self.displayInfo()
        }
    }
    
    func initiateGame() {
        self.gameView.wantsLayer = true
        self.gameView.layer!.backgroundColor = self.view.layer!.backgroundColor!
        self.gameView.load(URLRequest(url: URL(string: "https://rocky-ocean-52527.herokuapp.com/")!))
        self.gameView.allowsMagnification = false
        self.gameView.allowsBackForwardNavigationGestures = false
        self.gameView.navigationDelegate = self
        self.view.addSubview(self.gameView)
        
        self.displayInfo()
    }
    
    func displayInfo() {
        let info = NSButton(frame: self.view.bounds)
        info.isBordered = false
        info.title = ""
        info.wantsLayer = true
        info.layer!.backgroundColor = NSColor.black.withAlphaComponent(0.7).cgColor
        info.action = #selector(self.removeHelper(_:))
        info.alphaValue = 0.0
        self.view.addSubview(info)
        
        let info_container = NSView(frame: NSRect(x: (info.frame.size.width / 2) - 200, y: (info.frame.size.width / 2) - 100, width: 400, height: 200))
        info_container.wantsLayer = true
        info_container.layer!.cornerRadius = 20
        info_container.layer!.backgroundColor = NSColor.black.cgColor
        info_container.layer!.borderColor = NSColor.white.cgColor
        info_container.layer!.borderWidth = 5
        info.addSubview(info_container)
        
        let info_ttl = NSTextField(frame: NSRect(x: 20, y: 10, width: 360, height: 160))
        info_ttl.isBezeled = false
        info_ttl.isBordered = false
        info_ttl.isEditable = false
        info_ttl.drawsBackground = false
        info_ttl.textColor = NSColor.white
        info_ttl.alignment = .center
        info_ttl.font = NSFont.systemFont(ofSize: 25)
        info_ttl.stringValue = "Every player gets a room key, the player that goes second needs to change their room key to the other's and click enter to activate it."
        info_container.addSubview(info_ttl)
        
        NetworkManager.isUnreachable { _ in
            info_ttl.stringValue = "Uh-Oh, looks like your internet connection is down. Please try reconnecting so that we can use the online mode."
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 1.0
            info.animator().alphaValue = 1.0
            NSAnimationContext.endGrouping()
        }
    }
    
    @objc func removeHelper(_ sender: NSButton!) {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 1.0
        sender.animator().alphaValue = 0.0
        NSAnimationContext.endGrouping()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sender.removeFromSuperview()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        gameView.evaluateJavaScript("document.body.style.width = '100%'; document.body.style.height = '100%'; document.body.style.overflow = 'hidden';", completionHandler: nil)
    }
}
