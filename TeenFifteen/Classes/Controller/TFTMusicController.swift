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
    static var isSoundOn: Bool {
        get {
            return TFTUserDefaultsController.isSoundOn
        }
        
        set {
            TFTUserDefaultsController.isSoundOn = newValue
            if TFTUserDefaultsController.isSoundOn {
                player?.play()
            } else {
                player?.pause()
            }
        }
    }

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
            try player = AVAudioPlayer(
                contentsOfURL: soundFileURL,
                fileTypeHint: nil
            )
            
            player?.numberOfLoops = -1
            
            if isSoundOn {
                player?.play()
            }
        } catch {}
    }
    
    static func playIfNeeded() {
        if isSoundOn {
            player?.play()
        }
    }
    
    static func pause() {
        player?.pause()
    }
}
