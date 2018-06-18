//
//  TodayViewController.swift
//  Eat-itTodayExtension
//
//  Created by sungnni on 2018. 6. 18..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit
import NotificationCenter

import RealmSwift

class TodayViewController: UIViewController, NCWidgetProviding {
  
  
  @IBOutlet weak var testView: UIView!
  @IBOutlet weak var testViewSub: UIView!
  
  // 아침, 점심, 저녁
  @IBOutlet weak var meal1Label: UILabel!
  @IBOutlet weak var meal2Label: UILabel!
  @IBOutlet weak var meal3Label: UILabel!
  
  @IBOutlet weak var goodPercentLabel: UILabel!
  
  let date = Date()
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      let appIdentifier = "group.com.middd.TodayExtensionSharingDefaults"
      
      if let shareDefaults = UserDefaults(suiteName: appIdentifier),
        let todayPosts = shareDefaults.object(forKey: "todayPosts") as? [[String:Int]],
        let ratingIsGood = shareDefaults.object(forKey: "todayPostsRating") as? [Int] {

        print(todayPosts)
        
//        meal1Label.text = todayPosts[0]
//        meal2Label.text = todayPosts[1]
//        meal3Label.text = todayPosts[2]
        
        goodPercentLabel.text = String(ratingIsGood[2]) + "%"
        print(ratingIsGood)
      }
      
      
      
      
      testView.layer.cornerRadius = 7
      testViewSub.layer.borderWidth = 1
      testViewSub.layer.borderColor = UIColor.darkGray.cgColor

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}


// MARK: - Fetch Realm Data
extension TodayViewController {
  
  
  func fetchTodayPost() {
    let dateText = date.trasformInt(from: date)
    
//    if let realm = try? Realm() {
//      var posts = realm.objects(Post.self)
//      posts = posts.filter("dateText == %@", dateText)
//      print(posts)
//    }
    
    
    
  }
  
}


// MARK: - Support
extension Date {
  
  public func trasformInt(from date: Date) -> Int {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "yyyyMMdd"
    let str = dateFormatter.string(from: date)
    
    return Int(str)!
  }
}
