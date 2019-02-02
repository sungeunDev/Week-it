//
//  PostUsecase.swift
//  Eat-it
//
//  Created by Sungeun Park on 21/01/2019.
//  Copyright © 2019 sungeun. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol DBManagerProtocol {
    var realm: Realm { get }
    var allPosts: Results<Post> { get }
    var allNumOfPosts: Results<NumOfPost> { get }
    var allFixedPosts: Results<RealmFixedPost> { get }
    
    func getRealmDB<E: Object, Key: Equatable>(keyId: Key) -> E?
//    func saveRealmDB<E: Object>(_ data: E)
    func deleteDB<E: Object, key: Equatable>(realmData: E.Type, keyId: key)
    
    func updatePost(keyId: String, title: String, rating: Int)
    func updateMonthlyNumOfPost(keyId: Int, addNum: Int)
    func updateFixedPost(keyId: String, title: String, rating: Int)
    
    func createPost(date: Date, rating: Int, time: Int, title: String) -> Post
    func createNumOfPost(date: Date) -> NumOfPost
    func createFixedPost(title: String, rating: Int, time: Int, weekDay: Int) -> RealmFixedPost
}

class DBManager: DBManagerProtocol {
    var realm: Realm {
        return try! Realm()
    }
    
    var allPosts: Results<Post> {
        return realm.objects(Post.self)
    }
    
    var allNumOfPosts: Results<NumOfPost> {
        return realm.objects(NumOfPost.self)
    }
    
    var allFixedPosts: Results<RealmFixedPost> {
        return realm.objects(RealmFixedPost.self)
    }
    
    // MARK: - GET
    func getRealmDB<E: Object, Key: Equatable>(keyId: Key) -> E? {
        return realm.object(ofType: E.self, forPrimaryKey: keyId)
    }
    
    func saveRealmDB<T: Object>(ofType: T.Type, data: T) {
        let data = data as T
        try! self.realm.write {
            realm.add(data)
        }
    }
    
    // MARK: - SAVE
//    func saveRealmDB<T: Object>(_ data: E) {
//
//        try! self.realm.write {
//            realm.add(data as! E)
//        }
//
////        if E is Post.Type {
//            try! self.realm.write {
//                realm.add(data as! Post.Type)
//            }
//        } else if E() is NumOfPost {
//            try! self.realm.write {
//                realm.add(data as! NumOfPost)
//            }
//        } else if E() is RealmFixedPost {
//            try! self.realm.write {
//                realm.add(data as! RealmFixedPost)
//            }
//        } else {
//            print("------------< other type >------------")
//        }
//    }
    
    // MARK: - DELETE
    func deleteDB<E: Object, key: Equatable>(realmData: E.Type, keyId: key) {
        if let db = realm.object(ofType: E.self, forPrimaryKey: keyId) {
            try! realm.write {
                realm.delete(db)
            }
        }
    }
    
    // MARK: - UPDATE
    func updatePost(keyId: String, title: String, rating: Int) {
        if let post = self.getRealmDB(keyId: keyId) as? Post {
            try! realm.write {
                post.mealTitle = title
                post.rating = rating
            }
        }
    }
    
    func updateMonthlyNumOfPost(keyId: Int, addNum: Int) {
        if let monthlyNumOfPost = self.getRealmDB(keyId: keyId) as? NumOfPost {
            try! realm.write {
                monthlyNumOfPost.numOfpost += addNum
            }
        }
    }
    
    func updateFixedPost(keyId: String, title: String, rating: Int) {
        if let fixedPost = self.getRealmDB(keyId: keyId) as? RealmFixedPost {
            try! realm.write {
                fixedPost.title = title
                fixedPost.rating = rating
                fixedPost.setDate = Date()
            }
        }
    }
    
    
    // MARK: - CREATE
    func createPost(date: Date, rating: Int, time: Int, title: String) -> Post {
        return Post(date: date, rating: rating, mealTime: time, mealTitle: title)
    }
    
    func createNumOfPost(date: Date) -> NumOfPost {
        return NumOfPost(date: date)
    }
    
    func createFixedPost(title: String, rating: Int,
                         time: Int, weekDay: Int) -> RealmFixedPost {
        return RealmFixedPost(title: title, rating: rating,
                              time: time, weekDay: weekDay)
    }
}
