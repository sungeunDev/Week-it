//
//  AppDelegate.swift
//  EatIt
//
//  Created by sungnni on 2018. 5. 16..
//  Copyright © 2018년 AppKings. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  lazy var coreDataStack = CoreDataStack(modelName: "PostModel")
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    guard let navController = window?.rootViewController as? UINavigationController,
      let mainViewController = navController.topViewController as? MainViewController else { return true }
    
    mainViewController.managedContext = coreDataStack.managedContext
    return true
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    coreDataStack.saveContext()
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    coreDataStack.saveContext()
  }
  
  
}

