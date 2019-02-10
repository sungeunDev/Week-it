//
//  EventTrackingManager.swift
//  Eat-it
//
//  Created by Sungeun Park on 09/12/2018.
//  Copyright © 2018 sungeun. All rights reserved.
//

import Foundation
import Answers

class EventTrackingManager {
    
    static func createPostLog(time: Int, rate: Int, contents: String) {
        
        var timeStr: String = ""
        switch time {
        case 0: timeStr = "morning"
        case 1: timeStr = "noon"
        case 2: timeStr = "night"
        default:
            ()
        }
        
        var rateStr: String = ""
        switch rate {
        case 0: rateStr = "good"
        case 1: rateStr = "soso"
        case 2: rateStr = "bad"
        default:
            ()
        }
        
        Answers.logCustomEvent(withName: "Create Post",
                               customAttributes: ["time": timeStr,
                                                  "rate": rateStr,
                                                  "contents": contents])
    }
    
    static func showGraphViewLog(totalPost: Int) {
        let countryLocale = NSLocale.current
        if let countryCode = countryLocale.regionCode,
            let country = (countryLocale as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: countryCode) {
            Answers.logContentView(withName: "logContentView",
                                   contentType: "Graph View",
                                   contentId: "userCountry: \(country)",
                customAttributes: ["totalPost": "\(totalPost)"])
        }
    }    
}
