//
//  ViewController.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 5..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet private weak var mealTimeCollectionView: UICollectionView! // 아침, 점심, 저녁
    let meal = ["아침", "점심", "저녁"]
    
    @IBOutlet private weak var dayCollectionView: UICollectionView! // 요일 (월~금)
    let day = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    
    let matrix = [3, 5]
    
    @IBOutlet private weak var postCollectionView: UICollectionView! // 3 * 5
    let post = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    
    
    @IBOutlet private weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealTimeCollectionView.tag = 0
        dayCollectionView.tag = 1
        postCollectionView.tag = 2
    }

}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return matrix[0]
        case 1:
            return matrix[1]
        default:
            return matrix[0] * matrix[1]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mealCell", for: indexPath) as! MealCell
            cell.mealData = meal[indexPath.item]
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCell
            cell.dayData = day[indexPath.item]
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
            cell.postData = post[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tableWidth = backgroundView.frame.width - 10
        let tableHeight = backgroundView.frame.height - 10
        
        switch collectionView.tag {
        case 0:
            let width = tableWidth * 75 / 315
            let height = tableHeight * 40 / 413
            let size = CGSize(width: width, height: height)
            return size
        case 1:
            let width = tableWidth * 60 / 315
            let height = tableHeight * 65 / 413
            let size = CGSize(width: width, height: height)
            return size
        default:
            let width = tableWidth * 75 / 315
            let height = tableHeight * 65 / 413
            let size = CGSize(width: width, height: height)
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        var height = (postCollectionView.frame.height - 10)
        let cellHeight = (backgroundView.frame.height - 10) * 65 / 413
        height = (height - cellHeight * 5) / 4
        
        return height
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        var width = postCollectionView.frame.width - 10
        let cellWidth = (backgroundView.frame.width - 10) * 75 / 315
        width = (width - cellWidth * 3) / 2
        
        return width
    }
}

