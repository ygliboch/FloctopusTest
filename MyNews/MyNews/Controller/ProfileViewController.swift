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
    @IBOutlet weak var userCountryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var userPhone: UITextField!
    var currTextFild: UITextField!
    
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    let countryArray: [String] = ["Ukrain", "Poland", "Germany"]
    let cityArray: [String : [String]] = [
        "Ukrain" : ["Kiev", "Kharkov", "Dnepr", "Lviv"],
        "Poland" : ["Warsaw", "Krakow", "Poznan", "Lodz"],
        "Germany" : ["Berlin", "Munich", "Koln", "Hamburg"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.isHidden = true
        userCountryTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cityTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        configureUserInfo()
        configureNovigationBar()
    }
    
    func configureNovigationBar () {
        navigationBar.topItem?.title = "My Profile"
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleDismis))
    }
    
    func configureUserInfo() {
        ref.child("users").child("\(user!.uid)").observe(.value) { (DataSnapshot) in
            let dick = DataSnapshot.value as? [String : Any] ?? [:]
            guard dick.isEmpty == false else { return }
            self.userName.text = dick["userName"] as? String
            self.userSername.text = dick["userSername"] as? String
            self.userPhone.text = dick["userMobile"] as? String
            self.userCountryTextField.text = dick["userCountry"] as? String
            self.cityTextField.text = dick["userCity"] as? String
        }
    }
    
    @objc func handleDismis () {
        guard checkInfo() else { return }
        ref.child("users").child("\(user!.uid)").child("userName").setValue(userName.text)
        ref.child("users").child("\(user!.uid)").child("userSername").setValue(userSername.text)
        ref.child("users").child("\(user!.uid)").child("userSername").setValue(userSername.text)
        ref.child("users").child("\(user!.uid)").child("userMobile").setValue(userPhone.text)
        ref.child("users").child("\(user!.uid)").child("userCountry").setValue(userCountryTextField.text)
        ref.child("users").child("\(user!.uid)").child("userCity").setValue(cityTextField.text)
        performSegue(withIdentifier: "backFromProfile", sender: "Foo")
    }
    
    @IBAction func changePasswordButton(_ sender: Any) {
        if newPassword.text != confirmPassword.text {
            newPassword.layer.borderWidth = 1.0
            newPassword.layer.borderColor = UIColor.red.cgColor
            confirmPassword.layer.borderWidth = 1.0
            confirmPassword.layer.borderColor = UIColor.red.cgColor
            newPassword.text = ""
            confirmPassword.text = ""
            return
        }
        Auth.auth().currentUser?.updatePassword(to: newPassword.text!, completion: { (Error) in
            if Error != nil {
                print(Error!.localizedDescription)
            } else {
                self.newPassword.text = ""
                self.confirmPassword.text = ""
            }
        })
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
        if userPhone.text!.isEmpty {
            userPhone.layer.borderWidth = 1.0
            userPhone.layer.borderColor = UIColor.red.cgColor
            return false
        }
        if userCountryTextField.text!.isEmpty {
            userCountryTextField.layer.borderWidth = 1.0
            userCountryTextField.layer.borderColor = UIColor.red.cgColor
            return false
        }
        if cityTextField.text!.isEmpty {
            cityTextField.layer.borderWidth = 1.0
            cityTextField.layer.borderColor = UIColor.red.cgColor
            return false
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == userCountryTextField {
            currTextFild = textField
            currTextFild.isUserInteractionEnabled = false
            picker.isHidden = false
            picker.reloadAllComponents()
        } else if textField == cityTextField {
            currTextFild = textField
            currTextFild.isUserInteractionEnabled = false
            picker.isHidden = false
            picker.reloadAllComponents()
        }
    }
}

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currTextFild == userCountryTextField {
            return countryArray.count
        }
        else {
            if userCountryTextField.text!.isEmpty {
                return 5
            }
            return cityArray[userCountryTextField.text!]!.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currTextFild == userCountryTextField {
           return countryArray[row]
        } else {
            if userCountryTextField.text!.isEmpty {
                return "--"
            }
            return cityArray[userCountryTextField.text!]![row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currTextFild == userCountryTextField {
            currTextFild.text = countryArray[row]
            currTextFild.isUserInteractionEnabled = true
            picker.isHidden = true
        } else {
            currTextFild.text = cityArray[userCountryTextField.text!]![row]
            currTextFild.isUserInteractionEnabled = true
            picker.isHidden = true
        }
    }
}
