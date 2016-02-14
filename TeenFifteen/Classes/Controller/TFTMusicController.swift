//
//  TFTMusicController.swift
//  TeenFifteen
//
//  Created by Mykyta Shytik on 2/14/16.
//  Copyright © 2016 Mykyta Shytik. All rights reserved.
//

import UIKit
import AVFoundation

class TFTMusicController: UIView {
    
    static var player: AVAudioPlayer?

    static func start() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryAmbient)
            try session.setActive(true)
        } catch {}
        
        
        let bundle = NSBundle.mainBundle()
        let soundFilePath = bundle.pathForResource("Game_Loop", ofType: "wav")
        let soundFileURL = NSURL(fileURLWithPath: soundFilePath!)
        
        do {
            try player = AVAudioPlayer(contentsOfURL: soundFileURL, fileTypeHint: nil)
            player?.numberOfLoops = -1
            player?.play()
        } catch {}
    }
}
