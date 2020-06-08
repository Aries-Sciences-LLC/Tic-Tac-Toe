//
//  Location.swift
//  Tic Tac Toe
//
//  Created by Ozan Mirza on 5/27/19.
//  Copyright © 2019 Ozan Mirza. All rights reserved.
//

import Cocoa

public protocol Location {
    var frame: NSRect { get set }
}

fileprivate class Row1Col1: Location {
    public var frame: NSRect
    
    public init() {
        self.frame = NSRect(x: 0, y: 0, width: 116, height: 116)
    }
}

fileprivate class Row2Col1: Location {
    public var frame: NSRect
    
    public init() {
        self.frame = NSRect(x: 116, y: 0, width: 116, height: 116)
    }
}

fileprivate class Row3Col1: Location {
    public var frame: NSRect
    
    public init() {
        self.frame = NSRect(x: 232, y: 0, width: 116, height: 116)
    }
}

fileprivate class Row1Col2: Location {
    public var frame: NSRect
    
    public init() {
        self.frame = NSRect(x: 0, y: 116, width: 116, height: 116)
    }
}

fileprivate class Row2Col2: Location {
    public var frame: NSRect
    
    public init() {
        self.frame = NSRect(x: 116, y: 116, width: 116, height: 116)
    }
}

fileprivate class Row3Col2: Location {
    public var frame: NSRect
    
    public init() {
        self.frame = NSRect(x: 232, y: 116, width: 116, height: 116)
    }
}

fileprivate class Row1Col3: Location {
    public var frame: NSRect
    
    public init() {
        self.frame = NSRect(x: 0, y: 232, width: 116, height: 116)
    }
}

fileprivate class Row2Col3: Location {
    public var frame: NSRect
    
    public init() {
        self.frame = NSRect(x: 116, y: 232, width: 116, height: 116)
    }
}

fileprivate class Row3Col3: Location {
    public var frame: NSRect
    
    public init() {
        self.frame = NSRect(x: 232, y: 232, width: 116, height: 116)
    }
}

public class LocationManager {
    public static let matrix : [[Location]] = [[Row1Col1(), Row2Col1(), Row3Col1()],
                                               [Row1Col2(), Row2Col2(), Row3Col2()],
                                               [Row1Col3(), Row2Col3(), Row3Col3()]]
}
