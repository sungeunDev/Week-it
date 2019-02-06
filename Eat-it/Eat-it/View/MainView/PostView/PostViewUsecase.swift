//
//  PostViewUsecase.swift
//  Eat-it
//
//  Created by Sungeun Park on 06/02/2019.
//  Copyright © 2019 sungeun. All rights reserved.
//

import Foundation
import RealmSwift

class PostViewUsecase {
    var mealTime: Int?
    var date: Date?
    var rating: Int?
    var title: String?
    var fixedId: String?
    
    var weekDay: Int?
    var isFixedPost: Bool?
    
    var postData: Post?
    var fixedPostsData: RealmFixedPost?
    var afterPosts: Results<Post>?
    
    let dbm = DBManager()
    
}

// MARK: - Save
extension PostViewUsecase {
    public func saveBtnClicked() {
        savePostProcess()
        setAfterPosts()
        saveMonthlyNumOfPostProcess()
        saveFixedPostProcess()
    }
    
    func savePostProcess() {
        guard let date = date,
            let rating = rating,
            let time = mealTime,
            let title = title,
            let isFixedPost = isFixedPost else { return }
        
        if postData == nil {
            var post = Post()
            if isFixedPost {
                post = dbm.createPost(date: date,
                                          rating: rating,
                                          time: time,
                                          title: title,
                                          fixedPostId: fixedId)
            } else {
                post = dbm.createPost(date: date,
                                          rating: rating,
                                          time: time,
                                          title: title)
            }
            dbm.saveRealmDB(post)
        } else {
            guard let postData = self.postData,
                let fixedId = fixedId else { return }
            dbm.updatePost(keyId: postData.postId,
                                 title: title,
                                 rating: rating,
                                 fixedPostId: fixedId)
        }
    }
    
    
    
    func saveMonthlyNumOfPostProcess() {
        
    }
    
    func saveFixedPostProcess() {
        
    }
}


// MARK: - Set
extension PostViewUsecase {
    func setAfterPosts() {
        guard let date = date,
            let time = mealTime,
            let weekDay = weekDay else { return }
        
        let deleteDateInt = date.trasformInt()
        let allPosts = dbm.getAllObject(of: Post.self)
        self.afterPosts = allPosts.filter("dateText > %@ AND mealTime == %@ AND weekDay == %@",
                                          deleteDateInt,
                                          time,
                                          weekDay)
    }
}
