//
//  DBManager.swift
//  Eat-it
//
//  Created by Sungeun Park on 09/12/2018.
//  Copyright © 2018 sungeun. All rights reserved.
//

import Foundation
import RealmSwift

protocol DBManagerProtocol {
    var db: Realm! { get }
    
    func getRealmPostsResults() -> Results<Post>
    func getNumOfPostsResults() -> Results<NumOfPost>
}

class DBManager: DBManagerProtocol {

    var db: Realm!
    
    init(db: Realm) {
        self.db = db
    }
    
    func getRealmPostsResults() -> Results<Post> {
        return db.objects(Post.self)
    }
    
    func getNumOfPostsResults() -> Results<NumOfPost> {
        return db.objects(NumOfPost.self)
    }
}
