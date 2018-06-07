//
//  Post.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 5..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import Foundation
import RealmSwift

class Post2: Object {
    @objc dynamic var date: Date!
    @objc dynamic var rating: Int = 0
    @objc dynamic var mealTime: Int = 0
    @objc dynamic var mealTitle: String = ""
}


class Post {
    var date: Date!
    var rating: Int = 0
    var mealTime: Int = 0
    var mealTitle = ""
    
    init(date: Date, rating: Int, mealTime: Int, mealTitle: String) {
        self.date = date
        self.rating = rating
        self.mealTime = mealTime
        self.mealTitle = mealTitle
    }
}
