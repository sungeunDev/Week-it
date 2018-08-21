//
//  TutorialViewController.swift
//  Eat-it
//
//  Created by sungnni on 2018. 7. 3..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var pageControl: UIPageControl!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToPageVC" {
      if let imagesPageVC = segue.destination as? TutorialPageViewController {
          imagesPageVC.pageViewControllerDelegate = self
      }
    }
  }

    
  @IBAction private func closeBtnAction() {
    self.dismiss(animated: true, completion: nil)
  }

}

extension TutorialViewController: TutorialImagesPageViewControllerDelegate {
  
  func setupPageController(numberOfPages: Int) {
    pageControl.numberOfPages = numberOfPages
  }
  
  func turnPageController(to index: Int) {
    pageControl.currentPage = index
  }
}
