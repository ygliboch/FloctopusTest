//
//  ProfileViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/2/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userSername: UITextField!
    @IBOutlet weak var userPhone: UITextField!
    @IBOutlet weak var birthDate: UIDatePicker!
    @IBOutlet weak var berthDateLabel: UILabel!
    private let viewModel = ProfileControllerViewModel()
    private var birthDateStirng: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureElements()
        setupViewModel()
        configureUserInfo()
        configureNovigationBar()
    }
    
    private func configureElements() {
        newPassword.delegate = self
        confirmPassword.delegate = self
        userName.delegate = self
        userSername.delegate = self
        userPhone.delegate = self
    }
    
    private func setupViewModel() {
        viewModel.passwordNotVerified = {
            self.configureErrorPasswordTextFields()
        }
        viewModel.failedChangePassword = {
            self.configureErrorPasswordTextFields()
        }
        viewModel.succesChangePassword = {
            self.newPassword.text = ""
            self.confirmPassword.text = ""
            self.confirmPassword.layer.borderWidth = 0
            self.newPassword.layer.borderWidth = 0.0
            self.newPassword.endEditing(true)
            self.confirmPassword.endEditing(true)
        }
    }
    
    private func configureErrorPasswordTextFields() {
        self.newPassword.layer.borderWidth = 1.0
        newPassword.layer.borderColor = UIColor.red.cgColor
        confirmPassword.layer.borderWidth = 1.0
        confirmPassword.layer.borderColor = UIColor.red.cgColor
        newPassword.text = ""
        confirmPassword.text = ""
    }
    
    private func configureUserInfo() {
        ref.child("users").child("\(user!.uid)").observe(.value) { (DataSnapshot) in
            let dick = DataSnapshot.value as? [String : Any] ?? [:]
            guard dick.isEmpty == false else { return }
            self.userName.text = dick["userName"] as? String
            self.userSername.text = dick["userSername"] as? String
            self.userPhone.text = dick["userMobile"] as? String
        }
    }
    
    private func configureNovigationBar () {
        navigationBar.topItem?.title = "My Profile"
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleDismis))
    }
    
    @objc func handleDismis () {
        guard checkInfo() else { return }
        ref.child("users").child("\(user!.uid)").child("userName").setValue(userName.text)
        ref.child("users").child("\(user!.uid)").child("userSername").setValue(userSername.text)
        ref.child("users").child("\(user!.uid)").child("userSername").setValue(userSername.text)
        ref.child("users").child("\(user!.uid)").child("userMobile").setValue(userPhone.text)
        ref.child("users").child("\(user!.uid)").child("userBirthDate").setValue(birthDateStirng!)
        performSegue(withIdentifier: "backFromProfile", sender: nil)
    }
    
    @IBAction func changePasswordButton(_ sender: Any) {
        guard !newPassword.text!.isEmpty else { return }
        viewModel.changePassword(newPassword: newPassword.text ?? "", confirmPassword: confirmPassword.text ?? "")
    }
    
    private func checkInfo () -> Bool {
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
        if userPhone.text!.isEmpty {
            userPhone.layer.borderWidth = 1.0
            userPhone.layer.borderColor = UIColor.red.cgColor
            return false
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        birthDateStirng = dateFormatter.string(from: birthDate.date)
        if birthDateStirng == nil {
            berthDateLabel.textColor = .red
            return false
        }
        return true
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
