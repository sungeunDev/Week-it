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
    
    var posts: Array<Post?> = [] {
        didSet {
            self.postCollectionView.reloadData()
        }
    }
    
    // Date Calculation Properties
    private var date: Date = Date()
    private var calendar: Calendar = Calendar.current
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSHomeDirectory())
        
        // mealMatrixView.layer.cornerRadius = 7
        
        // CollectionView Tag
        mealTimeCollectionView.tag = 0
        dayCollectionView.tag = 1
        postCollectionView.tag = 2
        
        // Navigation Bar UI
        naviBarTitleLayout()
        naviBarItemLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // this week of monday date & label setting
        date = changeToMonday(of: date)
        currentDateLabel(input: date)
        
        // fetch this week post data & sort
        posts = makePostMatrix()
    }
}

// MARK: - Method
extension MainViewController {
    
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
        
        var postArray = Array<Post?>(repeating: nil, count: meal.count * day.count) // 빈 배열 생성
        let thisWeekPosts = fetchThisWeekPosts() // 금주의 Post data fetch
        let currentDate = self.date.trasformInt(from: self.date)
        
        // 알맞은 위치에 포스트 삽입
        for post in thisWeekPosts {
            let dateDiff = post.dateText - currentDate
            let mealTime = post.mealTime
            
            let idx = dateDiff * 3 + mealTime
            postArray[idx] = post
        }
        return postArray
    }
    
    // MARK: - Gesture
    @IBAction private func pressGesture(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: postCollectionView)
        switch sender.state {
        case .began:
            guard let itemIndexPath = postCollectionView.indexPathForItem(at: location) else { break }
            postCollectionView.beginInteractiveMovementForItem(at: itemIndexPath)
        case .changed:
            postCollectionView.updateInteractiveMovementTargetPosition(location)
        case .ended:
            postCollectionView.endInteractiveMovement()
        default:
            postCollectionView.cancelInteractiveMovement()
        }
    }
    
    @IBAction private func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        rightBtn()
    }
    
    @IBAction private func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        leftBtn()
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
    
    // MARK: - move collectionView cell
    func collectionView(_ collectionView: UICollectionView,
                        moveItemAt sourceIndexPath: IndexPath,
                        to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else { return }
        
//        collectionView.performBatchUpdates({
//            collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
//        }, completion: nil)
        
        if posts[destinationIndexPath.row] == nil {
            let temp = posts[sourceIndexPath.row]
            posts[destinationIndexPath.row] = temp
            posts[sourceIndexPath.row] = temp
        } else {
            let temp = posts[sourceIndexPath.row]
            posts[sourceIndexPath.row] = posts[destinationIndexPath.row]
            posts[destinationIndexPath.row] = temp
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath,
//                        toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
//        if posts[proposedIndexPath.item] == nil {
//            defer {
//                posts[proposedIndexPath.item] = posts[originalIndexPath.item]
//            }
//                return originalIndexPath
//        } else {
//            return proposedIndexPath
//        }
//    }
    
}


// MARK: - UICollectionView Delegate FlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    // didSelect
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        // move Post View Controller
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        
        if collectionView.tag == 2 {

            // 이전에 포스트를 입력해 놓은 경우, 해당 포스트를 불러옴
            if let post = posts[indexPath.item] {
                nextVC.postData = post
            }
            
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
    
    // BarItem - left, right Button
    func naviBarItemLayout() {
        
        let iconSize = 24
        
        // left Btn
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: "graph.png"), for: .normal)
        leftBtn.addTarget(self, action: #selector(moveGraphVC(_:)), for: .touchUpInside)
        let leftBarItem = UIBarButtonItem(customView: leftBtn)
        
        leftBarItem.customView?.snp.makeConstraints({ (make) in
            make.width.equalTo(iconSize)
            make.height.equalTo(iconSize)
        })
        
        // right Btn
        let rightBtn = UIButton(type: .custom)
        rightBtn.setImage(UIImage(named: "setting.png"), for: .normal)
        rightBtn.addTarget(self, action: #selector(moveSettingVC(_:)), for: .touchUpInside)
        let rightBarItem = UIBarButtonItem(customView: rightBtn)
        
        rightBarItem.customView?.snp.makeConstraints({ (make) in
            make.width.equalTo(iconSize)
            make.height.equalTo(iconSize)
        })
        
        self.navigationItem.leftBarButtonItem = leftBarItem
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    @objc func moveGraphVC(_ : UIButton) {
        let graphVC = self.storyboard?.instantiateViewController(withIdentifier: "GraphViewController") as! GraphViewController
        self.navigationController?.pushViewController(graphVC, animated: true)
    }
    
    @objc func moveSettingVC(_ : UIButton) {
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    
    // BarItem - Title
    func naviBarTitleLayout() {
        
        let width: CGFloat = 65
        let height: CGFloat = 26
        
        let containerButton = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageView.image = UIImage(named: "logo.png")
        
        containerButton.addTarget(self, action: #selector(moveCalendarToday(_:)), for: .touchUpInside)
        containerButton.addSubview(imageView)
        self.navigationItem.titleView = containerButton
    }
    
    // Title 누르면 현재 날짜로 돌아옴
    @objc func moveCalendarToday(_ : UIButton) {
        self.date = Date()
        
        date = changeToMonday(of: date)
        currentDateLabel(input: self.date)
        
        self.posts = makePostMatrix()
    }
    
}

