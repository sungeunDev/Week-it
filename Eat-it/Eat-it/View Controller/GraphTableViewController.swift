//
//  GraphTableViewController.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 14..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit
import RealmSwift

class GraphTableViewController: UITableViewController {
  
  var numOfposts: Results<NumOfPost>? {
    willSet {
      self.tableView.reloadData()
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    numOfposts = fetchPostResult()
    setNaviBackBtn()
  }
  
  func fetchPostResult() -> Results<NumOfPost> {
    
    let realm = try! Realm()
    let numOfPost = realm.objects(NumOfPost.self)
    var all = 0
    for num in numOfPost {
      all += num.numOfpost
    }
    
    // date 순으로 sort
    return numOfPost.sorted(byKeyPath: "dateInt", ascending: false)
  }
  
  
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "ALL"
    } else {
      return "MONTHLY"
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else {
      return numOfposts?.count ?? 0
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let graphCell = tableView.dequeueReusableCell(withIdentifier: "graphCell", for: indexPath) as! CustomTableViewCell
 
    if indexPath.section == 0 {
      guard let posts = numOfposts else { return graphCell }
      graphCell.graphDateLabel.text = naviTitleLabel(indexPath: indexPath)
      
      var all = 0
      for num in posts {
        all += num.numOfpost
      }
      
      graphCell.graphCountLabel.text = "\(all)개"
      return graphCell
    } else {
      guard let numOfposts = numOfposts else { return graphCell }
      
      graphCell.graphDateLabel.text = naviTitleLabel(indexPath: indexPath)
      graphCell.graphCountLabel.text = "\(String(numOfposts[indexPath.row].numOfpost))개"
      return graphCell
    }
  }
  

  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let nextVC = storyboard?.instantiateViewController(withIdentifier: "GraphDetailViewController") as! GraphDetailViewController
    if indexPath.section == 0 {
      let realm = try! Realm()
      nextVC.posts = realm.objects(Post.self)
    } else {
      guard let numOfposts = numOfposts else { return }
      nextVC.posts = fetchPosts(date: numOfposts[indexPath.row].dateInt)
    }
    nextVC.naviTitle = naviTitleLabel(indexPath: indexPath)
    self.navigationController?.pushViewController(nextVC, animated: true)
    
  }
  
  // 해당 date에 해당하는 post만 fetch
  func fetchPosts(date: Int) -> Results<Post> {
    let realm = try! Realm()
    let posts = realm.objects(Post.self).filter("dateText >= %@", date).filter("dateText < %@", date + 100)
    
    let postsSorted = posts.sorted(by: [
      SortDescriptor(keyPath: "dateText", ascending: true),
      SortDescriptor(keyPath: "mealTime", ascending: true),
      ])
    
    return postsSorted
  }
  
  // navi Title 설정
  func naviTitleLabel(indexPath: IndexPath) -> String {
    if indexPath.section == 0 {
      return "모든 포스트"
    } else {
      guard let numOfposts = numOfposts else { return "" }
      let dateStr = String(numOfposts[indexPath.row].dateInt)
      let year = dateStr.dropLast(4)
      let month = dateStr.dropFirst(4).dropLast(2)
      
      return "\(year)년 \(month)월"
    }
  }
  
}
