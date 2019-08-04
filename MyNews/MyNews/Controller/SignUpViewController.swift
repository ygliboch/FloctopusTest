//
//  SignUpViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 7/31/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet weak var eMail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        if password.text != confirmPassword.text {
            password.layer.borderWidth = 1.0
            password.layer.borderColor = UIColor.red.cgColor
            confirmPassword.layer.borderWidth = 1.0
            confirmPassword.layer.borderColor = UIColor.red.cgColor
            password.text = ""
            confirmPassword.text = ""
            return
        } 
        Auth.auth().createUser(withEmail: eMail.text!, password: password.text!) { authResult, error in
            if authResult != nil &&  error == nil {
                self.performSegue(withIdentifier: "moreUserDetail", sender: "Foo")
            } else {
                self.errorLabel.isHidden = false
                self.errorLabel.text = error?.localizedDescription
            }
        }
    }
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "BackToLoginView", sender: "Foo")
    }
    
    @IBAction func unWindSegue(segue: UIStoryboardSegue){
    }
}
