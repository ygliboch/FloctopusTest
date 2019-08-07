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
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var cityOicker: UIPickerView!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var dateAlert: UILabel!
    @IBOutlet weak var countryAlert: UILabel!
    @IBOutlet weak var cityAlert: UILabel!
    
    var ref: DatabaseReference?
    var user: User?
    var dateString: String?
    var countryString: String?
    var cityString: String?
    
    let countryArray: [String] = ["Ukrain", "Poland", "Germany"]
    let cityArray: [String : [String]] = [
        "Ukrain" : ["Kiev", "Kharkov", "Dnepr", "Lviv"],
        "Poland" : ["Warsaw", "Krakow", "Poznan", "Lodz"],
        "Germany" : ["Berlin", "Munich", "Koln", "Hamburg"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Auth.auth().currentUser
        userName.delegate = self
        userSername.delegate = self
        userMobile.delegate = self
        countryPicker.delegate = self
        cityOicker.delegate = self
    }

    @IBAction func backButton(_ sender: Any) {
        ref = Database.database().reference()
        user = Auth.auth().currentUser
        performSegue(withIdentifier: "BackToSignUp", sender: "Foo")
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if checkInfo() {
            let postInfo = ["userName": userName.text!, "userSername": userSername.text!, "userMobile": userMobile.text!, "userBirthDate": dateString!, "userCountry" : countryString!, "userCity" : cityString!, "userSources" : ""] as [String : Any]
            
            Database.database().reference().child("users").child("\(user!.uid)").setValue(postInfo)
            performSegue(withIdentifier: "SignUpDone", sender: "Foo")
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        dateString = dateFormatter.string(from: birthDatePicker.date)
        if dateString == nil {
            dateAlert.textColor = .red
            return false
        }
        if countryString == nil {
            countryAlert.textColor = .red
            return false
        }
        if cityString == nil {
            cityAlert.textColor = .red
            return false
        }
        print(dateString!)
        return true
    }
}

extension MoreUserDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension MoreUserDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
            cityOicker.reloadAllComponents()
        } else {
            cityString = cityArray[countryString!]![row]
        }
    }
}
