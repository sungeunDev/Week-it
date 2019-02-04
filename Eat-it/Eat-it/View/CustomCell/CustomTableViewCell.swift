//
//  CustomTableViewCell.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 13..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
  
  //themeCell
  @IBOutlet weak var themeTitleLabel: UILabel!
  @IBOutlet weak var colorGood: UIView!
  @IBOutlet weak var colorSoso: UIView!
  @IBOutlet weak var colorBad: UIView!
  
  //graphCell
  @IBOutlet weak var graphDateLabel: UILabel!
  @IBOutlet weak var graphCountLabel: UILabel!
  
  //graphDetailTableCell
  @IBOutlet weak var graphDetailTableLabel: UILabel!
  @IBOutlet weak var graphDetailTableCountLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
