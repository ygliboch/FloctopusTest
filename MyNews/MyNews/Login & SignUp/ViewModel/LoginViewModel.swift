//
//  LoginViewModel.swift
//  MyNews
//
//  Created by Yaroslava Hlibochko on 25.11.2019.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import Foundation
import UIKit
import Firebase

final class LoginViewModel {
    private var repository = OnlineRepository()
    var failedUserSignIn: (()->Void)?
    var successUserSignIn: (()->Void)?
    var failedCreateUser: (()->Void)?
    var successCreateUser: (()->Void)?
    var successAddUserItems: (()->Void)?
    var failedAddUserItems: (()->Void)?
    
    func signInUser(email: String, passward: String) {
        repository.signInUser(email: email, password: passward) { (isSignIn) in
            if isSignIn {
                self.successUserSignIn?()
            } else {
                self.failedUserSignIn?()
            }
        }
    }
    
    func createUser(email: String, password: String) {
        repository.createUser(email: email, password: password) { (isCreated) in
            if isCreated {
                self.successCreateUser?()
            } else {
                self.failedCreateUser?()
            }
        }
    }
    
    func addUserItems() {
        repository.addUserItems { (isSuccess) in
            if isSuccess {
                self.successAddUserItems?()
            } else {
                self.failedAddUserItems?()
            }
        }
    }
}
