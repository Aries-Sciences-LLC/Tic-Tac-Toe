//
//  MainWindow.swift
//  Tic Tac Toe
//
//  Created by Ozan Mirza on 2/11/19.
//  Copyright © 2019 Ozan Mirza. All rights reserved.
//

import Cocoa

class MainWindow: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
//        [WAYTheDarkSide welcomeApplicationWithBlock:^{
//            [weakSelf.window setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameVibrantDark]];
//            [weakSelf.contentView setMaterial:NSVisualEffectMaterialDark];
//            [self.label setStringValue:@"Dark!"];
//        } immediately:YES];
        
        WAYTheDarkSide.welcomeApplication({
            self.window?.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
        }, immediately: true)
        
        self.window!.hasShadow = false
        self.window!.invalidateShadow()
        
        // Lowering buttons
        let customToolbar = NSToolbar()
        customToolbar.showsBaselineSeparator = false
        window!.toolbar = customToolbar
    }
}
