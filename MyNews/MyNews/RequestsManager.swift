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
    
    func getNews(sources: String, completationHandler: @escaping(JSON?)->Void) { Alamofire.request("https://newsapi.org/v2/top-headlines?sources=\(sources)&apiKey=d9190df3b0dc4cffa64adadb38af6078").responseJSON { (response) in
            if response.data != nil && response.error == nil {
                let json = JSON(response.value!)
                completationHandler(json)
            } else {
                print(response.error!.localizedDescription)
            }
        }
    }
    
    func currentCity(completationHandler: @escaping(String?)->Void) {
        ref.child("users").child("\(user!.uid)").observe(.value) { (DataSnapshot) in
            DispatchQueue.main.async {
                let dick = DataSnapshot.value as? [String : Any] ?? [:]
                guard dick.isEmpty == false else { return }
                completationHandler(dick["userCity"] as? String ?? "")
            }
        }
    }
    
    func getUserSources(completationHandler: @escaping(String?)->Void) {
        ref.child("users").child("\(user!.uid)").observe(.value) { (DataSnapshot) in
            DispatchQueue.main.async {
                let dick = DataSnapshot.value as? [String : Any] ?? [:]
                guard dick.isEmpty == false else { return }
                completationHandler(dick["userSources"] as? String ?? "")
            }
        }
    }
    
    func getWeatherJSON(forCity: String, completationHandler: @escaping(JSON?)->Void) {
        Alamofire.request("https://api.apixu.com/v1/forecast.json?key=4e4fb7ec428e4c159e1141119190308&q=\(forCity)&days=7").responseJSON { (result) in
        if result.data != nil && result.error == nil {
            let json = JSON(result.value!)
            completationHandler(json)
        } else {
            print(result.error!.localizedDescription)
        }
        }.task?.resume()
    }
    
    func getSources(completationHandler: @escaping(JSON?)->Void) {
        Alamofire.request("https://newsapi.org/v2/sources?apiKey=d9190df3b0dc4cffa64adadb38af6078").responseJSON { (response) in
            if response.data != nil && response.error == nil {
                let json = JSON(response.value!)
                completationHandler(json)
            } else {
                print(response.error!.localizedDescription)
            }
        }.task?.resume()
    }
}
