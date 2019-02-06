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
    
    // MARK: - Properties
    // MARK: -UI Properties
    @IBOutlet private weak var mealTimeCollectionView: UICollectionView! // 아침, 점심, 저녁
    @IBOutlet private weak var dayCollectionView: UICollectionView! // 요일 (월~금)
    @IBOutlet private weak var postCollectionView: UICollectionView! // mealTime * day
    @IBOutlet private weak var mealMatrixView: UIView!
    
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: -Constraints
    @IBOutlet weak var dateViewTopConstraint: NSLayoutConstraint! // dateView Top - SafeArea Top Spacing
    @IBOutlet weak var mealTableTopConstraint: NSLayoutConstraint! // dateView Bottom - mealTable Top Spacing
    
    @IBOutlet weak var timeTablePropotinalHeight_isIncludeWeekend: NSLayoutConstraint!
    @IBOutlet weak var timeTablePropotinalHeight_notIncludeWeekend: NSLayoutConstraint!
    
    @IBOutlet weak var mealTableBottomConstarint: NSLayoutConstraint! // mealTable Bottom - SafeArea Bottom Spacing
    
    // MARK:  -Settings
    var userSetting = Settings.custom
    
    // MARK: -Data
    let meal = ["아침", "점심", "저녁"]
    var day = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    
    var posts: Array<Post?> = [] {
        didSet {
            self.postCollectionView.reloadData()
        }
    }
    
    var fixedPosts: [RealmFixedPost] = []
    
    // MARK: -Date Calculation Properties
    private var date: Date = Date()
    private var calendar: Calendar = Calendar.current
    private var firstDateOfThisWeek: [Int] = [] {
        didSet {
            dayCollectionView.reloadData()
        }
    }
    
    func lastdateConfigure() {
        if firstDateOfThisWeek.count == 7 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let date = dateFormatter.date(from: String(firstDateOfThisWeek.last!))
            dateFormatter.dateFormat = userSetting.currentDateFormat
            lastDate = dateFormatter.string(from: date!)
        }
    }
    
    var lastDate = "" {
        didSet {
            dateLabel.reloadInputViews()
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //    print(NSHomeDirectory())
        presentTutorialView()
        
        // this week of monday date & label setting
        date = changeToMonday(of: date)
        
        // Navigation Bar UI
        naviBarItemLayout()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil        
    }
    
    func loadAll() {
        let dbmanager = DBManager()
        let fixedPosts = dbmanager.getAllObject(of: RealmFixedPost.self)
        print(fixedPosts.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // fetch this week post data & sort
        posts = makePostMatrix(date: self.date)
        createPostsByFixed()
        posts = makePostMatrix(date: self.date)
        
        // save UserDefault Today's Post
        saveTodayExtensionData()
        
        // Update UI
        mealMatrixView.backgroundColor = mealMatrixViewBackgroundColor() // mealMatrix background color accroing to theme
        naviBarTitleLayout() // Navigation Bar UI - 테마 컬러에 따라 색이 바뀌어야 하므로 viewWillAppear에 위치
        updateAutoLayout() // 유저 세팅에 따라 레이아웃 변경
        configureDateLabel(date: date)
        
        loadAll()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        postCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func createPostsByFixed() {
        self.fixedPosts = MainViewUsecase().sortFixedPostsByTime()
        for fixed in fixedPosts {
            let index = (fixed.weekDay - 2) * 3 + fixed.time
            if posts[index] == nil {
                var dateComponent = DateComponents()
                dateComponent.day = fixed.weekDay - 2
                let adjustDate = Calendar.current.date(byAdding: dateComponent, to: date)!
                
                // fixed post를 설정한 날짜보다 이전은 post생성하지 않음
                if fixed.setDate <= adjustDate {
                    let dbm = DBManager()
                    let post = dbm.createPost(date: adjustDate,
                                              rating: fixed.rating,
                                              time: fixed.time,
                                              title: fixed.title)
                    dbm.saveRealmDB(post)
                    saveMonthlyNumOfPostProcess(date: adjustDate)
                }
            }
        }
    }
    
    func saveMonthlyNumOfPostProcess(date: Date) {
        let month = date.transformIntOnlyMonth()
        let dbManager = DBManager()
        
        let numOfMonthlyPost = dbManager
            .getAllObject(of: NumOfPost.self)
            .filter("dateInt == %@", month)
        if dbManager.getAllObject(of: NumOfPost.self).count == 0 || numOfMonthlyPost.count == 0 {
            let monthPost = dbManager.createNumOfPost(date: date)
            dbManager.saveRealmDB(monthPost)
        } else {
            let id = numOfMonthlyPost[0].dateInt // numOfMonthlyPost는 항상 1개만 존재
            dbManager.updateMonthlyNumOfPost(keyId: id, addNum: 1)
        }
    }
    
    //PRESENT TUTORIAL VIEW ON FIRST LAUNCH ONLY
    private func presentTutorialView() {
        if !UserDefaults.standard.bool(forKey: "didSee") {
            UserDefaults.standard.set(true, forKey: "didSee")
            let tutorialView = self.storyboard?.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
            self.present(tutorialView, animated: false, completion: nil)
            
            // 초기값 on으로 설정
            Settings.custom.setIsIncludeWeeknd(isIncludeWeekend: true)
        }
    }
}

// MARK: - Method
extension MainViewController {
    
    // current date에 해당하는 주의 데이터만 fetch
    fileprivate func fetchThisWeekPosts(date: Date) -> Results<Post> {
        // 전체 Post Data fetch
        let realm = try! Realm()
        var posts = realm.objects(Post.self)
        
        // 이번주 (월 ~ 일)에 해당하는 Post만 filtering
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        let minDateInt = self.date.trasformInt()
        let minDatestr = formatter.string(from: self.date)
        let minDate = formatter.date(from: minDatestr)!
        
        var dateComponent = DateComponents()
        let timeIntervalDay = 7
        dateComponent.day = timeIntervalDay
        
        let maxDate = Calendar.current.date(byAdding: dateComponent, to: minDate)!
        let maxDateInt = maxDate.trasformInt()
        
        posts = posts.filter("dateText >= %@", minDateInt).filter("dateText < %@", maxDateInt)
        firstDateOfThisWeek.removeAll()
        
        var nextMonthIdx = 0
        var tempFirstDateOfThisWeek: [Int] = []
        for idx in (0..<7) {
            let dateInt = minDateInt + idx
            if dateInt == minDate.lastDayOfMonth().trasformInt() {
                nextMonthIdx = idx + 1
                tempFirstDateOfThisWeek.append(dateInt)
            } else if dateInt > minDate.lastDayOfMonth().trasformInt() {
                let tempDate = minDate.firstDayOfNextMonth().trasformInt() + (idx - nextMonthIdx)
                tempFirstDateOfThisWeek.append(tempDate)
            } else {
                tempFirstDateOfThisWeek.append(dateInt)
            }
        }
        
        firstDateOfThisWeek = tempFirstDateOfThisWeek
        lastdateConfigure()
        // date(월 ~ 금), mealTime(아침 ~ 저녁) 순으로 sort
        let postsSorted = posts.sorted(by: [
            SortDescriptor(keyPath: "dateText", ascending: true),
            SortDescriptor(keyPath: "mealTime", ascending: true)
            ])
        
        return postsSorted
    }
    
    
    // 3 * 5 개의 배열로 Post 생성
    func makePostMatrix(date: Date) -> Array<Post?> {
        var postArray = Array<Post?>(repeating: nil, count: meal.count * day.count) // 빈 배열 생성
        let thisWeekPosts = fetchThisWeekPosts(date: date) // 금주의 Post data fetch
        let currentDate = self.date.trasformInt()
        
        let lastDayOfThisMonth = date.lastDayOfMonth()
        let lastDayInt = lastDayOfThisMonth.trasformInt()
        let nextMonth: Int = {
            var nextMonth = lastDayOfThisMonth.transformIntOnlyMonth() + 100
            if nextMonth/100 % 100 > 12 {
                let year = nextMonth / 10000
                nextMonth = (year + 1) * 10000 + 100
            }
            return nextMonth
        }()
        
        // 알맞은 위치에 포스트 삽입
        for post in thisWeekPosts {
            var dateDiff = 0
            if post.dateText > lastDayInt {
                dateDiff = post.dateText - nextMonth + lastDayInt - currentDate
            } else {
                dateDiff = post.dateText - currentDate
            }
            
            let mealTime = post.mealTime
            let idx = dateDiff * 3 + mealTime
            
            postArray[idx] = post
        }
        return postArray
    }
    
    
    // MARK: - TodayExtension
    func saveTodayExtensionData() {
        let dateText = Date().trasformInt()
        let appIdentifier = "group.com.middd.TodayExtensionSharingDefaults"
        /***************************************************
         오늘의 포스트 데이터 저장 - mealTitle, mealTime, rating, color set
         ***************************************************/
        guard let realm = try? Realm(),
            let shareDefaults = UserDefaults(suiteName: appIdentifier) else { return }
        let todayPosts = realm.objects(Post.self).filter("dateText == %@", dateText).sorted(byKeyPath: "mealTime", ascending: true)
        
        // 1차 시도. 튜플 타입으로 저장하기 (mealTime: Int, mealTitle: String, rating: Int)
        // But, Tuple은 User Default로 보내기에 non-property-list라 전달 안됨.
        // *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'Attempt to insert non-property list object'
        
        // 2차 시도. 3개의 빈 Array 생성. 아침, 점심, 저녁으로 순서를 정해두고 title, rating 배열을 각각 생성해서 저장.
        var postsTitle: Array<String> = Array.init(repeating: "", count: 3)
        var postsRating: Array<Int> = Array.init(repeating: 3, count: 3)
        
        for post in todayPosts {
            switch post.mealTime {
            case 0:
                postsTitle[0] = post.mealTitle
                postsRating[0] = post.rating
            case 1:
                postsTitle[1] = post.mealTitle
                postsRating[1] = post.rating
            default:
                postsTitle[2] = post.mealTitle
                postsRating[2] = post.rating
            }
        }
        // 공유 UserDefault에 저장
        shareDefaults.set(postsTitle, forKey: "title")
        shareDefaults.set(postsRating, forKey: "rating")
        
        /***************************************************
         현재 테마 컬러셋 데이터
         ***************************************************/
        let themeKey = "ThemeNameRawValue"
        let currentTheme = UserDefaults.standard.value(forKey: themeKey) as? Int ?? 0
        
        let colorSet = [ColorSet.christmas, ColorSet.christmasLight, ColorSet.basic, ColorSet.sunset, ColorSet.macaron, ColorSet.redblue, ColorSet.jejuOcean, ColorSet.cherryBlossom, ColorSet.orange, ColorSet.heaven, ColorSet.cookieCream]
        let currentColor = colorSet[currentTheme]
        
        // 공유 UserDefault에 저장
        shareDefaults.setColor(currentColor.good, forkey: "good")
        shareDefaults.setColor(currentColor.soso, forkey: "soso")
        shareDefaults.setColor(currentColor.bad, forkey: "bad")
        
        /***************************************************
         주말 포함 여부(Bool) 저장
         ***************************************************/
        shareDefaults.set(Settings.custom.isIncludeWeekend, forKey: "isIncludeWeekend")
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
    
    
    
    // MARK: - UI
    func mealMatrixViewColorTheme() -> [UIColor] {
        let themeKey = "ThemeNameRawValue"
        let currentTheme = UserDefaults.standard.value(forKey: themeKey) as? Int ?? 0
        
        let colorSet = [ColorSet.christmas, ColorSet.christmasLight, ColorSet.basic, ColorSet.sunset, ColorSet.macaron, ColorSet.redblue, ColorSet.jejuOcean, ColorSet.cherryBlossom, ColorSet.orange, ColorSet.heaven, ColorSet.cookieCream]
        return colorSet[currentTheme].colors
    }
    
    
    func mealMatrixViewBackgroundColor() -> UIColor {
        let themeKey = "ThemeNameRawValue"
        let currentTheme = UserDefaults.standard.value(forKey: themeKey) as? Int ?? 0
        
        let colorSet = [ColorSet.christmas, ColorSet.christmasLight, ColorSet.basic, ColorSet.sunset, ColorSet.macaron, ColorSet.redblue, ColorSet.jejuOcean, ColorSet.cherryBlossom, ColorSet.orange, ColorSet.heaven, ColorSet.cookieCream]
        return colorSet[currentTheme].background
    }
    
    func updateAutoLayout() {
        userSetting.updateLayout(on: userSetting.isIncludeWeekend)
        
        guard let dateViewTop = userSetting.dateViewTopConstraint,
            let mealTableTop = userSetting.mealTableTopConstraint,
            let mealTableBottom = userSetting.mealTableBottomConstarint else { return }
        dateViewTopConstraint.constant = dateViewTop
        mealTableTopConstraint.constant = mealTableTop
        mealTableBottomConstarint.constant = mealTableBottom
        
        if userSetting.isIncludeWeekend {
            timeTablePropotinalHeight_isIncludeWeekend.priority = .defaultHigh
            timeTablePropotinalHeight_notIncludeWeekend.priority = .defaultLow
        } else {
            timeTablePropotinalHeight_isIncludeWeekend.priority = .defaultLow
            timeTablePropotinalHeight_notIncludeWeekend.priority = .defaultHigh
        }
        
        dayCollectionView.reloadData()
        postCollectionView.reloadData()
        mealMatrixView.layoutSubviews()
    }
    
}




// MARK: - UICollectionView DataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let weekendCount = 2
        
        switch collectionView.tag {
        case 0:
            return meal.count
        case 1:
            if userSetting.isIncludeWeekend {
                return day.count
            } else {
                return day.count - weekendCount
            }
        default:
            if userSetting.isIncludeWeekend {
                return posts.count
            } else {
                return posts.count - weekendCount * meal.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mealCell", for: indexPath) as! MealCell
            cell.mealData = indexPath.item
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCell
            cell.dayData = day[indexPath.item]
            if firstDateOfThisWeek.count != 0 {
                cell.dateData = firstDateOfThisWeek[indexPath.item]
            }
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
            
//            for fixed in fixedPosts {
//                let row = indexPath.item / 3 + 2
//                let column = indexPath.item % 3
//                if fixed.weekDay == row && fixed.time == column {
////                    cell.backgroundColor = .blue
//                }
//            }
            return cell
        }
    }
    
    // MARK: - move collectionView cell
    func collectionView(_ collectionView: UICollectionView,
                        moveItemAt sourceIndexPath: IndexPath,
                        to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else { return }
        
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
                
                for fixedPost in self.fixedPosts {
                    if fixedPost.time == post.mealTime {
                        nextVC._isFixedPost = true
                        nextVC.fixedPostsData = fixedPost
                        break
                    }
                }
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
        
        guard let basedHeight = userSetting.basedMealTableHeight,
            let cellSize = userSetting.basedPostCellSize else { return CGSize(width: 75, height: 65) }
        
        var width = (mealMatrixView.frame.width - 15) / 315
        var height = (mealMatrixView.frame.height - 15) / basedHeight
        let postCellSize: CGSize = cellSize
        
        
        let mealCellSize = CGSize(width: postCellSize.width, height: 35)
        let dayCellSize = CGSize(width: 60, height: postCellSize.height)
        
        switch collectionView.tag {
        case 0: // time
            width *= mealCellSize.width
            height *= mealCellSize.height
        case 1: // weekday
            width *= dayCellSize.width
            height *= dayCellSize.height
        default: // post
            width *= postCellSize.width
            height *= postCellSize.height
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        guard let basedHeight = userSetting.basedMealTableHeight,
            let cellSize = userSetting.basedPostCellSize,
            let dayData = userSetting.dayData else { return 1 }
        
        var height = (postCollectionView.frame.height - 15)
        let cellHeight = (mealMatrixView.frame.height - 15) * cellSize.height / basedHeight
        
        height = (height - cellHeight * CGFloat(dayData.count)) / CGFloat(dayData.count - 1)
        return height
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        var width = postCollectionView.frame.width - 15
        let cellWidth = (mealMatrixView.frame.width - 15) * 75 / 315
        width = (width - cellWidth * CGFloat(meal.count)) / CGFloat(meal.count - 1)
        
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
    
    
    func currentDateLabel(input: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = userSetting.currentDateFormat
        return dateFormatter.string(from: input)
    }
    
    func configureDateLabel(date: Date) {
        dateLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        dateLabel.text = "\(currentDateLabel(input: date)) ~"
        
        lastdateConfigure()
        
        if firstDateOfThisWeek.count == 7 {
            dateLabel.text = "\(currentDateLabel(input: date)) ~ \(lastDate)"
        }
    }
    
    
    
    @IBAction private func leftBtn() {
        let prevWeekDay = -7
        
        var dateComponent = DateComponents()
        dateComponent.day = prevWeekDay
        
        self.date = Calendar.current.date(byAdding: dateComponent, to: date)!
        posts = makePostMatrix(date: self.date)
        createPostsByFixed()
        posts = makePostMatrix(date: self.date)
        configureDateLabel(date: self.date)
    }
    
    @IBAction private func rightBtn() {
        let nextWeek = 60 * 60 * 24 * 7
        date = Date(timeInterval: TimeInterval(nextWeek), since: date)
        posts = makePostMatrix(date: self.date)
        createPostsByFixed()
        posts = makePostMatrix(date: self.date)
        configureDateLabel(date: date)
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
        let graphVC = self.storyboard?.instantiateViewController(withIdentifier: "GraphTableViewController") as! GraphTableViewController
        self.navigationController?.pushViewController(graphVC, animated: true)
    }
    
    @objc func moveSettingVC(_ : UIButton) {
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    
    // BarItem - Title
    func naviBarTitleLayout() {
        
        let backViewSize: CGFloat = 29
        let backViewMargin: CGFloat = 5
        
        let width: CGFloat = backViewSize * 3 + backViewMargin * 2
        let height: CGFloat = backViewSize
        
        let containerButton = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        let title: UILabel = UILabel()
        title.frame = containerButton.frame
        title.text = "Week-it"
        title.font = UIFont(name: "Montserrat-SemiBold", size: 17)
        title.textColor = UIColor.init(hex: "383838")
        title.textAlignment = .center
        
        
        let backView1: UIView = UIView(frame: CGRect(x: 0, y: 0, width: backViewSize, height: backViewSize))
        let backView2: UIView = UIView(frame: CGRect(x: backViewSize+backViewMargin, y: 0, width: backViewSize, height: backViewSize))
        let backView3: UIView = UIView(frame: CGRect(x: (backViewSize+backViewMargin)*2, y: 0, width: backViewSize, height: backViewSize))
        backView1.isUserInteractionEnabled = false
        backView2.isUserInteractionEnabled = false
        backView3.isUserInteractionEnabled = false
        
        backView1.backgroundColor = mealMatrixViewColorTheme()[0]
        backView2.backgroundColor = mealMatrixViewColorTheme()[1]
        backView3.backgroundColor = mealMatrixViewColorTheme()[2]
        
        backView1.layer.cornerRadius = 4
        backView2.layer.cornerRadius = 4
        backView3.layer.cornerRadius = 4
        
        containerButton.addSubview(backView1)
        containerButton.addSubview(backView2)
        containerButton.addSubview(backView3)
        containerButton.addSubview(title)
        
        containerButton.addTarget(self, action: #selector(moveCalendarToday(_:)), for: .touchUpInside)
        self.navigationItem.titleView = containerButton
        
    }
    
    // Title 누르면 현재 날짜로 돌아옴
    @objc func moveCalendarToday(_ : UIButton) {
        
        print("\n---------- [ moveCalendarToday ] -----------\n")
        self.date = Date()
        
        date = changeToMonday(of: date)
        self.posts = makePostMatrix(date: self.date)
        configureDateLabel(date: self.date)
    }
    
}
