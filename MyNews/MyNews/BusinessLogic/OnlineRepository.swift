//
//  OnlineRepository.swift
//  MyNews
//
//  Created by Yaroslava Hlibochko on 25.11.2019.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import Alamofire
import SwiftyJSON

let ref = Database.database().reference()
let user = Auth.auth().currentUser

struct SourcesList: Decodable {
    var status: String?
    var sources: [Source]
}

struct Source: Decodable {
    var category: String?
    var country: String?
    var id: String?
    var language: String?
    var description: String?
    var name: String?
    var url: String?
}

struct NewsList: Decodable {
    var status: String
    var totalResults: Int
    var articles: [NewsArticle]
}

struct NewsArticle: Decodable {
    var author: String?
    var content: String?
    var description: String?
    var publishedAt: String?
    var source: SoursNewsArticle
    var title: String?
    var url: String?
    var urlToImage: String?
}

struct SoursNewsArticle: Decodable {
    var id: String?
    var name: String?
}

final class OnlineRepository {
    
    func signInUser(email: String, password: String, completion: @escaping ((Bool)->Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { (response, error) in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func createUser(email: String, password: String, complation: @escaping ((Bool)->Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { (response, error) in
            guard error == nil else {
                complation(false)
                return
            }
            complation(true)
        }
    }
    
    func addUserItems(complation: @escaping ((Bool)->Void)) {
        let postInfo = ["userName": "", "userSername": "", "userMobile": "", "userBirthDate": "", "userCountry" : "", "userCity" : "", "userSources" : ""] as [String : Any]
        let user = Auth.auth().currentUser
        Database.database().reference().child("users").child("\(user!.uid)").setValue(postInfo) { (error:Error?, ref:DatabaseReference) in
            if error != nil {
                complation(false)
            } else {
                complation(true)
            }
        }
    }
    
    func isUserProfileEmpty(complationHandler: @escaping(Bool)->Void) {
        ref.child("users").child("\(user!.uid)").observe(.value) { (DataSnapshot) in
            DispatchQueue.main.async {
                let dick = DataSnapshot.value as? [String : Any] ?? [:]
                guard dick.isEmpty == false else { return }
                let name = dick["userName"] as! String
                let sername = dick["userSername"] as! String
                let phone = dick["userMobile"] as! String
                let country = dick["userCountry"] as! String
                let city = dick["userCity"] as! String
                let date = dick["userBirthDate"] as! String
                if name.isEmpty || sername.isEmpty || phone.isEmpty || country.isEmpty
                    || city.isEmpty || date.isEmpty {
                    complationHandler(true)
                } else {
                    complationHandler(false)
                }
            }
        }
    }
    
    func getNews(sources: String, completionHandler: @escaping(NewsList?)->Void) { Alamofire.request("https://newsapi.org/v2/top-headlines?sources=\(sources)&apiKey=d9190df3b0dc4cffa64adadb38af6078").responseJSON { (response) in
        if response.data != nil && response.error == nil {
            if let decOBJ: NewsList = try?
                JSONDecoder().decode(NewsList.self, from: response.data!) {
                completionHandler(decOBJ)
            } else {
                completionHandler(nil)
            }
        } else {
            print(response.error!.localizedDescription)
            completionHandler(nil)
        }
        }
    }
    
    func currentCity(completionHandler: @escaping(String?)->Void) {
        ref.child("users").child("\(user!.uid)").observe(.value) { (DataSnapshot) in
            DispatchQueue.main.async {
                let dick = DataSnapshot.value as? [String : Any] ?? [:]
                guard dick.isEmpty == false else {
                    completionHandler(nil)
                    return
                }
                completionHandler(dick["userCity"] as? String ?? "")
            }
        }
    }
    
    func getUserSources(complationHandler: @escaping(String)->Void) {
        ref.child("users").child("\(user!.uid)").observe(.value) { (DataSnapshot) in
            let dick = DataSnapshot.value as? [String : Any] ?? [:]
            guard dick.isEmpty == false else {
                complationHandler("")
                return
                
            }
            complationHandler(dick["userSources"] as? String ?? "")
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
    
    func getSources(completionHandler: @escaping(SourcesList?)->Void) {
        Alamofire.request("https://newsapi.org/v2/sources?apiKey=d9190df3b0dc4cffa64adadb38af6078").responseJSON { (response) in
            if response.data != nil && response.error == nil {
                if let decOBJ: SourcesList = try?
                JSONDecoder().decode(SourcesList.self, from: response.data!) {
                    completionHandler(decOBJ)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }.task?.resume()
    }
}
