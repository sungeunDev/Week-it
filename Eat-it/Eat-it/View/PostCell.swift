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
    
    let colorSet = [ColorSet.basic, ColorSet.helsinki, ColorSet.marseille, ColorSet.newyork, ColorSet.horizon, ColorSet.orange, ColorSet.heaven]
    let currentColor = colorSet[currentTheme].colors
    
    return currentColor[idx]
  }
}
