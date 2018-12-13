//
//  PostCell.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 5..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
  @IBOutlet private weak var postLabel: UILabel!
  @IBOutlet private weak var plusImageView: UIImageView!
  
  public var postData: Post? {
    didSet {
      if let postData = postData {
        
        postLabel.text = String(postData.mealTitle)
        plusImageView.image = nil
        self.backgroundColor = cellBackgroundColor(of: postData.rating)
        
        
        
      } else {
        postLabel.text = ""
        plusImageView.image = UIImage(named: "plusIcon.png")
        self.backgroundColor = UIColor.Custom.backGroundColor
        
      }
      
    }
  }
  
  
  public var data: Post!
  
  override func awakeFromNib() {
    
  }
  
  
  func cellBackgroundColor(of idx: Int) -> UIColor {
    let themeKey = "ThemeNameRawValue"
    let currentTheme = UserDefaults.standard.value(forKey: themeKey) as? Int ?? 0
    let colorSet = [ColorSet.christmas, ColorSet.christmasLight, ColorSet.basic, ColorSet.sunset, ColorSet.macaron, ColorSet.redblue, ColorSet.jejuOcean, ColorSet.cherryBlossom, ColorSet.orange, ColorSet.heaven, ColorSet.cookieCream]
    let currentColor = colorSet[currentTheme].colors

    // 테마에 따라 title label color도 변경
    if (currentTheme == 10 && idx == 2) || (currentTheme == 0 && idx != 1) || (currentTheme == 1 && idx != 1)  { // 쿠키앤크림
      postLabel.textColor = UIColor.white
    } else {
      postLabel.textColor = UIColor.black
    }
    
    return currentColor[idx] // 0 - Good, 1 - Soso, 2 - Bad , 3 - BackgroundColor
  }
}
