//
//  LoginViewController.swift
//  MyNews
//
//  Created by Yaroslava Hlibochko on 25.11.2019.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var eMail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signInOutlet: UIButton!
    private var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
//        configureKeyboardNotifications()
        eMail.delegate = self
        password.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInOutlet.clipsToBounds = true
        signInOutlet.layer.cornerRadius = 5
        addButtonGradient()
    }
    
    private func setupViewModel() {
        viewModel.failedUserSignIn = { [weak self] in
            self!.badAuth()
        }
        viewModel.successUserSignIn = { [weak self] in
            self!.performSegue(withIdentifier: "SignInSucces", sender: "Foo")
        }
    }
    
    private func badAuth() {
        eMail.endEditing(true)
        password.endEditing(true)
        eMail.layer.borderWidth = 1.0
        eMail.layer.borderColor = UIColor.red.cgColor
        password.layer.borderWidth = 1.0
        password.layer.borderColor = UIColor.red.cgColor
        password.text = ""
        showToast(message: "Bad password or login")
    }
//
//    private func configureKeyboardNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//
//    }
    
//    @objc func keyoardWillShow(notification: NSNotification) {
//    let userInfo = notification.userInfo!
//    let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
//    let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
////    self.newMessageAreaBottomAnchor.constant +=  keyboardViewEndFrame.height - (UIScreen.main.bounds.maxY - newMessageArea.frame.maxY)
////    UIView.animate(withDuration: animationDurarion) {
////        self.view.layoutIfNeeded()
////    }
//
//    }
    
//    @objc func keyboardWillHide() {
//
//    }
    
    @IBAction func unWindSegue(segue: UIStoryboardSegue){
        eMail.text = ""
        password.text = ""
    }
    
    @IBAction func SignInButton(_ sender: UIButton) {
        eMail.endEditing(true)
        password.endEditing(true)
        viewModel.signInUser(email: eMail.text ?? "", passward: password.text ?? "")
    }
    
    private func addButtonGradient() {
        let colours = [MAIN_BLUE_COLOR, GRADIENT_LIGHT_BLUE_COLOR]
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = signInOutlet.bounds
        gradient.colors = colours.map { $0.cgColor }
        signInOutlet.layer.insertSublayer(gradient, at: 0)
    }
    
    func showToast(message : String) {
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

    @IBAction func SignUpButton(_ sender: Any) {
        performSegue(withIdentifier: "SignUp", sender: "Foo")
    }
}

//MARK: - TextField
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
