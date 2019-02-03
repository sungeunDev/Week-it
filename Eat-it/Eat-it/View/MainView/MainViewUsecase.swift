//
//  MainViewUsecase.swift
//  Eat-it
//
//  Created by Sungeun Park on 09/12/2018.
//  Copyright © 2018 sungeun. All rights reserved.
//

import Foundation
import RealmSwift

protocol MainViewUsecaseProtocol {
    
    
    func getWeeklyPosts(date: Date) -> Results<Post>
    func getPostMatrix(postData: Results<Post>, weekData: [Date]) -> [Post?]
    
    
    func getWeeklyDate(date: Date) -> [Date] // 월~일 날짜
    
}

class MainViewUsecase: MainViewUsecaseProtocol {
    func getWeeklyPosts(date: Date) -> Results<Post> {
        return DBManager().allRealmObject(of: Post.self)
    }
    
    func getPostMatrix(postData: Results<Post>, weekData: [Date]) -> [Post?] {
        return []
    }
    
    // input - 오늘 날짜
    // -> 유저가 설정해둔 요일의 첫날로 변경 (현재는 월요일)
    func getWeeklyDate(date: Date) -> [Date] {
        let firstDate = changeWeeklyFirstWeekOfDay(from: date)
        
        var nextMonthIdx = 0
        var tempFirstDateOfThisWeek: [Date] = []
        
        var test: [Date] = []
        for idx in (0..<7) {
            let timeInterval: Double = Double(idx * 60 * 60 * 24)
            
            let date = firstDate.addingTimeInterval(timeInterval)
            test.append(date)
        }
        
        // 음? 그냥 하루하루 증가시켜도 되는거 아닌가?
        for idx in (0..<7) {
            let timeInterval: Double = Double(idx * 60 * 60 * 24)
            let date = firstDate.addingTimeInterval(timeInterval)
            let dateInt = firstDate.trasformInt() + idx
        
            // date가 월의 마지막날일 경우
            if dateInt == firstDate.lastDayOfMonth().trasformInt() {
                nextMonthIdx = idx + 1
                tempFirstDateOfThisWeek.append(date)
            }
            // date가 월이 바뀔 경우
            else if dateInt > firstDate.lastDayOfMonth().trasformInt() {
                let tempDate = firstDate.firstDayOfNextMonth().addingTimeInterval((Double(idx - nextMonthIdx) * 60 * 60 * 24))
                tempFirstDateOfThisWeek.append(tempDate)
            } else {
                tempFirstDateOfThisWeek.append(date)
            }
        }
        
        return tempFirstDateOfThisWeek
    }
    
    @discardableResult // 이거 왜했더라?
    func changeWeeklyFirstWeekOfDay(from date: Date) -> Date {
        
        let calendar = Calendar.current
        let monday = 2
        
        if calendar.component(.weekday, from: date) != monday {
            
            var dateComponent = DateComponents()
            var adjustDayCount = (calendar.component(.weekday, from: date) - monday) * (-1)
            
            // 일요일 보정
            if adjustDayCount == 1 {
                adjustDayCount = -6
            }
            
            dateComponent.day = adjustDayCount
            let adjustDate = Calendar.current.date(byAdding: dateComponent, to: date)!
            return adjustDate
        } else {
            return date
        }
    }
    
    
    func getAllFixedPosts() -> Results<RealmFixedPost> {
        let realm = try! Realm()
        let allFixedPosts = realm.objects(RealmFixedPost.self)
//        print(allFixedPosts)
        return allFixedPosts
    }
    
    // 아-점-저 * 일주일
    func sortFixedPostsByTime() -> [RealmFixedPost] {
        let allFixedPosts = self.getAllFixedPosts()
        let sortedFixedPosts = allFixedPosts.sorted(by: [
            SortDescriptor(keyPath: "weekDay", ascending: true),
            SortDescriptor(keyPath: "time", ascending: true)
            ])
        
//        print("------------< sortedFixedPosts: \(sortedFixedPosts.count) >------------")
        
        var returnResult = [RealmFixedPost]()
        var sundayFixedPosts = [RealmFixedPost]()
        for fixedPosts in sortedFixedPosts {
            returnResult.append(fixedPosts)
            if fixedPosts.weekDay == 1 { // sunday
                sundayFixedPosts.append(fixedPosts)
                returnResult.removeLast()
            }
        }
        
        returnResult.append(contentsOf: sundayFixedPosts)
        return returnResult
    }
    
    
}
