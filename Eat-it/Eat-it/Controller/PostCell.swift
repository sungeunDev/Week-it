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
    public var postData: Int = 0 {
        didSet {
            postLabel.text = String(postData)
        }
    }
    
    override func awakeFromNib() {
    
    }
}
