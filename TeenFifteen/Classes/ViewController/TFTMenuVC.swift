//
//  TFTMenuVC.swift
//  TeenFifteen
//
//  Created by Mykyta Shytik on 12/15/15.
//  Copyright © 2015 Mykyta Shytik. All rights reserved.
//

import UIKit
import AudioToolbox

class TFTMenuVC: UIViewController {
    
    @IBOutlet private weak var soundButton: UIButton!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSoundButtonTitle()
    }
    
    // MARK: - Private
    
    private func updateSoundButtonTitle() {
        let title = "Sound: " + (TFTMusicController.isSoundOn ? "On" : "Off")
        soundButton.setTitle(title, forState: .Normal)
    }
    
    // MARK: - IBAction
    
    @IBAction
    private func soundButtonTap() {
        TFTMusicController.isSoundOn = !TFTMusicController.isSoundOn
        updateSoundButtonTitle()
    }
    
    @IBAction
    private func knockAction() {
        let bundle = NSBundle.mainBundle()
        guard let path = bundle.pathForResource("knock", ofType: "wav") else {
            return
        }
        
        let URL = NSURL.fileURLWithPath(path)
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(URL, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
}
