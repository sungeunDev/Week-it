//
//  ViewController.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 5..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {

    // UI Properties
    @IBOutlet private weak var mealTimeCollectionView: UICollectionView! // 아침, 점심, 저녁
    @IBOutlet private weak var dayCollectionView: UICollectionView! // 요일 (월~금)
    @IBOutlet private weak var postCollectionView: UICollectionView! // mealTime * day
    @IBOutlet private weak var mealMatrixView: UIView!
    
    @IBOutlet private weak var dateLabel: UILabel!
    
    // Sample Data
    let meal = ["아침", "점심", "저녁"]
    let day = ["Mon", "Tue", "Wed", "Thu", "Fri"] //, "Sat", "Sun"]
    let post = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15] //, 16, 17, 18, 19, 20, 21]
    
    var sampleData: Post!
    var postData: [Post] = []
    
    private var date: Date = Date()
    private var calendar: Calendar = Calendar.current
    
    
    var posts: Results<Post>!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NSHomeDirectory())
        
        // CollectionView Tag
        mealTimeCollectionView.tag = 0
        dayCollectionView.tag = 1
        postCollectionView.tag = 2
        
        date = changeToMonday(of: date)
        currentDateLabel(input: date)
        
        sampleData = Post(date: date, rating: 0, mealTime: 1, mealTitle: "this")
        postData = Array(repeating: sampleData, count: post.count)
        
        
        if let realm = try? Realm() {
            posts = realm.objects(Post.self)
            
        }
        


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        postCollectionView.reloadData()
        
        getPosts()

    }

    
    func getPosts() -> Results<Post> {
        
        let realm = try! Realm()
        posts = realm.objects(Post.self)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        let minDateInt = Int(formatter.string(from: self.date))!
        let minDatestr = formatter.string(from: self.date)
        let minDate = formatter.date(from: minDatestr)!
        

        var dateComponent = DateComponents()
        let timeIntervalDay = 7
        dateComponent.day = timeIntervalDay
        
        let maxDate = Calendar.current.date(byAdding: dateComponent, to: minDate)!
//        let maxDatestr   = formatter.string(from: maxDate)
        let maxDateInt = Int(formatter.string(from: maxDate))!
        
//        print("\n---------- [ min: \(minDate), max: \(maxDate) ] -----------\n")
//        posts = posts.filter("date >= %@", minDate).filter("date < %@", maxDate)
        posts = posts.filter("dateText >= %@", minDateInt).filter("dateText < %@", maxDateInt)
        
//        print(posts)
        
        let postsSorted = posts.sorted(by: [
            SortDescriptor(keyPath: "dateText", ascending: true),
            SortDescriptor(keyPath: "mealTime", ascending: true),
            ])
        
        print(postsSorted)
        
        return postsSorted
    }
    
    
}


// MARK: - UICollectionView DataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return meal.count
        case 1:
            return day.count
        default:
            return meal.count * day.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mealCell", for: indexPath) as! MealCell
            cell.mealData = meal[indexPath.item]
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCell
            cell.dayData = day[indexPath.item]
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
            cell.postData = post[indexPath.item]
            
            if indexPath.item % 3 == 0 {
                cell.backgroundColor = UIColor.blue
            } else if indexPath.item % 3 == 1 {
                cell.backgroundColor = UIColor.yellow
            }
//            cell.data = postData[indexPath.item]
            
            return cell
        }
    }
}


// MARK: - UICollectionView Delegate FlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    // didSelect
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        
        
        if collectionView.tag == 2 {
            
            nextVC.postData = postData[indexPath.item]
            nextVC.postData?.mealTime = indexPath.item % meal.count
            
            var dateComponent = DateComponents()
            let timeIntervalDay = indexPath.item / 3
            dateComponent.day = timeIntervalDay
            
            let adjustDate = Calendar.current.date(byAdding: dateComponent, to: date)!
            
            nextVC.postData?.date = adjustDate
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tableWidth = mealMatrixView.frame.width - 10
        let tableHeight = mealMatrixView.frame.height - 10
        
        switch collectionView.tag {
        case 0:
            let width = tableWidth * 75 / 315
            let height = tableHeight * 40 / 413
            let size = CGSize(width: width, height: height)
            return size
        case 1:
            let width = tableWidth * 60 / 315
            let height = tableHeight * 65 / 413
            let size = CGSize(width: width, height: height)
            return size
        default:
            let width = tableWidth * 75 / 315
            let height = tableHeight * 65 / 413
            let size = CGSize(width: width, height: height)
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        var height = (postCollectionView.frame.height - 10)
        let cellHeight = (mealMatrixView.frame.height - 10) * 65 / 413
        height = (height - cellHeight * 5) / 4
        
        return height
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        var width = postCollectionView.frame.width - 10
        let cellWidth = (mealMatrixView.frame.width - 10) * 75 / 315
        width = (width - cellWidth * 3) / 2
        
        return width
    }
}


// MARK: - Calendar, Date
extension MainViewController {
    
    @discardableResult
    func changeToMonday(of date: Date) -> Date {
        let calendar = Calendar.current
        let monday = 2
        
        if calendar.component(.weekday, from: date) != monday {
            var dateComponent = DateComponents()
            let adjustDayCount = (calendar.component(.weekday, from: date) - monday) * (-1)
            dateComponent.day = adjustDayCount
            
            let adjustDate = Calendar.current.date(byAdding: dateComponent, to: date)!
            
            return adjustDate
        } else {
            
            return date
        }
    }
    
    
    func currentDateLabel(input: Date) {
        let year = calendar.component(.year, from: input)
        let month: String = {
            let month = calendar.component(.month, from: input)
            if month < 10 {
                return "0\(month)"
            } else {
                return "\(month)"
            }
        }()
        
        let day: String = {
            let day = calendar.component(.day, from: input)
            if day < 10 {
                return "0\(day)"
            } else {
                return "\(day)"
            }
        }()
        
        // 월 ~ 금 일자로 나타내기
        let txt = "\(year). \(month). \(day) ~ "
        dateLabel.text = txt
    }
    
    
    @IBAction private func leftBtn() {
        let prevWeekDay = -7
        
        var dateComponent = DateComponents()
        dateComponent.day = prevWeekDay
        
        self.date = Calendar.current.date(byAdding: dateComponent, to: date)!
        currentDateLabel(input: self.date)
    }
    
    @IBAction private func rightBtn() {
        let nextWeek = 60 * 60 * 24 * 7
        date = Date(timeInterval: TimeInterval(nextWeek), since: date)
        currentDateLabel(input: date)
    }
    
}

