//
//  mealCell.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 5..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit

class MealCell: UICollectionViewCell {
  
  @IBOutlet var mealLabel: UILabel!
  public var mealData: String? {
    didSet {
      mealLabel.text = mealData!
    }
  }
  
  override func awakeFromNib() {
    
  }
}
