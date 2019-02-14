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
    func getAllObject<E: Object>(of type: E.Type) -> Results<E>
   
    func getObject<E: Object, Key: Equatable>(of type: E.Type, keyId: Key) -> E?
    func saveRealmDB<E: Object>(_ data: E)
    func deleteDB<E: Object, key: Equatable>(realmData: E.Type, keyId: key)
    
//    func updatePost(keyId: String, title: String, rating: Int)
    func updateMonthlyNumOfPost(keyId: Int, addNum: Int)
    func updateFixedPost(keyId: String, title: String, rating: Int)
    
//    func createPost(date: Date, rating: Int, time: Int, title: String, isFixed: Bool) -> Post
    func createNumOfPost(date: Date) -> NumOfPost
    func createFixedPost(title: String, rating: Int, time: Int, weekDay: Int, setDate: Date) -> RealmFixedPost
}

class DBManager: DBManagerProtocol {
    var realm: Realm {
        return try! Realm()
    }
    
    func getAllObject<E: Object>(of type: E.Type) -> Results<E> {
        return realm.objects(type)
    }
    
    // MARK: - GET
    func getObject<E: Object, Key: Equatable>(of type: E.Type,
                                               keyId: Key) -> E? {
        return realm.object(ofType: type, forPrimaryKey: keyId)
    }

    // MARK: - SAVE
    func saveRealmDB<T: Object>(_ data: T) {
        let data = data as T
        try! self.realm.write {
            realm.add(data)
        }
    }
    
    // MARK: - DELETE
    func deleteDB<E: Object, key: Equatable>(realmData: E.Type, keyId: key) {
        if let db = realm.object(ofType: E.self, forPrimaryKey: keyId) {
            try! realm.write {
                realm.delete(db)
            }
        }
    }
    
    // MARK: - UPDATE
    func updatePost(keyId: String, title: String, rating: Int, fixedPostId: String? = nil) {
        if let post = self.getObject(of: Post.self, keyId: keyId){
            try! realm.write {
                post.mealTitle = title
                post.rating = rating
                
                if let fixedPostId = fixedPostId {
                    post.fixedPostId = fixedPostId
                }
            }
        }
    }
    
    func updatePostIsFixed(keyId: String, fixedPostId: String?) {
        if let post = self.getObject(of: Post.self, keyId: keyId){
            try! realm.write {
                post.fixedPostId = fixedPostId
            }
        }
    }
    
    func updateMonthlyNumOfPost(keyId: Int, addNum: Int) {
        if let monthlyNumOfPost = self.getObject(of: NumOfPost.self, keyId: keyId) {
            try! realm.write {
                monthlyNumOfPost.numOfpost += addNum
            }
        }
    }

    func updateFixedPost(keyId: String, title: String, rating: Int) {
        if let fixedPost = self.getObject(of: RealmFixedPost.self, keyId: keyId) {
            try! realm.write {
                fixedPost.title = title
                fixedPost.rating = rating
                fixedPost.setDate = Date()
            }
        }
    }
    
    
    // MARK: - CREATE
    func createPost(date: Date, rating: Int, time: Int, title: String, fixedPostId: String? = nil) -> Post {
        return Post(date: date, rating: rating, mealTime: time, mealTitle: title, fixedPostId: fixedPostId)
    }
    
    func createNumOfPost(date: Date) -> NumOfPost {
        return NumOfPost(date: date)
    }
    
    func createFixedPost(title: String, rating: Int,
                         time: Int, weekDay: Int, setDate: Date) -> RealmFixedPost {
        return RealmFixedPost(title: title, rating: rating,
                              time: time, weekDay: weekDay, setDate: setDate)
    }
}


// MARK: - Fixed post
extension DBManager {
    func isCurrentFixedPost(post: Post) -> Bool {
        return DBManager()
            .getAllObject(of: RealmFixedPost.self)
            .contains { $0.fixedPostId == post.fixedPostId }
    }
}
