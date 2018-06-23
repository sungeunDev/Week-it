//
//  mealCell.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 5..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit

class MealCell: UICollectionViewCell {
  
  @IBOutlet var mealTimeImageView: UIImageView!
  let mealTimeImage = [#imageLiteral(resourceName: "mealTime_morning"), #imageLiteral(resourceName: "mealTime_noon"), #imageLiteral(resourceName: "mealTime_night")]
  
  public var mealData: Int? {
    willSet {
      mealTimeImageView.image = mealTimeImage[newValue!]
    }
  }
  
  override func awakeFromNib() {
    
  }
}
