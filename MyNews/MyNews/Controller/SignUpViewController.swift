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
        eMail.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
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
                let postInfo = ["userName": "", "userSername": "", "userMobile": "", "userBirthDate": "", "userCountry" : "", "userCity" : "", "userSources" : ""] as [String : Any]
                let user = Auth.auth().currentUser
                Database.database().reference().child("users").child("\(user!.uid)").setValue(postInfo) { (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    } else {
                        print("Data saved successfully!")
                        self.performSegue(withIdentifier: "signUpDone", sender: "Foo")
                    }
                }
            } else {
                self.errorLabel.isHidden = false
                self.errorLabel.text = error?.localizedDescription
            }
        }
    }
    
    @IBAction func unWindSegue(segue: UIStoryboardSegue){
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
