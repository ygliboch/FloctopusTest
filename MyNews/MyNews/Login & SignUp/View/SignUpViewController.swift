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
    private var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        eMail.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
    }

    private func setupViewModel() {
        viewModel.successCreateUser = {
            self.viewModel.addUserItems()
        }
        viewModel.failedCreateUser = {
            self.configureErrorTextFields()
            self.showToast(message: "Something went wrong. Please try again")
        }
        viewModel.successAddUserItems = {
            self.performSegue(withIdentifier: "signUpDone", sender: nil)
        }
        viewModel.failedAddUserItems = {
            self.showToast(message: "Something went wrong. Please try again")
        }
    }
    
    private func configureErrorTextFields() {
        password.layer.borderWidth = 1.0
        password.layer.borderColor = UIColor.red.cgColor
        confirmPassword.layer.borderWidth = 1.0
        confirmPassword.layer.borderColor = UIColor.red.cgColor
        password.text = ""
        confirmPassword.text = ""
    }
    
    private func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: 15, y: view.frame.size.height - 172, width: view.frame.size.width - 30, height: 48))
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = ERROR_LIGHT_RED_COLOR
        toastLabel.textColor = .orange
        toastLabel.textColor = ERROR_RED_TEXT_COLOR
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
        }, completion: { (isCompleted) in
                toastLabel.removeFromSuperview()
        })
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        if password.text != confirmPassword.text {
            configureErrorTextFields()
            return
        } 
        viewModel.createUser(email: eMail.text ?? "" , password: password.text ?? "")
    }
    
    @IBAction func unWindSegue(segue: UIStoryboardSegue){
    }
}

//MARK: - TextField
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
