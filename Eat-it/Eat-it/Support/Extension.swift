//
//  Extension.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 5..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    struct Custom {
        
        static let backGroundColor = UIColor.rgb(red: 245, green: 245, blue: 245, alpha: 1)
        
        static let good = UIColor.rgb(red: 115, green: 202, blue: 196, alpha: 1)
        static let soso = UIColor.rgb(red: 227, green: 229, blue: 70, alpha: 1)
        static let bad = UIColor.rgb(red: 242, green: 120, blue: 143, alpha: 1)
    }
    
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
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


extension Date {
    
    public func trasformInt(from date: Date) -> Int {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyyMMdd"
        let str = dateFormatter.string(from: date)
        
        return Int(str)!
    }
  
  public func transformIntOnlyMonth(from date: Date) -> Int {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "yyyyMM00"
    let str = dateFormatter.string(from: date)
    
    return Int(str)!
  }
}
