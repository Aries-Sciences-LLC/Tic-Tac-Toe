//
//  TicTacToeBoard.swift
//  Tic Tac Toe
//
//  Created by Ozan Mirza on 2/10/19.
//  Copyright © 2019 Ozan Mirza. All rights reserved.
//
//  TODO:
//    -- Set Up singleplayer algorithim

import Cocoa

@IBDesignable public class TicTacToeBoard: NSView {
    
    public enum GameType {
        case Single, Local, Online
    }
    
    public enum Card {
        case O, X
    }
    
    public enum BotLevel {
        case Beginner, Experienced, Expert
    }
    
    public enum WinState {
        case Vertical, Horizontal, MajorDiagonal, MinorDiagonal
    }
    
    let cellsPerRow = 3
    let dividerWidthGuide: CGFloat = 0.02   // guideline % of gameBoardLength
    
    var cellWidth: CGFloat!
    var cellHeight: CGFloat!
    var dividerWidth: CGFloat!
    
    var cells : [Cell] = []
    var plays : [Player] = []
    var sections : [[Player?]] = [[nil, nil, nil],
                                 [nil, nil, nil],
                                 [nil, nil, nil]]
    
    var currentCard : Card!
    var userCharacter : Card!
    
    var winCallback : (String) -> Void = { winner in }
    
    var type: GameType?
    var mode: BotLevel?
    var winLevel: Int?
    
    override public func draw(_ rect: NSRect) {
        super.draw(rect)
        NSColor.white.setFill()
        setUpGameBoardCells()
        displayDividers()
        activateBtns()
    }
    
    func setUpGameBoardCells() {
        let gameBoardLength = min(bounds.size.height, bounds.size.width)
        dividerWidth = round(gameBoardLength * dividerWidthGuide)
        let cellsTotalWidth: Int = Int(gameBoardLength) - Int(dividerWidth) * (cellsPerRow - 1)
        let dividerWidthFudge: CGFloat = (cellsTotalWidth % cellsPerRow == 1 ? -1 : (cellsTotalWidth % cellsPerRow == 2 ? 1 : 0))
        dividerWidth! += dividerWidthFudge
        cellWidth = CGFloat((cellsTotalWidth - Int(dividerWidthFudge) * (cellsPerRow - 1)) / cellsPerRow)
    }
    
    func displayDividers() {
        var divider = NSBezierPath(rect: CGRect(x: cellWidth, y: 0, width: dividerWidth, height: bounds.size.height))
        divider.lineWidth = 1
        divider.lineCapStyle = NSBezierPath.LineCapStyle.round
        divider.fill()
        
        divider = NSBezierPath(rect: CGRect(x: cellWidth * 2 + dividerWidth, y: 0, width: dividerWidth, height: bounds.size.height))
        divider.lineWidth = 1
        divider.lineCapStyle = NSBezierPath.LineCapStyle.round
        divider.fill()
        
        divider = NSBezierPath(rect: CGRect(x: 0, y: cellWidth * 2 + dividerWidth, width: self.frame.width, height: dividerWidth))
        divider.lineWidth = 1
        divider.lineCapStyle = NSBezierPath.LineCapStyle.round
        divider.fill()
        
        divider = NSBezierPath(rect: CGRect(x: 0, y: cellWidth, width: self.frame.width, height: dividerWidth))
        divider.lineWidth = 1
        divider.lineCapStyle = NSBezierPath.LineCapStyle.round
        divider.fill()
    }
    
    func activateBtns() {
        for row in 0..<LocationManager.matrix.count {
            for col in 0..<LocationManager.matrix[row].count {
                let btn = NSButton(frame: LocationManager.matrix[row][col].frame)
                btn.isBordered = false
                btn.isTransparent = false
                btn.title = ""
                btn.target = self
                btn.action = #selector(setValueForSpace(_:))
                btn.sound = NSSound(named: NSSound.Name("Pop"))
                self.addSubview(btn)
                
                cells.append(Cell(row: row, col: col, btn: btn))
            }
        }
        
        disableCells()
    }
    
