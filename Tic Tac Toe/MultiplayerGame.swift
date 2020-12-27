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
        NetworkManager.sharedInstance.reachability.whenReachable = { _ in
            self.removeHelper((self.view.subviews.last! as? NSButton)!)
            self.initiateGame()
        }
        
        NetworkManager.sharedInstance.reachability.whenUnreachable = { _ in
            self.displayInfo()
        }
    }
    
    override func viewDidAppear() {
        NetworkManager.isReachable { _ in
            self.initiateGame()
        }
        
        NetworkManager.isUnreachable { _ in
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.displayInfo()
        }
    }
    
    func displayInfo() {
        let alert = NSAlert()
        alert.messageText = "Info"
        alert.informativeText = "Every player gets a room key, the player that goes second needs to change their room key to the other's and click enter to activate it."
        NetworkManager.isUnreachable { _ in
            alert.informativeText = "Uh-Oh, looks like your internet connection is down. Please try reconnecting so that we can use the online mode."
        }
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Cool, I got my opponent. Let's go!")
        alert.beginSheetModal(for: self.view.window!) { response in
            
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
