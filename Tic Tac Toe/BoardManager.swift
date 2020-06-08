//
//  BoardManager.swift
//  Tic Tac Toe
//
//  Created by Ozan Mirza on 5/27/19.
//  Copyright © 2019 Ozan Mirza. All rights reserved.
//

import Cocoa
import MultipeerConnectivity

let boardNotifier = NSTextField(frame: NSRect(x: 16, y: 10, width: 318, height: 50))

class BoardManager: NSView {
    
    let mainBoard : TicTacToeBoard = TicTacToeBoard(frame: CGRect(x: 0, y: 86, width: 350, height: 350))
    
    var currentPlayer : Bool = false
    let player = Int.random(in: 0...1)

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        self.addSubview(mainBoard)
        
        self.createDivider()
        self.managePlayers()
        self.renderLbls()
    }
    
    func createDivider() {
        let divider = NSView(frame: NSRect(x: self.frame.size.width / 2, y: 71, width: 0, height: 1))
        divider.wantsLayer = true
        divider.layer!.backgroundColor = NSColor.white.cgColor
        self.addSubview(divider)
        
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 1.0
        divider.animator().frame.size.width = self.frame.size.width
        divider.animator().frame.origin.x = 0
        NSAnimationContext.endGrouping()
    }
    
    func renderLbls() {
        boardNotifier.isBordered = false
        boardNotifier.isBezeled = false
        boardNotifier.isEditable = false
        boardNotifier.drawsBackground = false
        boardNotifier.textColor = NSColor.white
        boardNotifier.alignment = .center
        boardNotifier.font = NSFont.systemFont(ofSize: 25)
        boardNotifier.alphaValue = 0.0
        self.addSubview(boardNotifier)
        
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 1.0
        boardNotifier.animator().alphaValue = 1.0
        NSAnimationContext.endGrouping()
    }
    
    func managePlayers() {
        mainBoard.currentCard = player == 0 ? .O : .X
    }
    
    func manageMultiplayerPlayers() {
        managePlayers()
        mainBoard.userCharacter = player == 0 ? .O : .X
    }
    
    func setLblValue() {
        if mainBoard.currentCard == .O {
            if mainBoard.userCharacter == .O {
                boardNotifier.stringValue = "It's your move"
                mainBoard.enableCells()
            } else {
                boardNotifier.stringValue = "It's the computer's move"
                mainBoard.botNextMove()
            }
        } else {
            if mainBoard.userCharacter == .X {
                boardNotifier.stringValue = "It's your move"
                mainBoard.enableCells()
            } else {
                boardNotifier.stringValue = "It's the computer's move"
                mainBoard.botNextMove()
            }
        }
    }
    
    func setLocalLblValue() {
        if mainBoard.currentCard == .O {
            if mainBoard.userCharacter == .O {
                boardNotifier.stringValue = "It's player 1's move"
            } else {
                boardNotifier.stringValue = "It's player 2's move"
            }
        } else {
            if mainBoard.userCharacter == .X {
                boardNotifier.stringValue = "It's player 1's move"
            } else {
                boardNotifier.stringValue = "It's player 2's move"
            }
        }
    }
    
    func setOnlineLblValue(host: String, guest: String) {
        if mainBoard.currentCard == .O {
            if mainBoard.userCharacter == .O {
                boardNotifier.stringValue = host
            } else {
                boardNotifier.stringValue = guest
            }
        } else {
            if mainBoard.userCharacter == .X {
                boardNotifier.stringValue = host
            } else {
                boardNotifier.stringValue = guest
            }
        }
    }
    
    func changeStatus(to type: TicTacToeBoard.GameType, having mode: TicTacToeBoard.BotLevel?, with names: [MCPeerID]?) {
        mainBoard.type = type
        if type == .Single {
            mainBoard.mode = mode
            managePlayers()
            setLblValue()
        } else if type == .Local {
            manageMultiplayerPlayers()
            setLocalLblValue()
        } else if type == .Online {
            manageMultiplayerPlayers()
            setOnlineLblValue(host: names![0].displayName, guest: names![1].displayName)
        }
    }
}
