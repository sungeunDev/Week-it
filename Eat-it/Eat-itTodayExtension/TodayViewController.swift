//
//  TodayViewController.swift
//  Eat-itTodayExtension
//
//  Created by sungnni on 2018. 6. 18..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit
import NotificationCenter
//import RealmSwift

class TodayViewController: UIViewController, NCWidgetProviding {
  
  @IBOutlet weak var superViewMorning: UIView!
  @IBOutlet weak var superViewNoon: UIView!
  @IBOutlet weak var superViewNight: UIView!
  
  @IBOutlet weak var viewMorning: UIView!
  @IBOutlet weak var viewNoon: UIView!
  @IBOutlet weak var viewNight: UIView!
  
  @IBOutlet weak var subViewMorning: UIView!
  @IBOutlet weak var subViewNoon: UIView!
  @IBOutlet weak var subViewNight: UIView!
  
  @IBOutlet weak var labelMorning: UILabel!
  @IBOutlet weak var labelNoon: UILabel!
  @IBOutlet weak var labelNight: UILabel!
  
  @IBOutlet weak var plusIconMorning: UIImageView!
  @IBOutlet weak var plusIconNoon: UIImageView!
  @IBOutlet weak var plusIconNight: UIImageView!
  
  @IBOutlet weak var weekendInfoLabel: UILabel!
  
  let date = Date()

  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    print("\n---------- [ viewDidLoad ] -----------\n")
    updateLayout()
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let radius: CGFloat = 5
    viewMorning.layer.cornerRadius = radius
    viewNoon.layer.cornerRadius = radius
    viewNight.layer.cornerRadius = radius
    
    subViewMorning.cornerRoundOnlyTop(radius: radius)
    subViewNoon.cornerRoundOnlyTop(radius: radius)
    subViewNight.cornerRoundOnlyTop(radius: radius)
  }
  
  // MARK: - Method
  func updateLayout() {
    let appIdentifier = "group.com.middd.TodayExtensionSharingDefaults"
    
    // fetch today's posts
    if let shareDefaults = UserDefaults(suiteName: appIdentifier),
      let titles = shareDefaults.array(forKey: "title") as? [String],
      let ratings = shareDefaults.array(forKey: "rating") as? [Int],
      
      let good = shareDefaults.colorForKey(key: "good"),
      let soso = shareDefaults.colorForKey(key: "soso"),
      let bad = shareDefaults.colorForKey(key: "bad") {
      
      // title update
      for (idx, title) in titles.enumerated() {
        if title.count != 0 {
          switch idx {
          case 0:
            labelMorning.text = titles[0]
          case 1:
            labelNoon.text = titles[1]
          default:
            labelNight.text = titles[2]
          }
        } else {
          let plusIconImage = #imageLiteral(resourceName: "plusIcon.png")
          switch idx {
          case 0:
            plusIconMorning.image = plusIconImage
          case 1:
            plusIconNoon.image = plusIconImage
          default:
            plusIconNight.image = plusIconImage
          }
        }
      }
      
      // rating update
      let colors = [good, soso, bad]
      ratingColorUIUpdate(rating: ratings[0], view: viewMorning, colors: colors)
      ratingColorUIUpdate(rating: ratings[1], view: viewNoon, colors: colors)
      ratingColorUIUpdate(rating: ratings[2], view: viewNight, colors: colors)
      
      updateWeekendPost(isIncludeWeekend: shareDefaults.bool(forKey: "isIncludeWeekend"))
    }
  }
  
  // 평일만 이용하는 경우, 주말에 위젯 표기 변경
  func updateWeekendPost(isIncludeWeekend: Bool) {
    let weekday = Calendar(identifier: .gregorian).component(.weekday, from: self.date)
    if !isIncludeWeekend && (weekday == 1 || weekday == 7) {
      superViewMorning.isHidden = true
      superViewNoon.isHidden = true
      superViewNight.isHidden = true
      weekendInfoLabel.isHidden = false
      weekendInfoLabel.alpha = 1
    } else {
      superViewMorning.isHidden = false
      superViewNoon.isHidden = false
      superViewNight.isHidden = false
      weekendInfoLabel.isHidden = true
      weekendInfoLabel.alpha = 0
    }
  }
  
  func ratingColorUIUpdate(rating: Int, view: UIView, colors: [UIColor]) {
    self.view.layoutIfNeeded()
    switch rating {
    case 0:
      view.backgroundColor = colors[0]
    case 1:
      view.backgroundColor = colors[1]
    case 2:
      view.backgroundColor = colors[2]
    default:
      view.backgroundColor = UIColor.lightGray
    }
  }
  
  /********************************************/
  //MARK:-       Methods | IBAction           //
  /********************************************/
  
  //Widget을 한번 탭하면 앱이 열리도록 설정
  @IBAction func toOpenApp(_ sender: UITapGestureRecognizer) {
    let myApp = URL(string: "main-weekit:")!
    extensionContext?.open(myApp, completionHandler: { (success) in
      if (!success) {
        print("ERROR: failed to open app from Today Extension")
      }
    })
  }
  
  
  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    
    
    completionHandler(NCUpdateResult.newData)
  }
}

