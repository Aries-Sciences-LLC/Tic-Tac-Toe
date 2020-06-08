//
//  ViewController.swift
//  Tic Tac Toe
//
//  Created by Ozan Mirza on 2/9/19.
//  Copyright © 2019 Ozan Mirza. All rights reserved.
//

import Cocoa
import WebKit

enum DataType: UInt32 {
    case message = 1
    case image = 2
}

class ViewController: NSViewController {
    
    @IBOutlet weak var multPlayerActivator: NSButton!
    @IBOutlet weak var singlePlayerActivator: NSButton!
    @IBOutlet weak var singlePlayerBtn: NSView!
    @IBOutlet weak var multiplayerBtn: NSView!
    @IBOutlet weak var singlePlayerTtl: NSButton!
    @IBOutlet weak var multiPlayerTtl: NSButton!
    @IBOutlet weak var backBtn: NSButton!
    @IBOutlet weak var expertModeBtn: NSButton!
    @IBOutlet weak var experiencedModeBtn: NSButton!
    @IBOutlet weak var beginnerModeBtn: NSButton!
    @IBOutlet weak var Tic_Tac_Toe_Board: BoardManager!
    @IBOutlet weak var main_title: NSTextField!
    @IBOutlet weak var oSelector: NSButton!
    @IBOutlet weak var xSelector: NSButton!
    @IBOutlet weak var highlighter: NSView!
    @IBOutlet weak var selectCharacter: NSButton!
    @IBOutlet weak var local_multiplayer: NSButton!
    @IBOutlet weak var peer_multiplayer: NSButton!
    @IBOutlet weak var local_mutiplayer_ttl: NSButton!
    @IBOutlet weak var online_multiplayer_ttl: NSButton!
    @IBOutlet weak var localHeader: NSView!
    
    var state : String = "Opening View"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for subview in view.subviews {
            if (subview as? NSButton) != nil {
                (subview as? NSButton)!.sound = NSSound(named: NSSound.Name("Pop"))
            }
        }
        
        backBtn.frame.origin.x = 0 - backBtn.frame.size.width
        backBtn.wantsLayer = true
        backBtn.layer?.backgroundColor = NSColor.black.cgColor
        backBtn.layer?.borderColor = NSColor.white.cgColor
        backBtn.layer?.borderWidth = 5
        backBtn.layer?.cornerRadius = backBtn.frame.size.height / 2
        backBtn.layer?.masksToBounds = true
        
        singlePlayerBtn.frame.origin.x = 0 - singlePlayerBtn.frame.size.width
        multiplayerBtn.frame.origin.x = self.view.frame.size.width
        local_multiplayer.frame.origin.x = 0 - local_multiplayer.frame.size.width
        peer_multiplayer.frame.origin.x = self.view.frame.size.width
        
        singlePlayerBtn.wantsLayer = true
        multiplayerBtn.wantsLayer = true
        local_multiplayer.wantsLayer = true
        peer_multiplayer.wantsLayer = true
        
        singlePlayerBtn.layer?.backgroundColor = NSColor.black.cgColor
        multiplayerBtn.layer?.backgroundColor = NSColor.black.cgColor
        local_multiplayer.layer!.backgroundColor = NSColor.black.cgColor
        peer_multiplayer.layer!.backgroundColor = NSColor.black.cgColor
        
        singlePlayerBtn.layer?.cornerRadius = 25
        multiplayerBtn.layer?.cornerRadius = 25
        local_multiplayer.layer!.cornerRadius = 25
        peer_multiplayer.layer!.cornerRadius = 25
        
        singlePlayerBtn.layer?.borderColor = NSColor.white.cgColor
        multiplayerBtn.layer?.borderColor = NSColor.white.cgColor
        local_multiplayer.layer!.borderColor = NSColor.white.cgColor
        peer_multiplayer.layer!.borderColor = NSColor.white.cgColor
        
