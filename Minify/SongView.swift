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
    
    // Task Arguments
    let prevTrackArgs: [String]? = ["/Users/aliyasineser/Desktop/prev_track.scpt"]
    let nextTrackArgs: [String]? = ["/Users/aliyasineser/Desktop/next_track.scpt"]
    let playTrackArgs: [String]? = ["/Users/aliyasineser/Desktop/play.scpt"]
    let pauseTrackArgs: [String]? = ["/Users/aliyasineser/Desktop/pause.scpt"]
    let songNameArgs: [String]? = ["/Users/aliyasineser/Desktop/getSongName.scpt"]
    let bandNameArgs: [String]? = ["/Users/aliyasineser/Desktop/getBandName.scpt"]
    let artworkArgs: [String]? = ["/Users/aliyasineser/Desktop/getArtworkUrl.scpt"]
    let playerStateArgs: [String]? = ["/Users/aliyasineser/Desktop/player_state.scpt"]
    
    
    
    override func viewWillDraw() {
//        
//        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
//        
        
    }
    
    @IBAction func prevSong(_ sender: NSButton) {
        executeAppleScript(args: prevTrackArgs, waitReturn: false)
        update()
    }
    
    
    @IBAction func playPauseSong(_ sender: NSButton) {
        
        let theState = executeAppleScript(args: playerStateArgs, waitReturn: true)
        if (theState == "playing"){
            executeAppleScript(args: pauseTrackArgs, waitReturn: false)
            playPauseButton.image = NSImage(named: "Play")
        }else if(theState == "paused"){
            executeAppleScript(args: playTrackArgs, waitReturn: false)
            playPauseButton.image = NSImage(named: "Pause")
        }
        else{}
        update()

        
    }
    
    
    func executeAppleScript(args: [String]?, waitReturn: Bool) -> String{
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = args
        
        let outPipe = Pipe()
        task.standardOutput = outPipe // to capture standard error, use task.standardError = outPipe
        
        task.launch()
        if(waitReturn){
            let fileHandle = outPipe.fileHandleForReading
            let data = fileHandle.readDataToEndOfFile()
            var str:String = String.init(data: data, encoding: String.Encoding.utf8)!
            str.remove(at: str.index(before: str.endIndex))
            return str
        }
        return ""
    }
    
    @IBAction func nextSong(_ sender: NSButton) {
        executeAppleScript(args: nextTrackArgs, waitReturn: false)
        playPauseButton.image = NSImage(named: "Pause")
        update()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
        
    }
    
    func update(){

        let theState = self.executeAppleScript(args: self.playerStateArgs, waitReturn: true)
        let songName = self.executeAppleScript(args: self.songNameArgs, waitReturn: true)
        let bandName = self.executeAppleScript(args: self.bandNameArgs, waitReturn: true)
        let artworkUrl = self.executeAppleScript(args: self.artworkArgs, waitReturn: true)
        
        if (theState == "playing"){
            playPauseButton.image = NSImage(named: "Pause")
        }else if(theState == "paused"){
            playPauseButton.image = NSImage(named: "Play")
        }
        
        self.songField.stringValue = songName
        self.bandField.stringValue = bandName
        
        let url: URL = URL.init(string: artworkUrl)!
        self.albumCoverView.image = NSImage.init(contentsOf: url)
        
    }
    
}








