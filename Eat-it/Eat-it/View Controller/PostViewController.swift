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
  
  @IBOutlet private weak var mealLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var menuTextField: UITextField!
  @IBOutlet private weak var seg: UISegmentedControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configuration()
    
    menuTextField.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    menuTextField.becomeFirstResponder()
  }
  
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
      mealLabel.text = mealTime[mealIdx]
      dateLabel.text = format.string(from: date)
    }
  }
  
  @IBAction private func saveBtn() {
    menuTextField.resignFirstResponder()
    
    savePost()
    popVC()
  }
  
  func savePost() {
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
  
  
  func popVC() {
    self.navigationController?.popViewController(animated: true)
  }
  
}


extension PostViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    menuTextField.resignFirstResponder()
    
    savePost()
    popVC()
    
    return true
  }
}
