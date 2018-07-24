//
//  SettingViewController.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 11..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit
import MessageUI

import RealmSwift

class SettingViewController: UITableViewController {
  
  @IBOutlet weak var appVersionLabel: UILabel!
  @IBOutlet weak var isIncludeWeekendSwitch: UISwitch!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    isIncludeWeekendSwitch.setOn(Settings.custom.isIncludeWeekend, animated: false)
    
    appVersionLabel.text = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    setNaviBackBtn()
  }
  
  // MARK: - includeWeekend Switch Action
  /// 일주일을 주말까지 포함할건지 조작하는 스위치.
  /// 포함여부를 UserDefault에 Bool 타입으로 저장
  /// - Parameter sender:
  ///   - On인 경우, 주말 포함
  ///   - Off인 경우, 평일만
  @IBAction func isIncludeWeekend(_ sender: UISwitch) {
    Settings.custom.setIsIncludeWeeknd(isIncludeWeekend: sender.isOn)
  }
  

  
  // MARK: TableView DidSelect
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    switch indexPath.section {
    case 0: // SETTING
      if indexPath.row == 1 {
        // 데이터 초기화
        resetData()
      }
    case 2: // FEEDBACK
      switch indexPath.row {
      case 0:
        print("\n---------- [ 별점주기 ] -----------\n")
        let appDelegate = AppDelegate()
        appDelegate.requestReview()

      case 1:
        print("\n---------- [ send mail ] -----------\n")
        sendEmailForFeedback()
      case 2: // 개발자 소개
        print("\n---------- [ move introduce developer VC ] -----------\n")
      default:
        print("other row")
      }
      
    default:
      print("other section")
    }
  }
  
}

// MARK: - didSelect Action
extension SettingViewController {
  
  func resetData() {
    let askAlert = UIAlertController(title: "Reset Data".localized,
                                     message: "If you reset the data,\n you can't recover it again.\n Do you really want to initialize it?".localized, preferredStyle: .alert)
    
    let okay = UIAlertAction(title: "reset".localized, style: .destructive) { (action) in
      let realm = try! Realm()
      try! realm.write {
        print("\n---------- [ RESET REALM DATA ] -----------\n")
        realm.deleteAll()
      }
      self.navigationController?.popToRootViewController(animated: true)
    }
    let cancle = UIAlertAction(title: "cancle".localized, style: .cancel, handler: nil)
    
    askAlert.addAction(okay)
    askAlert.addAction(cancle)
    
    self.present(askAlert, animated: true, completion: nil)
  }
  
  
  func sendEmailForFeedback() {
    let userSystemVersion = UIDevice.current.systemVersion
    let userAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    let mailComposeViewController = self.configuredMailComposeViewController(emailAddress: "p.ssungnni@gmail.com", systemVersion: userSystemVersion, appVersion: userAppVersion!)
    
    if MFMailComposeViewController.canSendMail() {
      self.present(mailComposeViewController, animated: true, completion: nil)
    }
  }
  
  func configuredMailComposeViewController(emailAddress:String, systemVersion:String, appVersion:String) -> MFMailComposeViewController {
    let mailComposerVC = MFMailComposeViewController()
    mailComposerVC.mailComposeDelegate = self
    
    mailComposerVC.setToRecipients([emailAddress])
    mailComposerVC.setSubject("[WEEKIT] Feedback")
    mailComposerVC.setMessageBody(
      "Thank you for your feedback. I will update an app in future.\n".localized +
      """
      
      -----------------------------
      - iOS Version: \(systemVersion)
      - App Version: \(appVersion)
      """
      , isHTML: false)
    return mailComposerVC
  }
  
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }
}
