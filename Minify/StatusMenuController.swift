//
//  StatusMenuController.swift
//  Minify
//
//  Created by aliyasineser on 10/09/2017.
//  Copyright © 2017 aliyasineser. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {

    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var songView: SongView!
    var songMenuItem: NSMenuItem!
    var queue: DispatchQueue = DispatchQueue.main
    var timer: Timer!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        let icon = NSImage(named: "AppIcon32")
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        statusMenu.title = "Minify"
        songMenuItem = statusMenu.item(withTitle: "Song")
        songMenuItem.view = songView
    
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self.songView, selector: #selector(self.songView.update), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    
    
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
    
    
    
    
    
    
    
}
