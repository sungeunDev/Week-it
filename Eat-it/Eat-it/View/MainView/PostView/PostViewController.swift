//
//  PostViewController.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 7..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit
import RealmSwift

class PostViewController: UITableViewController, AlertService {
    
    public var mealTime: Int?
    public var date: Date? {
        willSet {
            guard let date = newValue else { return }
            weekDay = Calendar.current.component(.weekday, from: date)
        }
    }
    public var weekDay: Int = 0
    
    public var postData: Post?
    public var fixedPostsData: RealmFixedPost?
    var afterPosts: Results<Post>?
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet private weak var mealLabel: UILabel!
    
    @IBOutlet private weak var menuTextField: UITextField!
    @IBOutlet private weak var seg: UISegmentedControl!
    
    let currentTheme: [UIColor] = UIColor().currentTheme()
    
    var dbManager: DBManager = DBManager()
    
    @IBOutlet private weak var checkboxImageView: UIImageView!
    var _isFixedPost: Bool = false
    var isFixedPost: Bool = false {
        willSet {
            let imageName = newValue ? "clickedCheckbox" : "emptyCheckbox"
            checkboxImageView.image = UIImage(named: imageName)
        }
    }

    var fixedPostId: String?
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
        setSegmentedControlText(seg)
        seg.tintColor = currentTheme[seg.selectedSegmentIndex]
        
