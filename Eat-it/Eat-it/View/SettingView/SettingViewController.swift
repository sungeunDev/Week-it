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

enum DateFormatStyle: String {
  case koBasic = "yyyy. MM. dd" // 2018. 07. 30
  case koDash = "yyyy-MM-dd" // 2018-07-30
  case us = "MM/dd/yyyy" //07/30/2018
  case uk = "dd/MM/yyyy" // 30/07/2018
  case usMonth = "MMM dd, yyyy" // Jul 30, 2018
  case ukMonth = "dd MMM, yyyy" // 30 Jul, 2018
}

class SettingViewController: UITableViewController {
  
  @IBOutlet weak var isIncludeWeekendSwitch: UISwitch!
  @IBOutlet weak var appVersionLabel: UILabel!
  
  @IBOutlet weak var dateTextfield: UITextField!
  let dateFormatStyle: [DateFormatStyle] = [.koBasic, .koDash, .us, .uk, .usMonth, .ukMonth]
  var datePicker: UIPickerView = UIPickerView()
  var pickerSelectRow = 0
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    isIncludeWeekendSwitch.setOn(Settings.custom.isIncludeWeekend, animated: false)
    
    appVersionLabel.text = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    setNaviBackBtn()
    
    datePicker.delegate = self
    datePicker.dataSource = self
    
    dateTextfield.text = dateConvertString(with: Settings.custom.currentDateFormat)
    setCurrentDateFormat()
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

  
  // MARK: - TableView DidSelect
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    switch indexPath.section {
    case 0: // SETTING
      switch indexPath.row {
      case 1:
        print("\n---------- [ 데이터 리셋 ] -----------\n")
        resetData()
      case 2:
        print("\n---------- [ MainView 날짜 형태 설정하기 ] -----------\n")
        dateTextfield.becomeFirstResponder()
//        setCurrentDateFormat()
      default:
        print("other row")
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

// MARK: - didSeclect Action Method
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
    let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
    
    askAlert.addAction(okay)
    askAlert.addAction(cancel)
    
    self.present(askAlert, animated: true, completion: nil)
  }
  
  func setCurrentDateFormat() {
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    
    let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
    let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    toolbar.setItems([spaceBtn, doneBtn], animated: false)
    
    dateTextfield.inputAccessoryView = toolbar
    dateTextfield.inputView = datePicker
    
    let current = Settings.custom.currentDateFormat
    for idx in 0..<dateFormatStyle.count {
      let format = dateFormatStyle[idx].rawValue
      if format == current {
        datePicker.selectRow(idx, inComponent: 0, animated: false)
        break
      }
    }
  }
  
  @objc func donePressed() {
    let currentdateFormat = dateFormatStyle[pickerSelectRow].rawValue
    Settings.custom.setCurrentDateFormat(with: currentdateFormat)
    
    dateTextfield.text = dateConvertString(with: currentdateFormat)
    dateTextfield.resignFirstResponder()
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

extension SettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  
  //dataSource
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return dateFormatStyle.count
  }
  
  //delegate
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return dateConvertString(with: dateFormatStyle[row].rawValue)
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    pickerSelectRow = row
  }
  
  
  func dateConvertString(with format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: Date())
  }
}





// MARK: - MFMailComposeViewControllerDelegate
extension SettingViewController: MFMailComposeViewControllerDelegate {
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }
}
