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
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var userPhone: UITextField!
    @IBOutlet weak var cityPicker: UIPickerView!
    @IBOutlet weak var coutryAlert: UILabel!
    @IBOutlet weak var cityAlert: UILabel!
    var countryString: String?
    var cityString: String?
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
        countryPicker.delegate = self
        cityPicker.delegate = self
        newPassword.delegate = self
        confirmPassword.delegate = self
        userName.delegate = self
        userSername.delegate = self
        userPhone.delegate = self
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
        }
    }
    
    @objc func handleDismis () {
        guard checkInfo() else { return }
        ref.child("users").child("\(user!.uid)").child("userName").setValue(userName.text)
        ref.child("users").child("\(user!.uid)").child("userSername").setValue(userSername.text)
        ref.child("users").child("\(user!.uid)").child("userSername").setValue(userSername.text)
        ref.child("users").child("\(user!.uid)").child("userMobile").setValue(userPhone.text)
        ref.child("users").child("\(user!.uid)").child("userCountry").setValue(countryString!)
        ref.child("users").child("\(user!.uid)").child("userCity").setValue(cityString!)
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
        if countryString == nil {
            coutryAlert.textColor = .red
            return false
        }
        if cityString == nil {
            cityAlert.textColor = .red
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

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPicker {
            return countryArray.count
        } else {
            if countryString == nil {
                return 5
            }
            return cityArray[countryString!]!.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == countryPicker {
            return countryArray[row]
        } else {
            if countryString == nil {
                return "--"
            }
            return cityArray[countryString!]![row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countryPicker {
            countryString = countryArray[row]
            cityString = nil
            cityPicker.reloadAllComponents()
        } else {
            cityString = cityArray[countryString!]![row]
        }
    }
}
