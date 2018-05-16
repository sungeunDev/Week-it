//
//  Post+CoreDataProperties.swift
//  EatIt
//
//  Created by 김성종 on 2018. 5. 16..
//  Copyright © 2018년 AppKings. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var healthyRating: String?
    @NSManaged public var mealTime: NSDecimalNumber?
    @NSManaged public var mealTitle: String?

}
