//
//  SongView.swift
//  Minify
//
//  Created by aliyasineser on 10/09/2017.
//  Copyright © 2017 aliyasineser. All rights reserved.
//

import Cocoa

class SongView: NSView {
    //View links
    @IBOutlet weak var albumCoverView: NSImageView!
    @IBOutlet weak var prevButton: NSButton!
    @IBOutlet weak var playPauseButton: NSButton!
    @IBOutlet weak var songField: NSTextField!
    @IBOutlet weak var nextButton: NSButton!
    @IBOutlet weak var bandField: NSTextField!

    override func viewWillDraw() {
        // Highlighs looks bad while activating buttons.
        playPauseButton.highlight(false)
        nextButton.highlight(false)
        prevButton.highlight(false)
        
    }
    
    @IBAction func prevSong(_ sender: NSButton) {
        // Get Applescript path and execute
        let sourcePath = Bundle.main.path(forResource: "prev_track", ofType: "scpt")
        if let source = sourcePath {
            executeAppleScript(args: [source], waitReturn: false)
        }
    }
    
    
    @IBAction func playPauseSong(_ sender: NSButton) {
        
        // Get Applescript path and execute
        var sourcePath = Bundle.main.path(forResource: "player_state", ofType: "scpt")
        let theState = executeAppleScript(args: [sourcePath!], waitReturn: true)
        if (theState == "playing"){
            sourcePath = Bundle.main.path(forResource: "pause", ofType: "scpt")
            if let source = sourcePath {
                executeAppleScript(args: [source], waitReturn: false)
            }
            //playPauseButton.image = NSImage(named: "Play")
        }else if(theState == "paused"){
            sourcePath = Bundle.main.path(forResource: "play", ofType: "scpt")
            if let source = sourcePath {
                executeAppleScript(args: [source], waitReturn: false)
            }
            //playPauseButton.image = NSImage(named: "Pause")
        }
        else{}
    }
    
    
    func executeAppleScript(args: [String]?, waitReturn: Bool) -> String {
        // Create a process to execute script
        let task = Process()
        // Assign Applescript path. Path can be changed, enter your applescript path. Look for "osascript"
        task.launchPath = "/usr/bin/osascript"
        // Assign arguments. Arguments can be directly file path as in this program does.
        // Alternatively, developer can choose to "osascript  -e \(Applescript code)" for running directly.
        // For running directly, just change args as "-e", "\(Applescript code)"
        task.arguments = args
        
        // Create pipe for capture standart output
        let outPipe = Pipe()
        task.standardOutput = outPipe // to capture standard error, use task.standardError = outPipe
        // Start execution
        task.launch()
        // If there should be a return value, capture the standart output and do something with it.
        if(waitReturn){
            // Read and assign data from pipe
            let fileHandle = outPipe.fileHandleForReading
            let data = fileHandle.readDataToEndOfFile()
            var str:String = String.init(data: data, encoding: String.Encoding.utf8)!
            // The last character is newline, remove it.
            str.remove(at: str.index(before: str.endIndex))
            return str
        }
        return "" // If there is no return value for the script, basically return an empty string.
    }
    
    @IBAction func nextSong(_ sender: NSButton) {
        // Get Applescript path and execute
        let sourcePath = Bundle.main.path(forResource: "next_track", ofType: "scpt")
        executeAppleScript(args: [sourcePath!], waitReturn: false)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
        
    }
    
    @objc func update(){

        // Get Applescript path and execute
        var sourcePath = Bundle.main.path(forResource: "player_state", ofType: "scpt")
        let theState = self.executeAppleScript(args: [sourcePath!], waitReturn: true)
        
        // Get Applescript path and execute
        sourcePath = Bundle.main.path(forResource: "getSongName", ofType: "scpt")
        let songName = self.executeAppleScript(args: [sourcePath!], waitReturn: true)
        
        // Get Applescript path and execute
        sourcePath = Bundle.main.path(forResource: "getBandName", ofType: "scpt")
        let bandName = self.executeAppleScript(args: [sourcePath!], waitReturn: true)
        
        // Get Applescript path and execute
        sourcePath = Bundle.main.path(forResource: "getArtworkUrl", ofType: "scpt")
        let artworkUrl = self.executeAppleScript(args: [sourcePath!], waitReturn: true)
        
        // Observe current state and update ui for pause or play
        if (theState == "playing"){
            playPauseButton.image = NSImage(named: "Pause")
        }else if(theState == "paused"){
            playPauseButton.image = NSImage(named: "Play")
        }
        
        // Assign song and band names
        self.songField.stringValue = songName
        self.bandField.stringValue = bandName
        
        // Create URL for cover of the album
        let url: URL = URL.init(string: artworkUrl)!
        // Assign the artwork to album cover image
        self.albumCoverView.image = NSImage.init(contentsOf: url)
        
    }
    
}