        singlePlayerBtn.layer?.borderWidth = 5
        multiplayerBtn.layer?.borderWidth = 5
        local_multiplayer.layer!.borderWidth = 5
        peer_multiplayer.layer!.borderWidth = 5
        
        singlePlayerTtl.frame.origin.x = 0 - singlePlayerTtl.frame.size.width
        multiPlayerTtl.frame.origin.x = self.view.frame.size.width
        local_mutiplayer_ttl.frame.origin.x = 0 - local_mutiplayer_ttl.frame.size.width
        online_multiplayer_ttl.frame.origin.x = self.view.frame.size.width
        
        singlePlayerTtl.wantsLayer = true
        multiPlayerTtl.wantsLayer = true
        local_mutiplayer_ttl.wantsLayer = true
        online_multiplayer_ttl.wantsLayer = true
        
        singlePlayerTtl.layer?.backgroundColor = NSColor.white.cgColor
        multiPlayerTtl.layer?.backgroundColor = NSColor.white.cgColor
        local_mutiplayer_ttl.layer!.backgroundColor = NSColor.white.cgColor
        online_multiplayer_ttl.layer!.backgroundColor = NSColor.white.cgColor
        
        singlePlayerTtl.layer?.cornerRadius = singlePlayerTtl.frame.size.height / 2
        multiPlayerTtl.layer?.cornerRadius = multiPlayerTtl.frame.size.height / 2
        local_mutiplayer_ttl.layer!.cornerRadius = local_mutiplayer_ttl.frame.size.height / 2
        online_multiplayer_ttl.layer!.cornerRadius = online_multiplayer_ttl.frame.size.height / 2
        
        local_mutiplayer_ttl.action = #selector(createLocalGame(_:))
        online_multiplayer_ttl.action = #selector(createOnlineGame(_:))
        
        singlePlayerActivator.frame.origin.x = singlePlayerBtn.frame.origin.x
        multPlayerActivator.frame.origin.x = multiplayerBtn.frame.origin.x
        
        expertModeBtn.wantsLayer = true
        experiencedModeBtn.wantsLayer = true
        beginnerModeBtn.wantsLayer = true
        
        expertModeBtn.layer?.backgroundColor = NSColor.black.cgColor
        experiencedModeBtn.layer?.backgroundColor = NSColor.black.cgColor
        beginnerModeBtn.layer?.backgroundColor = NSColor.black.cgColor
        
        expertModeBtn.layer?.borderColor = NSColor.white.cgColor
        experiencedModeBtn.layer?.borderColor = NSColor.white.cgColor
        beginnerModeBtn.layer?.borderColor = NSColor.white.cgColor
        
        expertModeBtn.layer?.borderWidth = 5
        experiencedModeBtn.layer?.borderWidth = 5
        beginnerModeBtn.layer?.borderWidth = 5
        
        expertModeBtn.layer?.cornerRadius = expertModeBtn.frame.size.height / 2
        experiencedModeBtn.layer?.cornerRadius = experiencedModeBtn.frame.size.height / 2
        beginnerModeBtn.layer?.cornerRadius = beginnerModeBtn.frame.size.height / 2
        
        expertModeBtn.layer?.masksToBounds = true
        experiencedModeBtn.layer?.masksToBounds = true
        beginnerModeBtn.layer?.masksToBounds = true
        
        expertModeBtn.frame.origin.y = -50
        experiencedModeBtn.frame.origin.y = -50
        beginnerModeBtn.frame.origin.y = -50
        
        Tic_Tac_Toe_Board.alphaValue = 0
        main_title.alphaValue = 0
        
        oSelector.frame.origin.y = 0 - oSelector.frame.size.height
        xSelector.frame.origin.y = 0 - xSelector.frame.size.height
        