    @objc func setValueForSpace(_ sender: NSButton!) {
        sender.isEnabled = false
        if type == .Single {
            if checkForWin() == nil {
                self.dismissBoardNotifier()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    for cell in self.cells {
                        if cell.btn == sender {
                            boardNotifier.stringValue = self.currentCard == self.userCharacter ? "It's the computer's move" : "It's your move"
                            self.addCharacterToBoard(with: self.currentCard, at: LocationManager.matrix[cell.row][cell.col], for: cell)
                            if self.currentCard != self.userCharacter {
                                self.disableCells()
                                self.botNextMove()
                            } else {
                                self.enableCells()
                            }
                        }
                    }
                    
                    self.presentBoardNotifier()
                    
                    if self.checkForWin() != nil {
                        self.strikeThroughWin(with: self.checkForWin()!)
                        self.winCallback(boardNotifier.stringValue == "It's your move" ? "Computer Wins!" : "You Win! :)")
                    } else {
                        if self.sectionsAreFull() {
                            self.winCallback("Draw!")
                        }
                    }
                }
            }
        } else if type == .Local {
            if checkForWin() == nil {
                self.dismissBoardNotifier()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    for cell in self.cells {
                        if cell.btn == sender {
                            boardNotifier.stringValue = self.currentCard == self.userCharacter ? "It's player 2's move" : "It's player 1's move"
                            self.addCharacterToBoard(with: self.currentCard, at: LocationManager.matrix[cell.row][cell.col], for: cell)
                        }
                    }
                    
                    self.presentBoardNotifier()
                    
                    if (self.checkForWin() != nil) {
                        self.strikeThroughWin(with: self.checkForWin()!)
                        self.winCallback("Player \(boardNotifier.stringValue[12] == "1" ? 2 : 1) wins!!")
                    } else {
                        if self.sectionsAreFull() {
                            self.winCallback("Draw!")
                        }
                    }
                }
            }
        } else if type == .Online {
            
        }
    }
    
    @objc func reset() {
        for subview in subviews {
            if (subview as? NSButton) == nil {
                subview.removeFromSuperview()
            }
        }
        
        sections = [[nil, nil, nil],
                    [nil, nil, nil],
                    [nil, nil, nil]]
        
        plays = []
    }
    
    func addCharacterToBoard(with character: Card, at location: Location, for cell: Cell) {
        self.addSubview(character == .O ? O.draw(location: location) : X.draw(location: location))
        self.plays.append(Player(type: character == .O ? .O : .X, location: location))
        self.sections[cell.row][cell.col] = Player(type: character == .O ? .O : .X, location: location)
        self.currentCard = character == .O ? .X : .O
    }
    
    func botNextMove() {
        if self.plays.count != 9 {
            if mode == .Beginner {
                setValueForSpace(findRandomSpot())
            } else if mode == .Experienced {
                setValueForSpace(AI())
            } else if mode == .Expert {
                setValueForSpace(AI())
            }
            NSSound(named: NSSound.Name("Pop"))!.play()
        }
    }
    
    func sectionsAreFull() -> Bool {
        for i in 0..<sections.count {
            for j in 0..<sections[i].count {
                if sections[i][j] == nil {
                    return false
                }
            }
        }
        
        return true
    }
    
    func findRandomSpot() -> NSButton {
        var availableSlots : [Location] = []
        
        for i in 0..<LocationManager.matrix.count {
            for j in 0..<LocationManager.matrix[i].count {
                availableSlots.append(LocationManager.matrix[i][j])
            }
        }
        
        for subview in subviews {
            if (subview as? NSTextField) != nil {
                var slot = 0
                while slot < availableSlots.count {
                    if subview.frame == availableSlots[slot].frame {
                        availableSlots.remove(at: slot)
                    } else {
                        slot += 1
                    }
                }
            }
        }
        
        let chosenSpace = availableSlots[Int.random(in: 0..<availableSlots.count)]
        
        for cell in cells {
            if cell.btn.frame == chosenSpace.frame {
                return cell.btn
            }
        }
        
        return NSButton()
    }
    
    func AI() -> NSButton {
        if sections[1][1] == nil {
            return Cell.cell(at: 1, with: 1, in: cells).btn
        } else if sections[1][1]?.type == currentCard {
            if sections[0][0] == nil {
                return Cell.cell(at: 0, with: 0, in: cells).btn
            } else if sections[2][2] == nil {
                return Cell.cell(at: 2, with: 2, in: cells).btn
            } else if sections[0][2] == nil {
                return Cell.cell(at: 0, with: 2, in: cells).btn
            } else if sections[2][0] == nil {
                return Cell.cell(at: 2, with: 0, in: cells).btn
            }
        }
        
        return findRandomSpot()
    }
    
    func presentBoardNotifier() {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0.5
        boardNotifier.animator().alphaValue = 1.0
        NSAnimationContext.endGrouping()
    }
    
    func dismissBoardNotifier() {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0.5
        boardNotifier.animator().alphaValue = 0.0
        NSAnimationContext.endGrouping()
    }
    
    func strikeThroughWin(with type: WinState) {
        if type == .Horizontal || type == .Vertical {
            let x_pos = type == .Vertical ? getStrikePosition(with: winLevel!)! : 0
            let y_pos = type == .Horizontal ? getStrikePosition(with: winLevel!)! : 0
            let width = type == .Vertical ? 10 : frame.size.width
            let height = type == .Horizontal ? 10 : frame.size.height
            let line = NSView(frame: NSRect(x: x_pos, y: y_pos, width: width, height: height))
            line.wantsLayer = true
            line.layer!.backgroundColor = NSColor.white.cgColor
            line.frame.origin.y = type == .Vertical ? height : y_pos
            line.frame.size.width = type == .Horizontal ? 0 : width
            self.addSubview(line)
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 0.5
            line.animator().frame.size.width = width
            line.animator().frame.origin.y = y_pos
            NSAnimationContext.endGrouping()
        } else {
            let diagonal = NSImageView(frame: self.frame)
            diagonal.frame.origin.y = 0
            diagonal.image = NSImage(named: "\(String(describing: type))Strike")
            diagonal.alphaValue = 0.0
            self.addSubview(diagonal)
            
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 1.0
            diagonal.animator().alphaValue = 1.0
            NSAnimationContext.endGrouping()
        }
    }
    
    func getStrikePosition(with level: Int) -> CGFloat? {
        let offset : CGFloat = level == 0 ? CGFloat(level + 1) : CGFloat(level + 2 + (level - 1))
        let position = ((LocationManager.matrix[0][0].frame.size.width / 2) * offset) - 5
        return position
    }
    
    func checkForWin() -> WinState? {
        for i in 0..<sections.count {
            if sameValues(arr: sections[i]) {
                winLevel = i
                return .Horizontal
            }
        }
        
        for i in 0..<sections.count {
            if sameValues(arr: [sections[0][i], sections[1][i], sections[2][i]]) {
                winLevel = i
                return .Vertical
            }
        }
        
        let major_diagonal : [Player?] = [sections[0][0], sections[1][1], sections[2][2]]
        let minor_diagonal : [Player?] = [sections[2][0], sections[1][1], sections[0][2]]
        
        if (sameValues(arr: major_diagonal) && major_diagonal.count == 3) {
            winLevel = 1
            return .MajorDiagonal
        } else if (sameValues(arr: minor_diagonal) && minor_diagonal.count == 3) {
            winLevel = 2
            return .MinorDiagonal
        }
        
        winLevel = nil
        return nil
    }
    
    func sameValues(arr: [Player?]) -> Bool {
        if arr[0] != nil && arr[1] != nil && arr[2] != nil {
            let equal = arr[0]
            for value in arr {
                if value?.location.frame != equal?.location.frame && value?.type != equal?.type {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    func disableCells() {
        cells.forEach { cell in
            cell.btn.isEnabled = false
        }
    }
    
    func enableCells() {
        cells.forEach { cell in
            cell.btn.isEnabled = true
        }
    }
}

public class Player {
    
    var type: TicTacToeBoard.Card!
    var location: Location!
    
    public init(type: TicTacToeBoard.Card, location: Location) {
        self.type = type
        self.location = location
    }
}

public class O {
    public static func draw(location: Location) -> NSTextField {
        let O = NSTextField(frame: location.frame)
        O.isBordered = false
        O.isBezeled = false
        O.isEditable = false
        O.drawsBackground = false
        O.textColor = NSColor.white
        O.stringValue = "O"
        O.alignment = .center
        O.font = NSFont.systemFont(ofSize: 100)
        
        return O
    }
}

public class X {
    public static func draw(location: Location) -> NSTextField {
        let X = NSTextField(frame: location.frame)
        X.isBordered = false
        X.isBezeled = false
        X.isEditable = false
        X.drawsBackground = false
        X.textColor = NSColor.white
        X.stringValue = "X"
        X.alignment = .center
        X.font = NSFont.systemFont(ofSize: 100)
        
        return X
    }
}

public class Cell: NSObject {
    var row : Int!
    var col : Int!
    var btn : NSButton!
    
    public init(row: Int, col: Int, btn: NSButton) {
        self.row = row
        self.col = col
        self.btn = btn
    }
    
    public static func cell(at row: Int, with col: Int, in cells: [Cell]) -> Cell {
        for cell in cells {
            if cell.row == row && cell.col == col {
                return cell
            }
        }
        
        return Cell(row: row, col: row, btn: NSButton())
    }
}