        menuTextField.delegate = self
        menuTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isFixedPost = self._isFixedPost
        setAfterPosts()
    }
    
    // MARK: - CONFIGURATION
    func configuration() {
        if let postData = postData {
            menuTextField.text = postData.mealTitle
            seg.selectedSegmentIndex = postData.rating
        }
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd (E)"
        
        if let mealIdx = mealTime, let date = date {
            let mealTime = ["Morning".localized, "Afternoon".localized, "Evening".localized]
            let mealImage = [#imageLiteral(resourceName: "mealTime_morning"), #imageLiteral(resourceName: "mealTime_noon"), #imageLiteral(resourceName: "mealTime_night")]
            mealLabel.text = mealTime[mealIdx]
            mealImageView.image = mealImage[mealIdx]
            dateLabel.text = format.string(from: date)
        }
        
        let imageName = isFixedPost ? "clickedCheckbox" : "emptyCheckbox"
        checkboxImageView.image = UIImage(named: imageName)
    }
    
    
    // MARK: - SAVE ACTION
    @IBAction private func saveBtn() {
        menuTextField.resignFirstResponder()
        saveBtnClicked()
        popVC()
    }
    
    func saveBtnClicked() {
        guard menuTextField.text?.count != 0 else {
            showAlert(alertTitle: "Post Fail".localized,
                      message: "Please fill in the blank.".localized,
                      actionTitle: "OK".localized)
            return
        }
        // 아래 3개가 post usecase로 빠져야 함.
        saveFixedPostProcess()
        savePostProcess()
        setAfterPosts()
        
    }
    
    func savePostProcess() {
        // 기존 포스트를 업데이트 하는 경우
        if postData != nil {
            guard let id = self.postData?.postId else { return }
            if isFixedPost {
                guard let fixedPostId = self.fixedPostId else { return }
                dbManager.updatePost(keyId: id,
                                     title: menuTextField.text!,
                                     rating: seg.selectedSegmentIndex,
                                     fixedPostId: fixedPostId)
            }
        // 새로 포스트를 만드는 경우
        } else {
            if isFixedPost {
                guard let fixedPostId = self.fixedPostId else { return }
                let post = dbManager.createPost(date: date!,
                                                rating: seg.selectedSegmentIndex,
                                                time: mealTime!,
                                                title: menuTextField.text!,
                                                fixedPostId: fixedPostId)
                dbManager.saveRealmDB(post)
            } else {
                let post = dbManager.createPost(date: date!,
                                                rating: seg.selectedSegmentIndex,
                                                time: mealTime!,
                                                title: menuTextField.text!)
                dbManager.saveRealmDB(post)
            }
            self.saveMonthlyNumOfPostProcess()
        }
        EventTrackingManager.createPostLog(time: mealTime!,
                                           rate: seg.selectedSegmentIndex,
                                           contents: menuTextField.text!)
    }
    
    func setAfterPosts() {
        let deleteDateInt = self.date!.trasformInt()
        let allPosts = dbManager.getAllObject(of: Post.self)
        self.afterPosts = allPosts.filter("dateText > %@ AND mealTime == %@",
                                          deleteDateInt,
                                          mealTime!)
    }
    
    func saveFixedPostProcess() {
        let numOfFixedPost = dbManager
            .getAllObject(of: RealmFixedPost.self)
            .filter("weekDay == %@ AND time == %@", weekDay, mealTime!)
        
        // 해당 요일, 시간에 고정포스트가 있을 경우
        if numOfFixedPost.count > 0 {
            guard let id = numOfFixedPost.first?.fixedPostId else { return }
            
            // 현재 고정 포스트를 선택한 경우 -> 현재꺼 삭제 후 새로 생성 & 포스트 id도 변경
            if self.isFixedPost {
                dbManager.deleteDB(realmData: RealmFixedPost.self, keyId: id)
                let newFixedPost = dbManager.createFixedPost(title: menuTextField.text!,
                                          rating: seg.selectedSegmentIndex,
                                          time: mealTime!,
                                          weekDay: weekDay,
                                          setDate: self.date!)
                dbManager.saveRealmDB(newFixedPost)
                self.fixedPostId = newFixedPost.fixedPostId
                
            // 선택 안한경우 -> 이후 포스트들 & fixed post 삭제
            } else {
                // fixed post를 삭제한 날짜 이후의 post들은 모두 삭제함
                let currentDateInt = self.date!.trasformInt()
                
                let allPosts = dbManager.getAllObject(of: Post.self)
                let afterPosts = allPosts.filter("fixedPostId == %@ AND dateText > %@",
                                                 id,
                                                 currentDateInt)
                for afterPost in afterPosts {
                    let numOfPostKey = afterPost.date.transformIntOnlyMonth()
                    if let numOfPost = dbManager.getObject(of: NumOfPost.self, keyId: numOfPostKey) {
                        deletePostProcess(post: afterPost, numOfPost: numOfPost)
                    }
                }
                
                // fixed post 삭제
                dbManager.deleteDB(realmData: RealmFixedPost.self, keyId: id)
            }
        // 해당 요일, 시간에 해당하는 고정포스트가 없을 경우
        } else {
            // isFixed로 체크했을 경우에는 새로 생성해서 저장
            if self.isFixedPost {
                let fixedPost = dbManager.createFixedPost(title: menuTextField.text!,
                                                          rating: seg.selectedSegmentIndex,
                                                          time: mealTime!,
                                                          weekDay: weekDay,
                                                          setDate: self.date!)
                self.fixedPostId = fixedPost.fixedPostId
                dbManager.saveRealmDB(fixedPost)
            }
        }
    }
    
    func saveMonthlyNumOfPostProcess() {
        let month = date!.transformIntOnlyMonth()
        let numOfMonthlyPost = dbManager
            .getAllObject(of: NumOfPost.self)
            .filter("dateInt == %@", month)
        if dbManager.getAllObject(of: NumOfPost.self).count == 0 || numOfMonthlyPost.count == 0 {
            let monthPost = dbManager.createNumOfPost(date: date!)
            dbManager.saveRealmDB(monthPost)
        } else {
            let id = numOfMonthlyPost[0].dateInt // numOfMonthlyPost는 항상 1개만 존재
            dbManager.updateMonthlyNumOfPost(keyId: id, addNum: 1)
        }
    }
    
    func showAlert(alertTitle: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: alertTitle,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle,
                                   style: .default) { (_) in
                                    self.menuTextField.becomeFirstResponder()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - DELETE ACTION
    @IBAction private func deleteBtn() {
        guard let postData = self.postData else {
            showAlert(alertTitle: "Delete Fail".localized,
                      message: "There are no posts to delete.\nPlease register your post.".localized,
                      actionTitle: "OK".localized)
            return }
        
        guard let post = dbManager.getObject(of: Post.self, keyId: postData.postId),
            let month = Int("\(post.dateText)".dropLast(2) + "00"),
            let numOfPost = dbManager.getObject(of: NumOfPost.self, keyId: month)
            else { return }
        
        // 삭제하려는 포스트가 고정일때
        if dbManager.isCurrentFixedPost(post: post) {
            let alert = showTwoAlert(alertTitle: "Delete pinned post".localized,
                                     message: "Other posts created with the pinning feature will not be deleted.".localized,
                                     firstAction: "Cancel".localized, firstCompletion: nil,
                                     secondAction: "OK".localized) { [weak self] action in
                                        self?.dbManager.deleteDB(realmData: RealmFixedPost.self, keyId: post.fixedPostId)
                                        self?.deletePostProcess(post: post, numOfPost: numOfPost)
                                        self?.popVC() }
            self.present(alert, animated: true, completion: nil)
        } else {
            deletePostProcess(post: post, numOfPost: numOfPost)
            popVC()
        }
    }
    
    func deletePostProcess(post: Post, numOfPost: NumOfPost) {
        dbManager.deleteDB(realmData: Post.self, keyId: post.postId)
        if numOfPost.numOfpost == 1 {
            dbManager.deleteDB(realmData: NumOfPost.self, keyId: numOfPost.dateInt)
        } else {
            dbManager.updateMonthlyNumOfPost(keyId: numOfPost.dateInt, addNum: -1)
        }
    }
    
    @IBAction func changeSegTintColor(_ sender: UISegmentedControl) {
        sender.tintColor = self.currentTheme[sender.selectedSegmentIndex]
        setSegmentedControlText(sender)
    }
    
    func setSegmentedControlText(_ sender: UISegmentedControl) {
        var str = "⭐️⭐️⭐️"
        for _ in 0..<sender.selectedSegmentIndex {
            str = String(str.dropLast())
        }
        seg.setTitle(str, forSegmentAt: sender.selectedSegmentIndex)
        switch sender.selectedSegmentIndex {
        case 0:
            seg.setTitle("★★", forSegmentAt: sender.selectedSegmentIndex+1)
            seg.setTitle("★", forSegmentAt: sender.selectedSegmentIndex+2)
        case 1:
            seg.setTitle("★★★", forSegmentAt: sender.selectedSegmentIndex-1)
            seg.setTitle("★", forSegmentAt: sender.selectedSegmentIndex+1)
        case 2:
            seg.setTitle("★★★", forSegmentAt: sender.selectedSegmentIndex-2)
            seg.setTitle("★★", forSegmentAt: sender.selectedSegmentIndex-1)
        default:
            print("out of range")
        }
    }
}

// MARK: TextField Delegate
extension PostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        menuTextField.resignFirstResponder()
        saveBtnClicked()
        popVC()
        return true
    }
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - TableView
extension PostViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 4:
            self.isFixedPost = !self.isFixedPost
        default:
            ()
        }
    }
}
