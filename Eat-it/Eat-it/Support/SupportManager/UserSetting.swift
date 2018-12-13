//
//  UserSetting.swift
//  Eat-it
//
//  Created by Sungeun Park on 10/12/2018.
//  Copyright © 2018 sungeun. All rights reserved.
//

import Foundation

protocol UserSettingProtocol {
    
    // 0 ~ 6 (일~토)
    var weeklyFirstWeekOfDay: Int { get set }
    
    func getWeeklyFirstWeekOfDay()
    func setWeeklyFirstWeekOfDay()
    
}

class UserSetting {
    
}
