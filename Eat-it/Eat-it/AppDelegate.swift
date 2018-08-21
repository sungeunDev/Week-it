//
//  AppDelegate.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 5..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit
import StoreKit

import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    return true
  }
}

// MARK: - StoreKit
extension AppDelegate {
  func requestReview() {
    SKStoreReviewController.requestReview()
  }
  
  func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
    guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
      completion(false)
      return
    }
    guard #available(iOS 10, *) else {
      completion(UIApplication.shared.openURL(url))
      return
    }
    UIApplication.shared.open(url, options: [:], completionHandler: completion)
  }
}
