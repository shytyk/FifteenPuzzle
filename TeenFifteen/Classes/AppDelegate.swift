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

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions
        launchOptions: [NSObject: AnyObject]?) -> Bool {
            application.statusBarStyle = UIStatusBarStyle.LightContent
            TFTMusicController.start()
            return true
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        TFTMusicController.player?.pause()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        TFTMusicController.player?.play()
    }
}

