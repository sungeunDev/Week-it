//
//  PostUsecase.swift
//  Eat-it
//
//  Created by Sungeun Park on 21/01/2019.
//  Copyright © 2019 sungeun. All rights reserved.
//

import Foundation
import RealmSwift

protocol PostUsecaseProtocol {
    var realm: Realm { get }
    var allNumOfPost: Results<NumOfPost> { get }
    var allFixedPost: Results<RealmFixedPost> { get }
    
    func getPost(keyId: String) -> Post?
    
//    func savePost(_ post: Post)
//    func saveMonthlyNumOfPost(_ numOfPost: NumOfPost)
//    func saveFixedPost(_ fixedPost: RealmFixedPost)
    
    func updatePost(keyId: String, title: String, rating: Int)
    func updateMonthlyNumOfPost(keyId: Int, addNum: Int)
    func updateFixedPost(keyId: String, title: String, rating: Int)
    
    func deletePost(keyId: String)
    func deleteMonthlyNumOfPost(keyMonth: Int)
    func deleteFixedPost(keyId: String)
    
    func createPost(date: Date, rating: Int, time: Int, title: String) -> Post
    func createNumOfPost(date: Date) -> NumOfPost
    func createFixedPost(title: String, rating: Int, time: Int, weekDay: Int) -> RealmFixedPost
}

class PostUsecase: PostUsecaseProtocol {
    var realm: Realm {
        return try! Realm()
    }
    
    var allNumOfPost: Results<NumOfPost> {
        return realm.objects(NumOfPost.self)
    }
    
    var allFixedPost: Results<RealmFixedPost> {
        return realm.objects(RealmFixedPost.self)
    }
    
    // MARK: - GET
    func getPost(keyId: String) -> Post? {
        return realm.object(ofType: Post.self, forPrimaryKey: keyId)
    }
    
    // MARK: - SAVE
    func saveRealmDB<E: Object>(_ data: E) {
        try! self.realm.write {
            realm.add(data)
        }
    }
    
    // MARK: - UPDATE
    func updatePost(keyId: String, title: String, rating: Int) {
        if let post = realm.object(ofType: Post.self,
                                   forPrimaryKey: keyId) {
            try! realm.write {
                post.mealTitle = title
                post.rating = rating
            }
        }
    }
    
    func updateMonthlyNumOfPost(keyId: Int, addNum: Int) {
        if let monthlyNumOfPost = realm.object(ofType: NumOfPost.self, forPrimaryKey: keyId) {
            try! realm.write {
                monthlyNumOfPost.numOfpost += addNum
            }
        }
    }
    
    func updateFixedPost(keyId: String, title: String, rating: Int) {
        if let fixedPost = realm.object(ofType: RealmFixedPost.self,
                                        forPrimaryKey: keyId) {
            try! realm.write {
                fixedPost.title = title
                fixedPost.rating = rating
                fixedPost.setDate = Date()
            }
        }
    }
    
    // MARK: - DELETE
    func deletePost(keyId: String) {
        if let post = realm.object(ofType: Post.self, forPrimaryKey: keyId) {
            try! realm.write {
                realm.delete(post)
            }
        }
    }
    
    func deleteMonthlyNumOfPost(keyMonth: Int) {
        if let numOfPost = realm.object(ofType: NumOfPost.self,
                                        forPrimaryKey: keyMonth) {
            try! realm.write {
                realm.delete(numOfPost)
            }
        }
    }
    
    func deleteFixedPost(keyId: String) {
        if let fixedPost = realm.object(ofType: RealmFixedPost.self,
                                        forPrimaryKey: keyId) {
            try! realm.write {
                realm.delete(fixedPost)
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
