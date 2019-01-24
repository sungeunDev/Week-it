//
//  ThemeTableViewController.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 13..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit

enum ThemeName: Int {
    case christmas
    case christmasLight
  case basic
  case sunset
  case macaron
  case redblue
  case jejuOcean
  
  case cherryBlossom
  case orange
  case heaven
  case cookieCream
  
}


class ThemeTableViewController: UITableViewController {
  

  
  let cellTitleData: [String] = ["CHRISTMAS", "CHRISTMAS LIGHT", "BASIC", "SUNSET", "MACARON", "RED & BLUE", "JEJU OCEAN", "CHERRY BLOSSOM", "ORANGE", "HEAVEN", "COOKIE & CREAM"]
  
  var currentTheme = ThemeName(rawValue: (UserDefaults.standard.value(forKey: "ThemeNameRawValue") as? Int) ?? 0) {
    willSet {
      self.tableView.reloadData()
      self.navigationController?.popToRootViewController(animated: true)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cellTitleData.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let themeCell = tableView.dequeueReusableCell(withIdentifier: "themeCell", for: indexPath) as! CustomTableViewCell
    
    if currentTheme?.rawValue == indexPath.row {
      themeCell.accessoryType = .checkmark
    } else {
      themeCell.accessoryType = .none
    }
    
    let currentThemeColor = [ColorSet.christmas, ColorSet.christmasLight, ColorSet.basic, ColorSet.sunset, ColorSet.macaron, ColorSet.redblue, ColorSet.jejuOcean, ColorSet.cherryBlossom, ColorSet.orange, ColorSet.heaven, ColorSet.cookieCream]
    
    
    DispatchQueue.main.async {
      
      themeCell.colorGood.backgroundColor = currentThemeColor[indexPath.row].good
      themeCell.colorSoso.backgroundColor = currentThemeColor[indexPath.row].soso
      themeCell.colorBad.backgroundColor = currentThemeColor[indexPath.row].bad
      
//      themeCell.themeImageView.image = self.cellImageData[indexPath.row]
      themeCell.themeTitleLabel.text = self.cellTitleData[indexPath.row].capitalized
      themeCell.setNeedsLayout()
    }    
    
    return themeCell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 66
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.currentTheme = ThemeName(rawValue: indexPath.row)
    UserDefaults.standard.set(indexPath.row, forKey: "ThemeNameRawValue")
  }
  
}
