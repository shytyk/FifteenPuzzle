//
//  AppDelegate.swift
//  TeenFifteen
//
//  Created by Mykyta Shytik on 12/12/15.
//  Copyright © 2015 Mykyta Shytik. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // MARK: - UIApplicationDelegate

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions
        launchOptions: [NSObject: AnyObject]?) -> Bool {
            application.statusBarStyle = UIStatusBarStyle.LightContent
            setupSoundOnFirstLaunch()
            TFTMusicController.start()
            return true
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        TFTMusicController.pause()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        TFTMusicController.playIfNeeded()
    }
    
    // MARK: - Private
    
    private func setupSoundOnFirstLaunch() {
        if let _ = TFTUserDefaultsController.firstDate {
            return
        }
        
        TFTUserDefaultsController.firstDate = NSDate()
        TFTUserDefaultsController.isSoundOn = true
    }
}

