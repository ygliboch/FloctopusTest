//
//  ContainerViewModel.swift
//  MyNews
//
//  Created by Yaroslava Hlibochko on 25.11.2019.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import Foundation
import UIKit
import Firebase

final class ContainerViewModel {
    private var repository = OnlineRepository()
    var userProfileIsEmpty: (()->Void)?
    
    func isUserProfileEmpty() {
        repository.isUserProfileEmpty { (isEmpty) in
            if isEmpty {
                self.userProfileIsEmpty?()
            }
        }
    }
    
    func getSources() {
        
    }
    
}
