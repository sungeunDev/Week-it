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
    let graphMonthlyCell = tableView.dequeueReusableCell(withIdentifier: "graphMonthlyCell", for: indexPath) as! CustomTableViewCell
    
    if indexPath.section == 0 {
      guard let posts = numOfposts else { return graphCell }
      graphCell.graphDateLabel.text = "모든 포스트"
      
      var all = 0
      for num in posts {
        all += num.numOfpost
      }
      
      graphCell.graphCountLabel.text = "\(all)개"
      return graphCell
    } else {
      guard let posts = numOfposts else { return graphMonthlyCell }
      
      let dateStr = String(posts[indexPath.row].dateInt)
      let year = dateStr.dropLast(4)
      let month = dateStr.dropFirst(4).dropLast(2)
      
      graphMonthlyCell.graphMonthlyDateLabel.text = "\(year)년 \(month)월"
      graphMonthlyCell.graphMonthlyCountLabel.text = "\(String(posts[indexPath.row].numOfpost))개"
      return graphMonthlyCell
    }
  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

  }
  
  
}
