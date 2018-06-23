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
  
  
  // MARK: - LIFE CYCLE
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configuration()
    seg.tintColor = currentTheme[seg.selectedSegmentIndex]
    
    menuTextField.delegate = self
    menuTextField.becomeFirstResponder()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  // MARK: - CONFIGURATION
  func configuration() {
    if let postData = postData {
      menuTextField.text = postData.mealTitle
      seg.selectedSegmentIndex = postData.rating
      
    }
    
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd"
    
    if let mealIdx = mealTime,
      let date = date {
      
      let mealTime = ["아침", "점심", "저녁"]
      let mealImage = [#imageLiteral(resourceName: "mealTime_morning"), #imageLiteral(resourceName: "mealTime_noon"), #imageLiteral(resourceName: "mealTime_night")]
      mealLabel.text = mealTime[mealIdx]
      mealImageView.image = mealImage[mealIdx]
      
      dateLabel.text = format.string(from: date)
    }
    
  }
  
  
  // MARK: - SAVE ACTION
  @IBAction private func saveBtn() {
    menuTextField.resignFirstResponder()
    
    savePost()
    popVC()
  }
  
  func savePost() {
    if menuTextField.text?.count != 0 {
      if let _ = postData {
        updateTask(title: menuTextField.text!, rating: seg.selectedSegmentIndex)
      } else {
        let realm = try! Realm()
        let post = Post(date: date!, rating: seg.selectedSegmentIndex, mealTime: mealTime!, mealTitle: menuTextField.text!)
        saveMonthlyNumOfPost(date: date!)
        
        try! realm.write {
          realm.add(post)
        }
      }
      
    } else {
      let alert = UIAlertController(title: "Post fail", message:
        """
        메뉴를 적어주세요.
        """, preferredStyle: .alert)
      let action = UIAlertAction(title: "확인", style: .default, handler: nil)
      alert.addAction(action)
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  func updateTask(title: String, rating: Int) {
    if let realm = try? Realm(),
      let id = self.postData?.postId,
      let post = realm.object(ofType: Post.self, forPrimaryKey: id) {
      
      try! realm.write {
        post.mealTitle = title
        post.rating = rating
      }
    }
  }
  
  
  func saveMonthlyNumOfPost(date: Date) {
    
    let realm = try! Realm()
    let allNumOfPost = realm.objects(NumOfPost.self)
    let month = date.transformIntOnlyMonth(from: date)
    
    let numOfPost = allNumOfPost.filter("dateInt == %@", month)
    
    if allNumOfPost.count == 0 || numOfPost.count == 0 {
      print("최초 추가")
      let monthPost = NumOfPost(date: date)
      try! realm.write {
        realm.add(monthPost)
      }
    } else {
      print("기존거에 추가")
      let id = numOfPost[0].dateInt
      if let monthlyNumOfPost = realm.object(ofType: NumOfPost.self, forPrimaryKey: id) {
        try! realm.write {
          monthlyNumOfPost.numOfpost += 1
        }
      }
    }
  }
  
  // MARK: - DELETE ACTION
  @IBAction private func deleteBtn() {
    
    if let realm = try? Realm(),
      let id = self.postData?.postId,
      let post = realm.object(ofType: Post.self, forPrimaryKey: id),
      let month = Int(String(post.dateText).dropLast(2) + "00"),
      let numOfPost = realm.object(ofType: NumOfPost.self, forPrimaryKey: month) {
      
      try! realm.write {
//        delete post
        print("\n---------- [ 삭제 ] -----------\n")
        realm.delete(post)
        
//        delete number of post
        if numOfPost.numOfpost == 1 {
          realm.delete(numOfPost)
        } else {
          numOfPost.numOfpost -= 1
        }
      }
      popVC()
    } else {
      let alert = UIAlertController(title: "Delete fail", message:
        """
        삭제 할 포스트가 없습니다.
        포스트를 등록해 주세요.
        """, preferredStyle: .alert)
      let action = UIAlertAction(title: "확인", style: .default, handler: nil)
      alert.addAction(action)
      self.present(alert, animated: true, completion: nil)
    }
    
  }
  
  
  @IBAction func changeSegTintColor(_ sender: UISegmentedControl) {
    
    sender.tintColor = self.currentTheme[sender.selectedSegmentIndex]
  }
  
  
}

// MARK: TextField Delegate
extension PostViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    menuTextField.resignFirstResponder()
    
    savePost()
    popVC()
    
    return true
  }
  
  func popVC() {
    self.navigationController?.popViewController(animated: true)
  }
}

