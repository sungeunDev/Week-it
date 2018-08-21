//
//  DevInfoViewController.swift
//  Eat-it
//
//  Created by sungnni on 2018. 7. 1..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit
import SafariServices

class DevInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }

  
  @IBAction private func goToGitHubAction() {
    let gitHubUrl = "https://github.com/sungeunDev"
    openSafariViewOf(url: gitHubUrl)
  }
  
//  @IBAction private func goToFaceBookAction() {
//    let userName = "sungeun.park.96199"
//    openSafariViewOf(url: "https://www.facebook.com/\(userName)")
//  }
  
//  @IBAction private func goToInstagramAction() {
//    let userName = "ssungnni"
//    let appURL = URL(string: "instagram://user?username=\(userName)")
//    guard let url = appURL else { return }
//    if UIApplication.shared.canOpenURL(url) {
//      UIApplication.shared.open(url, options: [:], completionHandler: nil)
//    } else {
//      openSafariViewOf(url: "https://www.instagram.com/\(userName)")
//    }
//  }
  
  
  func openSafariViewOf(url: String) {
    guard let url = URL(string: url) else { return }
    
    let safariViewController = SFSafariViewController(url: url)
    self.present(safariViewController, animated: true, completion: nil)
  }

}

extension DevInfoViewController: SFSafariViewControllerDelegate {

}
