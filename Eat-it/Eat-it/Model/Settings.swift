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
  
  // MARK: - Properties
  
  // MARK: About isIncludeWeekend
  private var _isIncludeWeekend: Bool = UserDefaults.standard.bool(forKey: "isIncludeWeekend")
  
  var isIncludeWeekend: Bool {
    return _isIncludeWeekend
  }
  
  // 주말 포함 여부에 따라 메인뷰 UI 재구성
  var dayData: [String]? // 요일 데이터
  var dateViewTopConstraint: CGFloat? // Autolayout Constraints
  var mealTableTopConstraint: CGFloat?
  var mealTableBottomConstarint: CGFloat?
  var basedMealTableHeight: CGFloat? // 셀 사이즈 계산할 때 기준값들
  var basedPostCellSize: CGSize?

  
  // MARK: About Current Date Format
  private var _currentDateFormat: String = UserDefaults.standard.string(forKey: "currentDateFormat") ?? "YYYY. MM. dd"
  
  var currentDateFormat: String {
    return _currentDateFormat
  }
}

// MARK: - Method
extension Settings {
  // MARK: -About isIncludeWeekend
  func setIsIncludeWeeknd(isIncludeWeekend: Bool) {
    UserDefaults.standard.set(isIncludeWeekend, forKey: "isIncludeWeekend")
    _isIncludeWeekend = isIncludeWeekend
    print("isInclueWeekend: \(isIncludeWeekend)")
  }
  
  // 주말 포함 여부에 따라 UI update
  func updateLayout(on isIncludeWeekend: Bool) {
    if isIncludeWeekend {
      self.dateViewTopConstraint = 28
      self.mealTableTopConstraint = 20
      self.mealTableBottomConstarint = 20
      self.basedMealTableHeight = 515
      self.basedPostCellSize = CGSize(width: 75, height: 56)
      self.dayData = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    } else {
      self.dateViewTopConstraint = 60
      self.mealTableTopConstraint = 44.5
      self.mealTableBottomConstarint = 55
      self.basedMealTableHeight = 413
      self.basedPostCellSize = CGSize(width: 75, height: 65)
      self.dayData = ["MON", "TUE", "WED", "THU", "FRI"]
    }
  }
  
  // MARK: -About Current Date Format
  func setCurrentDateFormat(with format: String) {
    UserDefaults.standard.set(format, forKey: "currentDateFormat")
    _currentDateFormat = format
    print("currentDateFormat: \(format)")
  }
}
