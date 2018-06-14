//
//  Transitions.swift
//  Eat-it
//
//  Created by 김성종 on 2018. 6. 14..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit

final class MainToPostAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  private var cellFrame: CGRect
  private var cellImg: UIView
  
  init(startFrame: CGRect, cellImage: UIView) {
    cellFrame = startFrame
    cellImg = cellImage
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 1.0
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard
      let toVC = transitionContext.viewController(forKey: .to) as? PostViewController
//      let toSnap = toVC.view.snapshotView(afterScreenUpdates: true)
    else { return }
    
    let containerView = transitionContext.containerView
    let duration = transitionDuration(using: transitionContext)
    let finalFrame = transitionContext.finalFrame(for: toVC)
    
    // initial setup
    cellImg.frame = cellFrame
    
    containerView.addSubview(toVC.view)
    containerView.addSubview(cellImg)
    
    toVC.view.isHidden = true
    
    UIView.animate(
      withDuration: duration,
      delay: 0.0,
      options: [.curveEaseInOut],
      animations: {
        self.cellImg.frame = finalFrame
//        self.cellImg.layer.transform = CATransform3DMakeRotation(.pi, 0.0, 1.0, 0.0)
        self.cellImg.alpha = 0.0
      },
      completion: { _ in
        toVC.view.isHidden = false
        self.cellImg.removeFromSuperview()
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }
    )
    
  }
  
}

final class PostToMainAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  private var cellFrame: CGRect
  
  init(endFrame: CGRect) {
    cellFrame = endFrame
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 1.0
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard
      let fromVC = transitionContext.viewController(forKey: .from) as? PostViewController,
      let toVC = transitionContext.viewController(forKey: .to) as? MainViewController
    else { return }
  }
  
}
