//
//  SettingViewController.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 11..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit
import RealmSwift

class SettingViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    
    
  }
  
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
      case 0: // 앱스토어 리뷰
        print("\n---------- [ move app store ] -----------\n")
      case 1: // 의견보내기
        print("\n---------- [ send mail ] -----------\n")
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
    let askAlert = UIAlertController(title: "데이터 초기화",
                                     message: """
                                        데이터를 초기화하면 다시 복구할 수 없습니다.
                                        정말 초기화할까요?
                                        """, preferredStyle: .alert)
    
    let okay = UIAlertAction(title: "초기화", style: .destructive) { (action) in
      let realm = try! Realm()
      try! realm.write {
        print("\n---------- [ RESET REALM DATA ] -----------\n")
        realm.deleteAll()
      }
      self.navigationController?.popToRootViewController(animated: true)
    }
    let cancle = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    
    askAlert.addAction(okay)
    askAlert.addAction(cancle)
    
    self.present(askAlert, animated: true, completion: nil)
  }
  
}
