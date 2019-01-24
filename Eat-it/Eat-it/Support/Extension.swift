//
//  Extension.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 5..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIColor
extension UIColor {
  
  struct Custom {
    
    static let good = UIColor().currentTheme()[0]
    static let soso = UIColor().currentTheme()[1]
    static let bad = UIColor().currentTheme()[2]
    
    static let backGroundColor = UIColor().currentTheme()[3]
  }
  
  
  static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
  }
  
  
   func currentTheme() -> [UIColor] {
    
    let themeKey = "ThemeNameRawValue"
    let currentTheme = UserDefaults.standard.value(forKey: themeKey) as? Int ?? 0
    
    let colorSet = [ColorSet.christmas, ColorSet.christmasLight, ColorSet.basic, ColorSet.sunset, ColorSet.macaron, ColorSet.redblue, ColorSet.jejuOcean, ColorSet.cherryBlossom, ColorSet.orange, ColorSet.heaven, ColorSet.cookieCream]
    
    // 0 - Good, 1 - Soso, 2 - Bad , 3 - BackgroundColor
    return colorSet[currentTheme].colors
  }
  
  
  convenience init(hex: String) {
    
    let scanner = Scanner(string: hex)
    scanner.scanLocation = 0
    
    var rgbValue: UInt64 = 0
    
    scanner.scanHexInt64(&rgbValue)
    
    let r = (rgbValue & 0xff0000) >> 16
    let g = (rgbValue & 0xff00) >> 8
    let b = rgbValue & 0xff
    
    self.init(
      red: CGFloat(r) / 0xff,
      green: CGFloat(g) / 0xff,
      blue: CGFloat(b) / 0xff, alpha: 1
    )
  }
  
}


// MARK: - Date
extension Date {
  
  public func trasformInt() -> Int {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "yyyyMMdd"
    let str = dateFormatter.string(from: self)
    
    return Int(str)!
  }
  
  public func transformIntOnlyMonth() -> Int {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "yyyyMM00"
    let str = dateFormatter.string(from: self)
    
    return Int(str)!
  }
  
  func lastDayOfMonth() -> Date {
    let calendar = Calendar(identifier: .gregorian)
    let dayRange = calendar.range(of: .day, in: .month, for: self)
    let dayCount = dayRange?.count
    
    var comp = calendar.dateComponents([.year, .month, .day], from: self)
    comp.day = dayCount
    return calendar.date(from: comp)!
  }
    
    func firstDayOfNextMonth() -> Date {
        var last = lastDayOfMonth()
        let oneDay: Double = 24 * 60 * 60
       
        last.addTimeInterval(oneDay)
        
        let calendar = Calendar(identifier: .gregorian)
        let comp = calendar.dateComponents([.year, .month, .day], from: last)
        return calendar.date(from: comp)!
    }
  
}


// MARK: - UserDefault
extension UserDefaults {
  
  func setColor(_ color: UIColor?, forkey defaultName: String) {
    var colorData: NSData?
    if let color = color {
      colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
    }
    set(colorData, forKey: defaultName)
  }
  
  func colorForKey(key: String) -> UIColor? {
    var color: UIColor?
    if let colorData = data(forKey: key) {
     color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
    }
    return color
  }
}


// MARK: - UIViewController_ 내비바의 Back 버튼 공백으로 설정
extension UIViewController {
  func setNaviBackBtn() {
    let backBtnString = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    self.navigationItem.backBarButtonItem = backBtnString
  }
}


//MARK: - String_특정 String을 한국어 localization 할고자 할 때 사용
extension String {
  var localized:String {
    return NSLocalizedString(self, comment: "")
  }
  
  func localizedWithComment(comment:String) -> String {
    return NSLocalizedString(self, comment: comment)
  }
}
