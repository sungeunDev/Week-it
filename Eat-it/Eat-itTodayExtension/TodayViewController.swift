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
  
  @IBOutlet weak var viewMorning: UIView!
  @IBOutlet weak var viewNoon: UIView!
  @IBOutlet weak var viewNight: UIView!
  
  @IBOutlet weak var subViewMorning: UIView!
  @IBOutlet weak var subViewNoon: UIView!
  @IBOutlet weak var subViewNight: UIView!
  
  @IBOutlet weak var labelMorning: UILabel!
  @IBOutlet weak var labelNoon: UILabel!
  @IBOutlet weak var labelNight: UILabel!
  
  
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
        
//        goodPercentLabel.text = String(ratingIsGood[2]) + "%"
//        print(ratingIsGood)
      }
      
      
      
      
//      deta.layer.cornerRadius = 7

      
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let radius: CGFloat = 7
    viewMorning.layer.cornerRadius = radius
    viewNoon.layer.cornerRadius = radius
    viewNight.layer.cornerRadius = radius
    
    subViewMorning.cornerRoundOnlyTop(radius: radius)
    subViewNoon.cornerRoundOnlyTop(radius: radius)
    subViewNight.cornerRoundOnlyTop(radius: radius)
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
//    let dateText = date.trasformInt(from: date)
    
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

extension UIView {
  
  public func cornerRoundOnlyTop(radius: CGFloat) {
    if #available(iOS 11.0, *){
      self.clipsToBounds = false
      self.layer.cornerRadius = radius
      self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }else{
      let rectShape = CAShapeLayer()
      rectShape.bounds = self.frame
      rectShape.position = self.center
      rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius*2, height: radius*2)).cgPath
      self.layer.mask = rectShape
    }
  }
}