        highlighter.wantsLayer = true
        highlighter.layer!.backgroundColor = NSColor.black.cgColor
        highlighter.layer!.cornerRadius = 20
        highlighter.alphaValue = 0.0
        highlighter.layer!.borderColor = NSColor.white.cgColor
        highlighter.layer!.borderWidth = 5
        
        selectCharacter.wantsLayer = true
        selectCharacter.layer!.cornerRadius = selectCharacter.frame.size.height / 2
        selectCharacter.layer!.backgroundColor = NSColor.black.cgColor
        selectCharacter.frame.origin.x = 0 - selectCharacter.frame.size.width
        selectCharacter.layer!.borderColor = NSColor.white.cgColor
        selectCharacter.layer!.borderWidth = 5
        
        localHeader.alphaValue = 0.0
        
        Tic_Tac_Toe_Board.mainBoard.winCallback = { winner in
            let bg = NSButton(frame: self.view.bounds)
            bg.alphaValue = 0.0
            bg.wantsLayer = true
            bg.isBordered = false
            bg.isTransparent = false
            bg.target = self
            bg.title = ""
            bg.layer!.backgroundColor = NSColor.black.withAlphaComponent(0.6).cgColor
            self.view.addSubview(bg)
            
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 1.0
            bg.animator().alphaValue = 1.0
            NSAnimationContext.endGrouping()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                bg.action = #selector(self.dismissWinner(_:))
            })
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                let animation = NSImageView(frame: bg.bounds)
                animation.frame.origin.y = self.view.frame.size.height
                animation.image = NSImage(byReferencing: URL(string: "https://media.giphy.com/media/xT9IgMgdur6larNA1a/giphy.gif")!)
                animation.canDrawConcurrently = true
                animation.canDrawSubviewsIntoLayer = true
                animation.animates = true
                animation.imageScaling = NSImageScaling.scaleAxesIndependently
                bg.addSubview(animation)
                
                let ttl = NSTextField(frame: NSRect(x: 20, y: (self.view.frame.size.height / 2) - 50, width: self.view.frame.size.width - 40, height: 75))
                ttl.textColor = NSColor.white
                ttl.stringValue = winner
                ttl.alphaValue = 0.0
                ttl.isBezeled = false
                ttl.isBordered = false
                ttl.isEditable = false
                ttl.drawsBackground = false
                ttl.font = NSFont.systemFont(ofSize: 60)
                ttl.alignment = .center
                bg.addSubview(ttl)
                
                NSAnimationContext.beginGrouping()
                NSAnimationContext.current.duration = 1.0
                animation.animator().frame.origin.y = 0
                ttl.animator().alphaValue = 1.0
                ttl.animator().frame.origin.y += 25
                NSAnimationContext.endGrouping()
                
                if winner == "Computer Wins!" {
                    NSSound(named: "FAIL SOUND EFFECT")?.play()
                } else {
                    NSSound(named: "Yay")?.play()
                }
            })
        }
    }
    
    override func viewDidAppear() {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 1
        main_title.animator().alphaValue = 1
        singlePlayerBtn.animator().frame = CGRect(x: 88, y: 139, width: 200, height: 200)
        multiplayerBtn.animator().frame = CGRect(x: self.view.frame.size.width - 288, y: 139, width: 200, height: 200)
        singlePlayerTtl.animator().frame.origin.x = singlePlayerBtn.frame.origin.x
        multiPlayerTtl.animator().frame.origin.x = multiplayerBtn.frame.origin.x
        singlePlayerTtl.animator().frame.origin.y = singlePlayerBtn.frame.origin.y - 30
        multiPlayerTtl.animator().frame.origin.y = multiplayerBtn.frame.origin.y - 30
        singlePlayerActivator.frame.origin.x = singlePlayerBtn.frame.origin.x
        multPlayerActivator.frame.origin.x = multiplayerBtn.frame.origin.x
        NSAnimationContext.endGrouping()
    }
    @IBAction func activateSinglePlayerMode(_ sender: NSButton) {
        state = "CharacterSelection"
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 1
        singlePlayerBtn.animator().frame.origin.x = 0 - singlePlayerBtn.frame.size.width
        multiplayerBtn.animator().frame.origin.x = self.view.frame.size.width
        singlePlayerTtl.animator().frame.origin.x = singlePlayerBtn.frame.origin.x
        multiPlayerTtl.animator().frame.origin.x = multiplayerBtn.frame.origin.x
        singlePlayerTtl.animator().frame.origin.y = singlePlayerBtn.frame.origin.y - 30
        multiPlayerTtl.animator().frame.origin.y = multiplayerBtn.frame.origin.y - 30
        singlePlayerActivator.frame.origin.x = singlePlayerBtn.frame.origin.x
        multPlayerActivator.frame.origin.x = multiplayerBtn.frame.origin.x
        backBtn.animator().frame.origin.x = -25
        oSelector.animator().frame.origin.y = 200
        xSelector.animator().frame.origin.y = 200
        highlighter.animator().alphaValue = 1.0
        selectCharacter.animator().frame.origin.x = (self.view.frame.size.width / 2) - 125
        NSAnimationContext.endGrouping()
    }
    @IBAction func activateMultiPlayerMode(_ sender: NSButton) {
        state = "MultiPlayerSelector"
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 1
        singlePlayerBtn.animator().frame.origin.x = 0 - singlePlayerBtn.frame.size.width
        multiplayerBtn.animator().frame.origin.x = self.view.frame.size.width
        singlePlayerTtl.animator().frame.origin.x = singlePlayerBtn.frame.origin.x
        multiPlayerTtl.animator().frame.origin.x = multiplayerBtn.frame.origin.x
        singlePlayerTtl.animator().frame.origin.y = singlePlayerBtn.frame.origin.y - 30
        multiPlayerTtl.animator().frame.origin.y = multiplayerBtn.frame.origin.y - 30
        singlePlayerActivator.frame.origin.x = singlePlayerBtn.frame.origin.x
        multPlayerActivator.frame.origin.x = multiplayerBtn.frame.origin.x
        backBtn.animator().frame.origin.x = -25
        showMultiplayerMenu()
        NSAnimationContext.endGrouping()
    }
    @IBAction func beginSinglePlayer(_ sender: NSButton) {
        self.activateSinglePlayerMode(sender)
    }
    @IBAction func beginMultiPlayer(_ sender: NSButton) {
        self.activateMultiPlayerMode(sender)
    }
    @IBAction func reutrnToPreviousView(_ sender: Any) {
        if state == "CharacterSelection" || state == "MultiPlayerSelector" {
            state = "Opening View"
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 1
            singlePlayerBtn.animator().frame = CGRect(x: 88, y: 139, width: 200, height: 200)
            multiplayerBtn.animator().frame = CGRect(x: self.view.frame.size.width - 288, y: 139, width: 200, height: 200)
            singlePlayerTtl.animator().frame.origin.x = singlePlayerBtn.frame.origin.x
            multiPlayerTtl.animator().frame.origin.x = multiplayerBtn.frame.origin.x
            singlePlayerTtl.animator().frame.origin.y = singlePlayerBtn.frame.origin.y - 30
            multiPlayerTtl.animator().frame.origin.y = multiplayerBtn.frame.origin.y - 30
            singlePlayerActivator.frame.origin.x = singlePlayerBtn.frame.origin.x
            multPlayerActivator.frame.origin.x = multiplayerBtn.frame.origin.x
            backBtn.animator().frame.origin.x = 0 - backBtn.frame.size.width
            highlighter.animator().alphaValue = 0.0
            oSelector.animator().frame.origin.y = 0 - oSelector.frame.size.height
            xSelector.animator().frame.origin.y = 0 - xSelector.frame.size.height
            selectCharacter.animator().frame.origin.x = 0 - selectCharacter.frame.size.width
            NSAnimationContext.endGrouping()
            dismissMultiplayerMenu()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.local_mutiplayer_ttl.frame.origin.y += 60
                self.online_multiplayer_ttl.frame.origin.y += 60
            }
        } else if state == "SinglePlayerGame" {
            state = "SinglePlayerModes"
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 1
            Tic_Tac_Toe_Board.animator().alphaValue = 0
            expertModeBtn.animator().frame.origin.y = 350
            experiencedModeBtn.animator().frame.origin.y = 250
            beginnerModeBtn.animator().frame.origin.y = 150
            NSAnimationContext.endGrouping()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.Tic_Tac_Toe_Board.mainBoard.reset()
            }
        } else if state == "SinglePlayerModes" {
            state = "CharacterSelection"
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 1
            self.beginnerModeBtn.animator().frame.origin.y = -50
            self.experiencedModeBtn.animator().frame.origin.y = -50
            self.expertModeBtn.animator().frame.origin.y = -50
            oSelector.animator().frame.origin.y = 200
            xSelector.animator().frame.origin.y = 200
            highlighter.animator().alphaValue = 1.0
            selectCharacter.animator().frame.origin.x = (self.view.frame.size.width / 2) - 125
            NSAnimationContext.endGrouping()
        } else if state == "OnlineMultiplayerName" {
            state = "MultiPlayerSelector"
            showMultiplayerMenu()
        } else if state == "LocalMultiplayerNames" {
            state = "MultiPlayerSelector"
            showMultiplayerMenu()
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 1.0
            Tic_Tac_Toe_Board.animator().alphaValue = 0.0
            NSAnimationContext.endGrouping()
            self.Tic_Tac_Toe_Board.mainBoard.disableCells()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.Tic_Tac_Toe_Board.mainBoard.reset()
            }
        }
    }
    
    @IBAction func expertModeActivated(_ sender: NSButton) {
        state = "SinglePlayerGame"
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 1
        expertModeBtn.animator().frame.origin.y = -50
        experiencedModeBtn.animator().frame.origin.y = -50
        beginnerModeBtn.animator().frame.origin.y = -50
        Tic_Tac_Toe_Board.animator().alphaValue = 1
        NSAnimationContext.endGrouping()
        Tic_Tac_Toe_Board.changeStatus(to: .Single, having: .Expert, with: nil)
    }
    @IBAction func experiencedModeActivated(_ sender: NSButton) {
        state = "SinglePlayerGame"
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 1
        expertModeBtn.animator().frame.origin.y = -50
        experiencedModeBtn.animator().frame.origin.y = -50
        beginnerModeBtn.animator().frame.origin.y = -50
        Tic_Tac_Toe_Board.animator().alphaValue = 1
        NSAnimationContext.endGrouping()
        Tic_Tac_Toe_Board.changeStatus(to: .Single, having: .Experienced, with: nil)
    }
    @IBAction func beginnerModeActivated(_ sender: NSButton) {
        state = "SinglePlayerGame"
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 1
        expertModeBtn.animator().frame.origin.y = -50
        experiencedModeBtn.animator().frame.origin.y = -50
        beginnerModeBtn.animator().frame.origin.y = -50
        Tic_Tac_Toe_Board.animator().alphaValue = 1
        NSAnimationContext.endGrouping()
        Tic_Tac_Toe_Board.changeStatus(to: .Single, having: .Beginner, with: nil)
    }
    
    @IBAction func selectX(_ sender: NSButton!) {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 1.0
        highlighter.animator().frame.origin.x = sender.frame.origin.x
        NSAnimationContext.endGrouping()
    }
    
    @IBAction func selectO(_ sender: NSButton!) {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 1.0
        highlighter.animator().frame.origin.x = sender.frame.origin.x
        NSAnimationContext.endGrouping()
    }
    
    @IBAction func setSelector(_ sender: NSButton!) {
        state = "SinglePlayerModes"
        Tic_Tac_Toe_Board.mainBoard.userCharacter = highlighter.frame.origin.x == oSelector.frame.origin.x ? .O : .X
        
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 1.0
        highlighter.animator().alphaValue = 0.0
        oSelector.animator().frame.origin.y = self.view.frame.size.height + oSelector.frame.size.height
        xSelector.animator().frame.origin.y = self.view.frame.size.height + xSelector.frame.size.height
        sender.animator().frame.origin.x = self.view.frame.size.width
        NSAnimationContext.endGrouping()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 1.0
            self.beginnerModeBtn.animator().frame.origin.y = 350
            self.experiencedModeBtn.animator().frame.origin.y = 250
            self.expertModeBtn.animator().frame.origin.y = 150
            NSAnimationContext.endGrouping()
        }
    }
    
    @IBAction func createLocalGame(_ sender: NSButton) {
        state = "LocalMultiplayerNames"
        dismissMultiplayerMenu()
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 1.0
        localHeader.animator().alphaValue = 1.0
        NSAnimationContext.endGrouping()
        Tic_Tac_Toe_Board.changeStatus(to: .Local, having: nil, with: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 1.0
            self.localHeader.animator().alphaValue = 0.0
            self.Tic_Tac_Toe_Board.animator().alphaValue = 1.0
            NSAnimationContext.endGrouping()
            self.Tic_Tac_Toe_Board.mainBoard.enableCells()
        }
    }
    
    @IBAction func createOnlineGame(_ sender: NSButton) {
        state = "OnlineMultiplayerName"
        dismissMultiplayerMenu()
        MultiplayerGameWindowController().showWindow(self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.reutrnToPreviousView(self.backBtn)
        }
    }
    
    func dismissMultiplayerMenu() {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 1.0
        local_multiplayer.animator().frame.origin.x = 0 - local_multiplayer.frame.size.width
        peer_multiplayer.animator().frame.origin.x = self.view.frame.size.width
        local_multiplayer.animator().frame.origin.y += 31
        peer_multiplayer.animator().frame.origin.y += 31
        local_mutiplayer_ttl.animator().frame.origin.x = 0 - local_mutiplayer_ttl.frame.size.width
        online_multiplayer_ttl.animator().frame.origin.x = self.view.frame.size.width
        local_mutiplayer_ttl.animator().frame.origin.y += 30
        online_multiplayer_ttl.animator().frame.origin.y += 30
        NSAnimationContext.endGrouping()
    }
    
    func showMultiplayerMenu() {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 1.0
        local_multiplayer.animator().frame.origin.x = (self.view.frame.size.width / 2) - 250
        local_multiplayer.animator().frame.origin.y -= 31
        peer_multiplayer.animator().frame.origin.x = (self.view.frame.size.width / 2) + 50
        peer_multiplayer.animator().frame.origin.y -= 31
        local_mutiplayer_ttl.animator().frame.origin.x = (self.view.frame.size.width / 2) - 250
        online_multiplayer_ttl.animator().frame.origin.x = (self.view.frame.size.width / 2) + 50
        self.local_mutiplayer_ttl.animator().frame.origin.y = self.local_multiplayer.frame.origin.y - 30
        self.online_multiplayer_ttl.animator().frame.origin.y = self.peer_multiplayer.frame.origin.y - 30
        self.local_mutiplayer_ttl.animator().frame.origin.x = self.local_multiplayer.frame.origin.x
        self.online_multiplayer_ttl.animator().frame.origin.x = self.peer_multiplayer.frame.origin.x
        NSAnimationContext.endGrouping()
    }
    
    @objc func dismissWinner(_ sender: NSButton!) {
        Tic_Tac_Toe_Board.mainBoard.reset()
        
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 1.0
        sender.animator().alphaValue = 0.0
        NSAnimationContext.endGrouping()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            sender.removeFromSuperview()
            
            self.reutrnToPreviousView(sender)
        }
    }
}
