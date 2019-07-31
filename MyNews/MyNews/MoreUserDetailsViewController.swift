//
//  MoreUserDetailsViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 7/31/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit

class MoreUserDetailsViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userSername: UITextField!
    @IBOutlet weak var userMobile: NSLayoutConstraint!
    @IBOutlet weak var userBirthDate: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "BackToSignUp", sender: "Foo")
    }
    
}
