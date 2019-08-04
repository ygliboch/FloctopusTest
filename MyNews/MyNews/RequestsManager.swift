//
//  RequestsManager.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/4/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON

class RequestsManager {
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    
    func currentCity(completationHandler: @escaping(String?)->Void) {
        ref.child("users").child("\(user!.uid)").observe(.value) { (DataSnapshot) in
            DispatchQueue.main.async {
                let dick = DataSnapshot.value as? [String : Any] ?? [:]
                print(dick)
                guard dick.isEmpty == false else { return }
                completationHandler(dick["userCity"] as? String ?? "")
            }
        }
    }
    
    func getWeatherJSON(forCity: String, completationHandler: @escaping(JSON?)->Void) {
        Alamofire.request("https://api.apixu.com/v1/forecast.json?key=4e4fb7ec428e4c159e1141119190308&q=\(forCity)&days=7").responseJSON { (result) in
        if result.data != nil && result.error == nil {
            let json = JSON(result.value!)
            completationHandler(json)
                            print(json)
        } else {
            print(result.error!.localizedDescription)
        }
        }.task?.resume()
    }
}
