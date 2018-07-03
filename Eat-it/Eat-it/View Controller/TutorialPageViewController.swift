//
//  TutorialPageViewController.swift
//  Eat-it
//
//  Created by sungnni on 2018. 7. 3..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit

protocol TutorialImagesPageViewControllerDelegate: class {
  func setupPageController(numberOfPages: Int)
  func turnPageController(to index: Int)
}



class TutorialPageViewController: UIPageViewController {

  var images: [UIImage]? = [#imageLiteral(resourceName: "basic"), #imageLiteral(resourceName: "heaven"), #imageLiteral(resourceName: "newyork")]
  weak var pageViewControllerDelegate: TutorialImagesPageViewControllerDelegate?
  
  struct StoryBoard {
    static let tutorialImageViewController = "TutorialImageViewController"
  }
  
  
  // why lazy? - drawing, downloading expensive. at initialize process, it is not create yet.
  lazy var controllers: [UIViewController] = {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var controllers = [UIViewController]()
    if let images = self.images {
      for image in images {
        let tutorialImageVC = storyboard.instantiateViewController(withIdentifier: StoryBoard.tutorialImageViewController)
        controllers.append(tutorialImageVC)
      }
    }
    
    self.pageViewControllerDelegate?.setupPageController(numberOfPages: controllers.count)
    return controllers
  }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      dataSource = self
      delegate = self
      
      self.turnToPage(index: 0)
    }
  
  func turnToPage(index: Int) {
    let controller = controllers[index]
    let direction = UIPageViewControllerNavigationDirection.forward
    
    self.configureDisplaying(viewController: controller)
    setViewControllers([controller], direction: direction, animated: true, completion: nil)
  }
  
  
  func configureDisplaying(viewController: UIViewController) {
    for (idx, vc) in controllers.enumerated() {
      if viewController === vc {
        if let tutorialImageVC = viewController as? TutorialImageViewController {
          tutorialImageVC.image = self.images?[idx]
          self.pageViewControllerDelegate?.turnPageController(to: idx)
        }
      }
    }
  }
}

// MARK: - PageViewController DataSource
extension TutorialPageViewController: UIPageViewControllerDataSource {
  
  // BEFORE
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
    // index가 현재 viewController일 때,
    if let index = controllers.index(of: viewController) {
      if index > 0 { // 첫번째 index가 아닐 때,
        return controllers[index-1]
      }
    }
    
    return nil
  }
  
  // AFTER
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    if let index = controllers.index(of: viewController) {
      if index < controllers.endIndex - 1 {
        return controllers[index+1]
      }
    }
    return nil
  }
}

// MARK: - PageViewController Delegate
extension TutorialPageViewController: UIPageViewControllerDelegate {
  
  // Will Transition
  func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    self.configureDisplaying(viewController: pendingViewControllers.first as! TutorialImageViewController)
  }
  
  // Transition Completed?
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if !completed {
      self.configureDisplaying(viewController: previousViewControllers.first as! TutorialImageViewController)
    }
  }
}
