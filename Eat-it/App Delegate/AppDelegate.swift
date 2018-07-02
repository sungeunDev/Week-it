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
  //    let transitionCoordinator = TransitionCoordinator()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
            Thread.sleep(forTimeInterval: 2.0)
    // Override point for customization after application launch.
    //        let board = UIStoryboard(name: "Main", bundle: nil)
    //        let main = board.instantiateInitialViewController()
    //        let nav = main?.navigationController
    //        nav?.delegate = transitionCoordinator
    
    
    /***************************************************
      REALM CONFIGULATION
     ***************************************************/
    
//    let fileURL = Bundle.main.url(forResource: "MyBundleData", withExtension: "realm")
//    let config = Realm.Configuration(fileURL: fileURL, readOnly: true)
//
//    // Open the Realm with the configuration
//    let realm = try! Realm(configuration: config)
//
//    let date = Date().trasformInt(from: Date())
//
//
//    // Read some data from the bundled Realm
//    let results = realm.objects(Post.self).filter("dataText == %@", date)
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    let appIdentifier = "group.com.middd.TodayExtensionSharingDefaults"
//    let fileManager = FileManager.default
//    if let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appIdentifier) {
//      let realmPath = directory.appendingPathComponent("db.realm")
//      Realm.Configuration.defaultConfiguration = realmPath
      
    
//    }
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

