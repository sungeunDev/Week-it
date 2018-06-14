//
//  GraphViewController.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 11..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit
import RealmSwift

class GraphViewController: UITableViewController {

    var posts: Results<Post>? {
        willSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        posts = fetchPostResult()
    }
    
    
    func fetchPostResult() -> Results<Post> {
        
        let realm = try! Realm()
        let posts = realm.objects(Post.self)
        
        let good = posts.filter("rating == 0")
        let soso = posts.filter("rating == 1")
        let bad = posts.filter("rating == 2")
        
//        print(good.count)
//        print(good)
//        print(soso.count)
//        print(soso)
//        print(bad.count)
//        print(bad)
        
        return posts
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        } else {
////            guard let posts = posts else { return 0 }
//            return 3
//        }
//
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let graphCell = tableView.dequeueReusableCell(withIdentifier: "graphCell", for: indexPath) as! CustomTableViewCell
        
        return graphCell
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let graphCell = tableView.dequeueReusableCell(withIdentifier: "graphCell", for: indexPath) as! CustomTableViewCell
//        let graphMonthlyCell = tableView.dequeueReusableCell(withIdentifier: "graphMonthlyCell", for: indexPath) as! CustomTableViewCell
//        
//        if indexPath.section == 0 {
////            guard let posts = posts else { return graphCell }
//            graphCell.graphDateLabel.text = ""
//            graphCell.graphCountLabel.text = "3"
//            return graphCell
//        } else {
////            guard let posts = posts else { return graphMonthlyCell }
//            graphMonthlyCell.graphMonthlyDateLabel.text = "doremi"
//            graphMonthlyCell.graphMonthlyCountLabel.text = "3"
//            return graphMonthlyCell
//        }
//    }
    
}
