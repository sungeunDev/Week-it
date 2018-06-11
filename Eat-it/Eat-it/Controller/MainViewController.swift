//
//  ViewController.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 5..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit
import RealmSwift
import SnapKit

class MainViewController: UIViewController {

    // UI Properties
    @IBOutlet private weak var mealTimeCollectionView: UICollectionView! // 아침, 점심, 저녁
    @IBOutlet private weak var dayCollectionView: UICollectionView! // 요일 (월~금)
    @IBOutlet private weak var postCollectionView: UICollectionView! // mealTime * day
    @IBOutlet private weak var mealMatrixView: UIView!
    
    @IBOutlet private weak var dateLabel: UILabel!
    
    // Data
    let meal = ["아침", "점심", "저녁"]
    let day = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    
    var posts: Array<Post?> = []
    
    // Date Calculation Properties
    private var date: Date = Date()
    private var calendar: Calendar = Calendar.current
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSHomeDirectory())
        
        mealMatrixView.layer.cornerRadius = 7
        
        // CollectionView Tag
        mealTimeCollectionView.tag = 0
        dayCollectionView.tag = 1
        postCollectionView.tag = 2
        
        naviBarItemSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // this week of monday date & label setting
        date = changeToMonday(of: date)
        currentDateLabel(input: date)
        
        // fetch this week post data & sort
        posts = makePostMatrix()
    }

    
    // current date에 해당하는 주의 데이터만 fetch
    func fetchThisWeekPosts() -> Results<Post> {
        
        // 전체 Post Data fetch
        let realm = try! Realm()
        var posts = realm.objects(Post.self)
        
        // 이번주 (월 ~ 일)에 해당하는 Post만 filtering
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        let minDateInt = date.trasformInt(from: self.date)

        let minDatestr = formatter.string(from: self.date)
        let minDate = formatter.date(from: minDatestr)!
        
        var dateComponent = DateComponents()
        let timeIntervalDay = 7
        dateComponent.day = timeIntervalDay
        
        let maxDate = Calendar.current.date(byAdding: dateComponent, to: minDate)!
        let maxDateInt = maxDate.trasformInt(from: maxDate)
        
        posts = posts.filter("dateText >= %@", minDateInt).filter("dateText < %@", maxDateInt)
        
        // date(월 ~ 금), mealTime(아침 ~ 저녁) 순으로 sort
        let postsSorted = posts.sorted(by: [
            SortDescriptor(keyPath: "dateText", ascending: true),
            SortDescriptor(keyPath: "mealTime", ascending: true),
            ])
        
        return postsSorted
    }
    
    
    // 3 * 5 개의 배열로 Post 생성
    func makePostMatrix() -> Array<Post?> {
        
        // 빈 배열 생성
        var postArray = Array<Post?>(repeating: nil, count: meal.count * day.count)
        
        // 금주의 Post data fetch
        let thisWeekPosts = fetchThisWeekPosts()
        
        // 알맞은 위치에 포스트 삽입
        let currentDate = self.date.trasformInt(from: self.date)
        
        for post in thisWeekPosts {
            let dateDiff = post.dateText - currentDate
            let mealTime = post.mealTime
        
            let idx = dateDiff * 3 + mealTime
            postArray[idx] = post
        }
        
        // Reload Post CollectionView
        postCollectionView.reloadData()
    
        return postArray
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
            return posts.count
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
            cell.postData = posts[indexPath.item]
            
            // shadow
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath

            return cell
        }
    }
}


// MARK: - UICollectionView Delegate FlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    // didSelect
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        // move Post View Controller
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        
        if collectionView.tag == 2 {
            
            // Send Info of mealTime, date
            nextVC.mealTime = indexPath.item % meal.count
            
            var dateComponent = DateComponents()
            let timeIntervalDay = indexPath.item / 3
            dateComponent.day = timeIntervalDay
            let adjustDate = Calendar.current.date(byAdding: dateComponent, to: date)!
            
            nextVC.date = adjustDate
            
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
        
        posts = makePostMatrix()
    }
    
    @IBAction private func rightBtn() {
        let nextWeek = 60 * 60 * 24 * 7
        date = Date(timeInterval: TimeInterval(nextWeek), since: date)
        currentDateLabel(input: date)
        
        posts = makePostMatrix()
    }
    
}


// MARK: - Navigation Bar Button Setting
extension MainViewController {
    
    func naviBarItemSetting() {
        
        let leftBtn = UIButton()
        leftBtn.setImage(UIImage(named: "graph"), for: .normal)
        leftBtn.addTarget(self, action: #selector(moveGraphVC(_:)), for: .touchUpInside)

        
        
        let leftImageView = UIImageView(image: UIImage(named: "graph"))
        let barItem = UIBarButtonItem(customView: leftImageView)
        
//        let width
        
        self.navigationItem.leftBarButtonItem = barItem
    }
    
    @objc func moveGraphVC(_ : UIButton) {
        
    }
    
}

