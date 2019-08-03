//
//  WeatherViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/2/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase


class WeatherViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var textWeather: UILabel!
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    var currentDay: [String : Any] = [:]
    var allDays: [String: Any] = [:]
    var city:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref.child("users").child("\(user!.uid)").observe(.value) { (DataSnapshot) in
            let dick = DataSnapshot.value as? [String : Any] ?? [:]
            print(dick)
            guard dick.isEmpty == false else { return }
            self.city = dick["userCity"] as? String ?? ""
            self.configureNovigationBar()
            self.getWeather()
        }
    }
    
    func getWeather () {        Alamofire.request("https://api.apixu.com/v1/forecast.json?key=4e4fb7ec428e4c159e1141119190308&q=\(city!)&days=7").responseJSON { (result) in
            if result.data != nil && result.error == nil {
                let json = JSON(result.value!)
                print(json)
                self.textWeather.text = json["current"]["condition"]["text"].string
                let url = URL(string: "https:" + "\(json["current"]["condition"]["icon"].url!)")
                print(url!)
                if let data = try? Data(contentsOf: url!) {
                    DispatchQueue.main.async {
                        self.image.image = UIImage(data: data)
                        self.image.contentMode = .scaleAspectFill
                    }
                } else {
                    print("error")
                }
            } else {
                print(result.error!.localizedDescription)
            }
        }
    }
    
    func configureNovigationBar () {
        navigationBar.topItem?.title = "Weather"
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDismis))
    }
    
    @objc func handleDismis () {
        performSegue(withIdentifier: "backFromWeatherSegue", sender: "Foo")
    }
}
