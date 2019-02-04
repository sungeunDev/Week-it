//
//  PostCell.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 5..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit
import ChameleonFramework

class PostCell: UICollectionViewCell {
    @IBOutlet private weak var postLabel: UILabel!
    @IBOutlet private weak var plusImageView: UIImageView!
    
    var isFixedView: UIView!
    
    public var postData: Post? {
        didSet {
            if let postData = postData {
                postLabel.text = String(postData.mealTitle)
                plusImageView.image = nil
                self.backgroundColor = cellBackgroundColor(of: postData.rating)
                isFixedView.isHidden = !postData.isFixed
                isFixedView.backgroundColor = self.backgroundColor?.darken(byPercentage: 0.15)
            } else {
                postLabel.text = ""
                plusImageView.image = UIImage(named: "plusIcon.png")
                self.backgroundColor = UIColor.Custom.backGroundColor
                isFixedView.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        isFixedView = UIView()
        self.addSubview(isFixedView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureIsFixedView()
    }
    
    private func configureIsFixedView() {
        let width = self.frame.width * 0.35
        let height = self.frame.height * 0.18
        let x = (self.frame.width - width) / 2
        let y = height / (-2) + 1
        
        isFixedView.frame = CGRect(x: x, y: y, width: width, height: height)
        isFixedView.alpha = 0.7
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
