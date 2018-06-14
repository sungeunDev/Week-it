//
//  TransitionCoordinator.swift
//  Eat-it
//
//  Created by 김성종 on 2018. 6. 14..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit

final class TransitionCoordinator: NSObject, UINavigationControllerDelegate {
  
  func navigationController(_ navigationController: UINavigationController,
                            animationControllerFor operation: UINavigationControllerOperation,
                            from fromVC: UIViewController,
                            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    if let from = fromVC as? MainViewController, let cellFrame = from.selectedCellRect, let cellImg = from.selectedCellImg, operation == .push {
      return MainToPostAnimator(startFrame: cellFrame, cellImage: cellImg)
    }
    
    return nil
  }
  
}
