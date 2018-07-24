//
//  Settings.swift
//  Eat-it
//
//  Created by sungnni on 2018. 7. 24..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import Foundation
import UIKit


class Settings {
  
  static var custom: Settings = Settings()
  
  // 초기값 설정. 없으면 false. private 설정 - 외부에서 직접 변경 불가.
  private var _isIncludeWeekend: Bool = UserDefaults.standard.bool(forKey: "isIncludeWeekend")
  
  // 프로퍼티 값 설정
  func setIsIncludeWeeknd(isIncludeWeekend: Bool) {
    UserDefaults.standard.set(isIncludeWeekend, forKey: "isIncludeWeekend")
    _isIncludeWeekend = isIncludeWeekend
    
    print("isInclueWeekend: \(isIncludeWeekend)")
  }
  
  // 외부에서 불러오는 용도
  var isIncludeWeekend: Bool {
    return _isIncludeWeekend
  }
  
  var dayData: [String]?
  
  // Constraint
  var dateViewTopConstraint: CGFloat?
  var mealTableTopConstraint: CGFloat?
  var mealTableBottomConstarint: CGFloat?
  
  // 셀 사이즈 계산할 때 기준값
  var basedMealTableHeight: CGFloat?
  var basedPostCellSize: CGSize?
  
  // 주말 포함 여부에 따라 Constraint 값 설정
  func updateLayout(on isIncludeWeekend: Bool) {
    if isIncludeWeekend { // 주말 포함인 경우,
      
      self.dateViewTopConstraint = 28
      self.mealTableTopConstraint = 20
      self.mealTableBottomConstarint = 20
      
      self.basedMealTableHeight = 515
      self.basedPostCellSize = CGSize(width: 75, height: 56)
      
      self.dayData = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
      
    } else { // 주말 포함 아닌 경우,
      self.dateViewTopConstraint = 60
      self.mealTableTopConstraint = 44.5
      self.mealTableBottomConstarint = 55
      
      self.basedMealTableHeight = 413
      self.basedPostCellSize = CGSize(width: 75, height: 65)
      
      self.dayData = ["MON", "TUE", "WED", "THU", "FRI"]
    }
  }
  
  
}
