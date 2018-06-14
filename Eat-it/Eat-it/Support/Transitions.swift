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
    return 0.8
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard
      let toVC = transitionContext.viewController(forKey: .to) as? PostViewController
    else { return }
    
    let containerView = transitionContext.containerView
    let duration = transitionDuration(using: transitionContext)
    let finalFrame = transitionContext.finalFrame(for: toVC)
    
    // initial setup
    cellImg.frame = cellFrame

//    containerView.addSubview(cellImg)
    containerView.addSubview(toVC.view)
    
    let backView = containerView.subviews[0]
//    toVC.view.isHidden = true
    toVC.view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
    toVC.view.alpha = 0.0
    toVC.view.frame = cellFrame
//    toVC.view.layer.masksToBounds = true
    
    UIView.animateKeyframes(
      withDuration: duration,
      delay: 0.0,
      options: .calculationModeCubic,
      animations: {
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: {
          backView.layer.zPosition = -100.0
          toVC.view.alpha = 0.5
        })
        
        UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.9, animations: {
          backView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
//          self.cellImg.frame = finalFrame
//          self.cellImg.layer.transform = CATransform3DMakeRotation(.pi, 0.0, 1.0, 0.0)
//          self.cellImg.alpha = 0.0
          toVC.view.transform = CGAffineTransform.identity
          toVC.view.alpha = 1.0
          toVC.view.frame = finalFrame
        })
        
//        UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1, animations: {
//          toSnap.alpha = 1.0
//        })
        
      },
      completion: { _ in
        toVC.view.isHidden = false
        toVC.view.transform = CGAffineTransform.identity
        backView.transform = CGAffineTransform.identity
        self.cellImg.removeFromSuperview()
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }
    )
    
//    UIView.animate(
//      withDuration: duration,
//      delay: 0.0,
//      options: [.curveEaseInOut],
//      animations: {
//        backView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
//        self.cellImg.frame = finalFrame
//        self.cellImg.layer.transform = CATransform3DMakeRotation(.pi, 0.0, 1.0, 0.0)
////        self.cellImg.alpha = 0.0
//      },
//      completion: { _ in
//        toVC.view.isHidden = false
//        backView.transform = CGAffineTransform.identity
//        self.cellImg.removeFromSuperview()
//        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//      }
//    )
    
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
