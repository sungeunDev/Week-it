//
//  RealmFixedPost.swift
//  Eat-it
//
//  Created by Sungeun Park on 14/12/2018.
//  Copyright © 2018 sungeun. All rights reserved.
//

import Foundation
import RealmSwift

class RealmFixedPost: Object {
    
    @objc dynamic var fixedPostId = NSUUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var rating: Int = 0
    @objc dynamic var time: Int = 0
    @objc dynamic var weekDay: Int = 0 // 1 - 일 ~ 7 - 토
    @objc dynamic var setDate: Date = Date()
    
    override class func primaryKey() -> String? {
        return "fixedPostId"
    }
    
    convenience init(title: String, rating: Int, time: Int, weekDay: Int) {
        self.init()
        self.title = title
        self.rating = rating
        self.time = time
        self.weekDay = weekDay
        self.setDate = Date()
    }
}
