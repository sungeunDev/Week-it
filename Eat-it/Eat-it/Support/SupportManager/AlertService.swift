//
//  AlertService.swift
//  Eat-it
//
//  Created by Sungeun Park on 10/02/2019.
//  Copyright © 2019 sungeun. All rights reserved.
//

import Foundation
import UIKit

protocol AlertService {
    func showOneAlert(alertTitle: String,
                      message: String,
                      actionTitle: String,
                      completion: ((UIAlertAction) -> Void)?) -> UIAlertController
    
    func showTwoAlert(alertTitle: String,
                      message: String,
                      firstAction: String,
                      firstCompletion: ((UIAlertAction) -> Void)?,
                      secondAction: String,
                      secondCompletion: ((UIAlertAction) -> Void)?) -> UIAlertController
    
}

extension AlertService {
    func showOneAlert(alertTitle: String,
                      message: String,
                      actionTitle: String,
                      completion: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: alertTitle,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle,
                                   style: .default, handler: completion)
        alert.addAction(action)
        return alert
    }
    
    func showTwoAlert(alertTitle: String,
                      message: String,
                      firstAction: String,
                      firstCompletion: ((UIAlertAction) -> Void)?,
                      secondAction: String,
                      secondCompletion: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: alertTitle,
                                      message: message,
                                      preferredStyle: .alert)
        let firstAction = UIAlertAction(title: firstAction,
                                   style: .default, handler: firstCompletion)
        let secondAction = UIAlertAction(title: secondAction,
                                   style: .default, handler: secondCompletion)
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        return alert
    }
}
