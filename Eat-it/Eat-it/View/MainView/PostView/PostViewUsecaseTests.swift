//
//  PostViewUsecaseTests.swift
//  Eat-itTests
//
//  Created by Sungeun Park on 06/02/2019.
//  Copyright © 2019 sungeun. All rights reserved.
//

import XCTest
@testable import Eat_it

class PostViewUsecaseTests: XCTestCase {

    let usecase = PostViewUsecase()
    let dbm = DBManager()
    
    override func setUp() {
        usecase.mealTime = 0
        usecase.date = Date()
        usecase.rating = 0
        usecase.title = "Testing"
        usecase.weekDay = Calendar.current.component(.weekday, from: usecase.date!)
    }

    func testSavePostProcessWhenNoFixedPost() {
        // Setup
        self.setUp()
        usecase.isFixedPost = false
        
        // Act
        usecase.savePostProcess()
        
        // Then
        let posts = dbm.getAllObject(of: Post.self)
        let filteredPosts = posts.filter { (post) -> Bool in
            if post.mealTitle == self.usecase.title
                && post.mealTime == self.usecase.mealTime
                && post.rating == self.usecase.rating
                && post.date == self.usecase.date {
                XCTAssertTrue(post.fixedPostId == nil)
                return true
            } else {
                return false
            }
        }
        
        if filteredPosts.count == 1 {
            XCTAssertTrue(true)
        } else {
            XCTFail()
        }
    }
    
    func testSavePostProcessWhenFixedPostExist() {
        self.setUp()
        usecase.isFixedPost = true
        usecase.fixedId = "testingId"
        
        usecase.savePostProcess()
        
        let posts = dbm.getAllObject(of: Post.self)
        let filteredPosts = posts.filter { (post) -> Bool in
            if post.mealTitle == self.usecase.title
                && post.mealTime == self.usecase.mealTime
                && post.rating == self.usecase.rating
                && post.date == self.usecase.date {
                XCTAssertTrue(post.fixedPostId != nil)
                return true
            } else {
                return false
            }
        }
        
        if filteredPosts.count == 1 {
            XCTAssertTrue(true)
            XCTAssertTrue(filteredPosts.first!.fixedPostId == usecase.fixedId)
        } else {
            XCTFail()
        }
    }
}
