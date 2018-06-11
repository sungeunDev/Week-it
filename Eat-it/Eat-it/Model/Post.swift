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
    
    @objc dynamic var postId = NSUUID().uuidString
    
    @objc dynamic var date: Date!
    @objc dynamic var dateText: Int = 0
    
    
    @objc dynamic var rating: Int = 0
    @objc dynamic var mealTime: Int = 0
    @objc dynamic var mealTitle: String = ""
    
    
    override class func primaryKey() -> String? {
        return "postId"
    }
    
    convenience init(date: Date, rating: Int, mealTime: Int, mealTitle: String) {
        self.init()
        self.date = date
        self.rating = rating
        self.mealTime = mealTime
        self.mealTitle = mealTitle
        
        self.dateText = date.trasformInt(from: date)
    }
}

extension Post {
    var ratingText: String {
        switch rating {
        case 0:
            return "Good"
        case 1:
            return "Soso"
        default:
            return "Bad"
        }
    }
    
    var ratingColor: UIColor {
        switch rating {
        case 0:
            return UIColor.red
        case 1:
            return UIColor.yellow
        default:
            return UIColor.blue
        }
    }
    
    var mealTimeText: String {
        switch mealTime {
        case 0:
            return "아침"
        case 1:
            return "점심"
        default:
            return "저녁"
        }
    }
    

}
