//
//  ProfileControllerViewModel.swift
//  MyNews
//
//  Created by Yaroslava Hlibochko on 06.12.2019.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileControllerViewModel {
    var passwordNotVerified: (()->Void)?
    var failedChangePassword: (()->Void)?
    var succesChangePassword: (()->Void)?
    
    func changePassword(newPassword: String, confirmPassword: String) {
        guard newPassword == confirmPassword else {
            self.passwordNotVerified?()
            return
        }
        
        Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (Error) in
            if Error != nil {
                self.failedChangePassword?()
            } else {
                self.succesChangePassword?()
//                self.newPassword.text = ""
//                self.confirmPassword.text = ""
            }
        })
    }
}
