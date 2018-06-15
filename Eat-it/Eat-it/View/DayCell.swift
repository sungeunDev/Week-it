//
//  DayCell.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 5..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
  @IBOutlet private weak var dayLabel: UILabel!
  public var dayData: String = "" {
    didSet {
      dayLabel.text = dayData
    }
  }
  
  override func awakeFromNib() {
    
  }
  
}
