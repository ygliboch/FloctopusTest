//
//  NewsViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 7/31/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit
import Firebase

class NewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = Auth.auth().currentUser {
            print(user.email!)
        }
    }
}
