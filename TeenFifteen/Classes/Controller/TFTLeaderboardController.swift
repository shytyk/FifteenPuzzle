//
//  TFTLeaderboardController.swift
//  TeenFifteen
//
//  Created by Mykyta Shytik on 2/14/16.
//  Copyright © 2016 Mykyta Shytik. All rights reserved.
//

import UIKit

typealias TFTRecordData = Dictionary<String, AnyObject>
typealias TFTRecordDataArray = [TFTRecordData]

private let UserDefaultLeaderboardKey = "UserDefaultLeaderboardKey"
private let UserDefaultLeaderboardNameKey = "UserDefaultLeaderboardNameKey"
private let UserDefaultLeaderboardTimeKey = "UserDefaultLeaderboardTimeKey"
private let LeaderboardRecordsCount = 3

class TFTLeaderboardController: NSObject {
    static func canBeAdded(ti: NSTimeInterval) -> Bool {
        let count = LeaderboardRecordsCount
        guard let recs = records() where recs.count >= count else {
            return true
        }
        
        guard let lastRecord = recs.last else {
            return true
        }
        
        let timeKey = UserDefaultLeaderboardTimeKey
        guard let time = lastRecord[timeKey] as? NSTimeInterval else {
            return true
        }
        
        return ti < time
    }
    
    static func records() -> TFTRecordDataArray? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let stored = defaults.arrayForKey(UserDefaultLeaderboardKey)
        
        guard let record = stored as? TFTRecordDataArray
            where record.count > 0 else {
                return nil
        }
        
        let result = record.sort {
            el1, el2 in
            
            let timeKey = UserDefaultLeaderboardTimeKey
            
            guard let ti1 = el1[timeKey] as? NSTimeInterval else {
                return true
            }
            
            guard let ti2 = el2[timeKey] as? NSTimeInterval else {
                return false
            }
            
            return ti1 < ti2
        }
        
        return result
    }
    
    static func add(timeInterval ti: NSTimeInterval, name: String?) {
        guard let name = name else {
            return
        }
        
        let res = [
            UserDefaultLeaderboardNameKey: name,
            UserDefaultLeaderboardTimeKey: ti
        ]
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        guard var record = records() else {
            let array = [res]
            defaults.setObject(array, forKey: UserDefaultLeaderboardKey)
            defaults.synchronize()
            return
        }
        
        if canBeAdded(ti) {
            if record.count >= LeaderboardRecordsCount {
                record.removeLast()
            }
            record.append(res as! TFTRecordData)
            defaults.setObject(record, forKey: UserDefaultLeaderboardKey)
            defaults.synchronize()
        }
    }
    
    static func isNameValid(name: String?) -> Bool {
        guard let name = name
            where name.characters.count > 3 && name.characters.count < 8 else {
                return false
        }
        
        let set = NSCharacterSet.alphanumericCharacterSet()
        let invSet = set.invertedSet
        
        let strName = name as NSString
        if strName.rangeOfCharacterFromSet(invSet).location != NSNotFound {
            return false
        }
        
        return true
    }
    
    static func text(index index: Int) -> String {
        guard let recs = records() where recs.count > index else {
            return ""
        }
        
        let rec = recs[index]
        return (rec[UserDefaultLeaderboardNameKey] as! String)
            + ": "
            + totalTimeString(rec[UserDefaultLeaderboardTimeKey] as! NSTimeInterval)
    }
    
    private static func totalTimeString(time: NSTimeInterval) -> String {
        let ti = NSInteger(time)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return String(
            NSString(
                format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds
            )
        )
    }

}
