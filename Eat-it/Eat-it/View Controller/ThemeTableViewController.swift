//
//  ThemeTableViewController.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 13..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit

enum ThemeName: Int {
    
    case basic
    case helsinki
    case marseille
    case newyork
    // ref : https://www.post-it.com/3M/en_US/post-it/ideas/color/
    
    case horizon
    case orange
    case heaven
    // ref : https://www.design-seeds.com/?s=pink
}


class ThemeTableViewController: UITableViewController {

    
    let cellTitleData: [String] = ["BASIC", "HELSINKI", "MARSEILLE", "NEWYORK", "HORIZON", "ORANGE", "HEAVEN"]
    let cellImageData: [UIImage] = [#imageLiteral(resourceName: "basic"), #imageLiteral(resourceName: "helsinki"), #imageLiteral(resourceName: "marseille"), #imageLiteral(resourceName: "newyork"), #imageLiteral(resourceName: "horizon"), #imageLiteral(resourceName: "orange"), #imageLiteral(resourceName: "heaven")]
    
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
        
        DispatchQueue.main.async {
            themeCell.themeImageView.image = self.cellImageData[indexPath.row]
            themeCell.themeTitleLabel.text = self.cellTitleData[indexPath.row].uppercased()
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
