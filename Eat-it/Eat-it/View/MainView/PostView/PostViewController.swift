//
//  PostViewController.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 7..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit
import RealmSwift

class PostViewController: UITableViewController {
    
    public var mealTime: Int?
    public var date: Date?
    
    public var postData: Post?
    
    @IBOutlet private weak var dateLabel: UILabel!
    
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet private weak var mealLabel: UILabel!
    
    @IBOutlet private weak var menuTextField: UITextField!
    @IBOutlet private weak var seg: UISegmentedControl!
    
    let currentTheme: [UIColor] = UIColor().currentTheme()
    
    var postUsecase: PostUsecase = PostUsecase()
    
    @IBOutlet private weak var checkboxImageView: UIImageView!
    var _isFixedPost: Bool = false
    var isFixedPost: Bool = false {
        willSet {
            let imageName = newValue ? "clickedCheckbox" : "emptyCheckbox"
            checkboxImageView.image = UIImage(named: imageName)
        }
    }
    
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
        savePostProcess()
        saveMonthlyNumOfPostProcess()
        saveFixedPostProcess()
    }
    
    func savePostProcess() {
        if postData != nil {
            guard let id = self.postData?.postId else { return }
            postUsecase.updatePost(keyId: id,
                                   title: menuTextField.text!,
                                   rating: seg.selectedSegmentIndex)
        } else {
            let post = postUsecase.createPost(date: date!,
                                              rating: seg.selectedSegmentIndex,
                                              time: mealTime!,
                                              title: menuTextField.text!)
            postUsecase.saveRealmDB(post)
            EventTrackingManager.createPostLog(time: mealTime!,
                                               rate: seg.selectedSegmentIndex,
                                               contents: menuTextField.text!)
        }
    }
    
    func saveFixedPostProcess() {
        let weekDay = Calendar.current.component(.weekday, from: date!)
        let numOfFixedPost = postUsecase
            .allFixedPost
            .filter("weekDay == %@ AND time == %@", weekDay, mealTime!)
        
        if numOfFixedPost.count > 0 {
            guard let id = numOfFixedPost.first?.fixedPostId else { return }
            if self.isFixedPost {
                postUsecase.updateFixedPost(keyId: id,
                                            title: menuTextField.text!,
                                            rating: seg.selectedSegmentIndex)
            } else {
                postUsecase.deleteFixedPost(keyId: id)
            }
        } else {
            let fixedPost = postUsecase.createFixedPost(title: menuTextField.text!,
                                                        rating: seg.selectedSegmentIndex,
                                                        time: mealTime!,
                                                        weekDay: weekDay)
            postUsecase.saveRealmDB(fixedPost)
        }
    }
    
    func saveMonthlyNumOfPostProcess() {
        let month = date!.transformIntOnlyMonth()
        let numOfMonthlyPost = postUsecase
            .allNumOfPost
            .filter("dateInt == %@", month)
        if postUsecase.allNumOfPost.count == 0 || numOfMonthlyPost.count == 0 {
            let monthPost = postUsecase.createNumOfPost(date: date!)
            postUsecase.saveRealmDB(monthPost)
        } else {
            let id = numOfMonthlyPost[0].dateInt // numOfMonthlyPost는 항상 1개만 존재
            postUsecase.updateMonthlyNumOfPost(keyId: id, addNum: 1)
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
        if let realm = try? Realm(),
            let id = self.postData?.postId,
            let post = realm.object(ofType: Post.self, forPrimaryKey: id),
            let month = Int(String(post.dateText).dropLast(2) + "00"),
            let numOfPost = realm.object(ofType: NumOfPost.self, forPrimaryKey: month) {
            
            try! realm.write {
                realm.delete(post)
                if numOfPost.numOfpost == 1 {
                    realm.delete(numOfPost)
                } else {
                    numOfPost.numOfpost -= 1
                }
            }
            popVC()
        }
    }
    
    func deleteClicked() {
        if let id = self.postData?.postId {
            postUsecase.deletePost(keyId: id)
        } else {
            showAlert(alertTitle: "Delete Fail".localized,
                      message: "There are no posts to delete.\nPlease register your post.".localized,
                      actionTitle: "OK".localized)
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
