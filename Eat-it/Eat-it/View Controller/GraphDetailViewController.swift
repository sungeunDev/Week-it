//
//  GraphDetailViewController.swift
//  Eat-it
//
//  Created by sungnni on 2018. 7. 2..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit
import RealmSwift

class GraphDetailViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  var posts: Results<Post>?
  let currentTheme = UIColor().currentTheme()
  var naviTitle: String? {
    willSet {
      self.title = newValue
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    descriptionLabel.text = "총 \(posts!.count)개의 포스트가 있습니다."
  }
  
  // GOOD / SOSO / BAD 별로 포스트 개수 세기
  func sortRatingCount(of posts: Results<Post>) -> [String] {
    var returnResult: [String] = []
    for i in 0..<3 {
      let ratingCount = posts.filter("rating == \(i)").count
      returnResult.append(String(ratingCount))
    }
    return returnResult
  }
  
  
  // posts의 가장 많은 요일 count
  func countMostDaysOfWeek(of posts: Results<Post>) -> (Int, String) {
    
    // 요일별로 포스트가 몇개인지 count Array 만들기
    var count = [0, 0, 0, 0, 0] // 월, 화, 수, 목, 금
    for post in posts {
      let calendar = Calendar.current
      let weekday = calendar.component(.weekday, from: post.date)
      let monday = 2
      count[weekday-monday] += 1
    }
    
    // 가장 포스트가 많은 요일 세기(중복 허용)
    var mostDaysOfWeek: [Int] = []
    var best = 0
    for (idx, count) in count.enumerated() {
      if count > best {
        best = count
        mostDaysOfWeek.removeAll()
        mostDaysOfWeek.append(idx)
      } else if count == best {
        mostDaysOfWeek.append(idx)
      }
    }
    
    // String으로 나타내기
    let day = ["월", "화", "수", "목", "금"]
    var str = ""
    
    for days in mostDaysOfWeek {
      str += day[days] + ", "
      if mostDaysOfWeek.last == days {
        str.removeLast(2)
      }
    }
    return (best, str)
    // EX. (2, "월, 목, 금")
  }
  
  
  // posts의 가장 많은 mealTime count
  func countMostOfMealtime(of posts: Results<Post>) -> (Int, String) {
    let morning = posts.filter("mealTime == 0").count
    let noon = posts.filter("mealTime == 1").count
    let night = posts.filter("mealTime == 2").count
    
    let array = [morning, noon, night]
    
    var mostOfMealTime: [Int] = []
    var best = 0
    for (idx, count) in array.enumerated() {
      if count > best {
        best = count
        mostOfMealTime.removeAll()
        mostOfMealTime.append(idx)
      } else if count == best {
        mostOfMealTime.append(idx)
      }
    }
    
    // String으로 나타내기
    let day = ["아침", "점심", "저녁"]
    var str = ""
    
    for days in mostOfMealTime {
      str += day[days] + ", "
      if mostOfMealTime.last == days {
        str.removeLast(2)
      }
    }
    return (best, str)
  }
  
}

// MARK: - CollectionView
extension GraphDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let graphDetailCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "graphDetailCollectionCell", for: indexPath) as! CustomCollectionViewCell
    guard let posts = posts else { return graphDetailCollectionCell }
    graphDetailCollectionCell.backgroundColor = currentTheme[indexPath.item]
    graphDetailCollectionCell.layer.cornerRadius = 5
    graphDetailCollectionCell.graphDetailStarImageView.image = [#imageLiteral(resourceName: "star3"), #imageLiteral(resourceName: "star2"), #imageLiteral(resourceName: "star1")][indexPath.item]
    graphDetailCollectionCell.graphDetailCountLabel.text = sortRatingCount(of: posts)[indexPath.item] + "개"
    return graphDetailCollectionCell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let inset: CGFloat = 40
    let minMargin: CGFloat = 20
    let width: CGFloat = (self.view.frame.size.width - ((inset + minMargin) * 2)) / 3 - 8
    let height: CGFloat = 60
    return CGSize(width: width, height: height)
  }
}


// MARK: - TableView DataSource
extension GraphDetailViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let graphDetailTableCell = tableView.dequeueReusableCell(withIdentifier: "graphDetailTableCell", for: indexPath) as! CustomTableViewCell
    if indexPath.row == 0 {
      graphDetailTableCell.graphDetailTableLabel.text = "BEST (★★★)"
      if indexPath.section == 0 {
        let bestDaysOfWeek = countMostDaysOfWeek(of: posts!.filter("rating == 0"))
        graphDetailTableCell.graphDetailTableCountLabel.text = "\(bestDaysOfWeek.1) - \(bestDaysOfWeek.0)회"
      } else {
        let bestMealTime = countMostOfMealtime(of: posts!.filter("rating == 0"))
        graphDetailTableCell.graphDetailTableCountLabel.text = "\(bestMealTime.1) - \(bestMealTime.0)회"
      }
      
    } else {
      graphDetailTableCell.graphDetailTableLabel.text = "WORST (★)"
      if indexPath.section == 0 {
        let worstDaysOfWeek = countMostDaysOfWeek(of: posts!.filter("rating == 2"))
        graphDetailTableCell.graphDetailTableCountLabel.text = "\(worstDaysOfWeek.1) - \(worstDaysOfWeek.0)회"
      } else {
        let worstMealTime = countMostOfMealtime(of: posts!.filter("rating == 2"))
        graphDetailTableCell.graphDetailTableCountLabel.text = "\(worstMealTime.1) - \(worstMealTime.0)회"
      }
    }
      return graphDetailTableCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      if section == 0 {
        return "요일별"
      } else {
        return "시간별"
      }
    }
    
}
