//
//  TutorialImageViewController.swift
//  Eat-it
//
//  Created by sungnni on 2018. 7. 3..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit

class TutorialImageViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  var image: UIImage? {
    didSet {
      self.imageView?.image = image
    }
  }
  var text: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.imageView.image = image
//    self.descriptionLabel.text = text
    
  }
}
