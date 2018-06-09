//
//  PostViewController.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 7..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import UIKit
import RealmSwift

class PostViewController: UIViewController {

    public var postData: Post?
    public var data = ""
    
    @IBOutlet private weak var mealLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    @IBOutlet private weak var menuTextField: UITextField!
    
    @IBOutlet private weak var seg: UISegmentedControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let format = DateFormatter()
        format.dateStyle = .short
        
        if let postdata = postData {
            let mealTime = ["아침", "점심", "저녁"]
            mealLabel.text = mealTime[postdata.mealTime]
            
            dateLabel.text = format.string(from: postdata.date)
        }
    }
    
    @IBAction private func saveBtn() {
        let realm = try! Realm()
        
        let post = Post(date: postData!.date, rating: seg.selectedSegmentIndex, mealTime: postData!.mealTime, mealTitle: menuTextField.text!)
        
        try! realm.write {
            realm.add(post)
        }
        
        
        
    }
    
}
