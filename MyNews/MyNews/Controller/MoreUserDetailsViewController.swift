//
//  MoreUserDetailsViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 7/31/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit
import Firebase

class MoreUserDetailsViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userSername: UITextField!
    @IBOutlet weak var userMobile: UITextField!
    @IBOutlet weak var userBirthDate: UITextField!
    var ref: DatabaseReference?
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Auth.auth().currentUser
    }

    @IBAction func backButton(_ sender: Any) {
        ref = Database.database().reference()
        user = Auth.auth().currentUser
        performSegue(withIdentifier: "BackToSignUp", sender: "Foo")
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if checkInfo() {
            let postInfo = ["userName": userName.text!, "userSername": userSername.text!, "userMobile": userMobile.text!, "userBirthDate": userBirthDate.text!, "userCountry" : "", "userCity" : "", "userSources" : ""] as [String : Any]
            
            Database.database().reference().child("users").child("\(user!.uid)").setValue(postInfo)
            performSegue(withIdentifier: "SignUpDone", sender: "Foo")
            let ref = Database.database().reference()
            ref.observe(DataEventType.value, with: { (snaphot) in
                print(snaphot)
                let postDick = snaphot.value as? [String : AnyObject] ?? [:]
                print(postDick)
            }) {(error) in
                print("======================error==============================")
                print(error.localizedDescription)
            }
        }
    }
    
    func checkInfo () -> Bool {
        if userName.text!.isEmpty {
            userName.layer.borderWidth = 1.0
            userName.layer.borderColor = UIColor.red.cgColor
            return false
        }
        if userSername.text!.isEmpty {
            userSername.layer.borderWidth = 1.0
            userSername.layer.borderColor = UIColor.red.cgColor
            return false
        }
        if userMobile.text!.isEmpty {
            userMobile.layer.borderWidth = 1.0
            userMobile.layer.borderColor = UIColor.red.cgColor
            return false
        }
        if userBirthDate.text!.isEmpty {
            userBirthDate.layer.borderWidth = 1.0
            userBirthDate.layer.borderColor = UIColor.red.cgColor
            return false
        }
        return true
    }
}
