//
//  Post.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 5..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import Foundation
import RealmSwift

class Post: Object {
    @objc dynamic var date: Date!
    @objc dynamic var rating: Int = 0
    @objc dynamic var mealTime: Int = 0
    @objc dynamic var mealTitle: String = ""
}
