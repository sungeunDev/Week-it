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
        switch idx {
        case 0:
            return UIColor.Custom.good
        case 1:
            return UIColor.Custom.soso
        case 2:
            return UIColor.Custom.bad
        default:
            return UIColor.black
        }
    }
}
