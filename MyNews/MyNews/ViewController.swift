//
//  ViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 7/31/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var eMail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var badLoginOrPassword: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        badLoginOrPassword.isHidden = true
        // Do any additional setup after loading the view.
    }

    @IBAction func unWindSegue(segue: UIStoryboardSegue){
    }
    
    @IBAction func SignInButton(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: eMail.text!, password: password.text!) { [weak self] user, error in
            if self != nil &&  error == nil {
                self!.performSegue(withIdentifier: "SignInSucces", sender: "Foo")
                print("authorize secces \(self!.eMail!)")
            } else {
                print(error!.localizedDescription)
//                self?.badLoginOrPassword.text = error!.localizedDescription
                self?.badLoginOrPassword.isHidden = false
                self?.eMail.layer.borderWidth = 1.0
                self?.eMail.layer.borderColor = UIColor.red.cgColor
                self?.password.layer.borderWidth = 1.0
                self?.password.layer.borderColor = UIColor.red.cgColor
                return
            }
        }
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        performSegue(withIdentifier: "SignUp", sender: "Foo")
    }
}

