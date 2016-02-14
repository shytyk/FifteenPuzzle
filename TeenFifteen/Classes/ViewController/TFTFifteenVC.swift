//
//  TFTFifteenVC.swift
//  TeenFifteen
//
//  Created by Mykyta Shytik on 12/12/15.
//  Copyright © 2015 Mykyta Shytik. All rights reserved.
//

import UIKit

let kTFTMinute: NSTimeInterval = 60.0

class TFTFifteenVC: UIViewController {
    var totalTime: NSTimeInterval = 0.0
    var tapCount = 0
    var timer: NSTimer?
    var solved = false
    
    @IBOutlet private var timeLabel: UILabel?
    @IBOutlet private var tapLabel: UILabel?
    @IBOutlet private var fifteenView: TFTFifteenView?
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFifteenView()
        updateUI()
    }
    
    // MARK: - Public
    
    func timerTick() {
        totalTime += 0.1
        updateUI()
    }
    
    // MARK: - Private (setup)
    
    private func setupFifteenView() {
        fifteenView?.solveBlock = {
            [weak self] fView in
            self?.solved = true
            self?.timer?.invalidate()
            self?.timer = nil
        }
        
        fifteenView?.tapBlock = {
            [weak self] fView in
            
            if (self?.timer == nil) && !self!.solved {
                self?.setupTimer()
            }
            
            self?.tapCount += 1
        }
    }
    
    private func setupTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(
            0.1,
            target: self,
            selector: "timerTick",
            userInfo: nil,
            repeats: true
        )
    }
    
    // MARK: - Private
    
    private func updateUI() {
        timeLabel?.text = "Time: " + totalTimeString()
        tapLabel?.text = "Taps: " + String(tapCount)
    }
    
    private func totalTimeString() -> String {
        let ti = NSInteger(totalTime)

        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return String(
            NSString(
                format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds
            )
        )
    }
    
    // MARK: - IBAction
    
    @IBAction private func backButtonTap() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

