//
//  DayCell.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 5..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    public var dayData: String = "" {
        didSet {
            dayLabel.text = dayData
        }
    }
    
    public var dateData: Int = 0 {
        willSet {
            let date = "\(newValue)".dropFirst(6)
            dateLabel.text = String(date)
            
            if isToday(newValue) {
//                dateLabel.textColor = bold로 바꾸기
            }
        }
    }
    
    func mealMatrixViewColorTheme() -> [UIColor] {
        let themeKey = "ThemeNameRawValue"
        let currentTheme = UserDefaults.standard.value(forKey: themeKey) as? Int ?? 0
        
        let colorSet = [ColorSet.basic, ColorSet.sunset, ColorSet.macaron, ColorSet.redblue, ColorSet.jejuOcean, ColorSet.cherryBlossom, ColorSet.orange, ColorSet.heaven, ColorSet.cookieCream]
        return colorSet[currentTheme].colors
    }
    
    override func awakeFromNib() {
        configureComponents()
    }
    
    private func configureComponents() {
        dayLabel.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        dateLabel.font = UIFont(name: "Montserrat-SemiBold", size: 14)
    }
    
    private func isToday(_ date: Int) -> Bool {
        let todayDate = Date()
        if todayDate.trasformInt() == date {
            return true
        } else {
            return false
        }
    }
}
