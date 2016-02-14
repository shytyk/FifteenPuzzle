//
//  TFTUserDefaultsController.swift
//  TeenFifteen
//
//  Created by Mykyta Shytik on 2/14/16.
//  Copyright © 2016 Mykyta Shytik. All rights reserved.
//

import UIKit

private let UserDefaultKeySoundOn = "UserDefaultKeySoundOn"
private let UserDefaultKeyFirstDate = "UserDefautlKeyFirstDate"

class TFTUserDefaultsController: NSObject {
    static var isSoundOn: Bool {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            return defaults.boolForKey(UserDefaultKeySoundOn)
        }
        
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(newValue, forKey: UserDefaultKeySoundOn)
            defaults.synchronize()
        }
    }
    
    static var firstDate: AnyObject? {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            return defaults.objectForKey(UserDefaultKeyFirstDate)
        }
        
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(newValue, forKey: UserDefaultKeyFirstDate)
            defaults.synchronize()
        }
    }
}
