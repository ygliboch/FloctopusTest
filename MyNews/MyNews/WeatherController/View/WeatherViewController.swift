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
    @IBOutlet weak var textWeatherLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var daysTableView: UITableView!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunsetImg: UIImageView!
    @IBOutlet weak var sunriseImg: UIImageView!
    
//    var city:String?
//    var json: JSON?
//    var allDays: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNovigationBar()
//        getInfoCurrentDay(data: json!)
//        getAllDays(data: json!)
        daysTableView.delegate = self
        daysTableView.dataSource = self
    }
    
//    func getInfoCurrentDay(data: JSON) {
//        cityLabel.text = city!
//        let url = URL(string: "https:" + "\(data["current"]["condition"]["icon"].url!)")
//        if let data = try? Data(contentsOf: url!) {
//            DispatchQueue.main.async {
//                self.image.image = UIImage(data: data)
//                self.image.contentMode = .scaleAspectFill
//            }
//        } else {
//            print("error")
//        }
//        let temperature = "\(data["current"]["temp_c"].double!.rounded())".split(separator: ".")
//        temperatureLabel.text = temperature[0] + "°"
//        textWeatherLabel.text = data["current"]["condition"]["text"].string!
//        let feelsTemperature = "\(data["current"]["feelslike_c"].double!.rounded())".split(separator: ".")
//        feelsLikeLabel.text = "Feels like: " + feelsTemperature[0] + "°"
//        let wind = "\(data["current"]["wind_kph"].double!.rounded())".split(separator: ".")
//        windSpeedLabel.text = "Wind: " + wind[0] + " km/h"
//        sunset.text = data["forecast"]["forecastday"][0]["astro"]["sunset"].string
//        sunrise.text = data["forecast"]["forecastday"][0]["astro"]["sunrise"].string
//        sunsetImg.image = #imageLiteral(resourceName: "icons8-sunset-16")
//        sunsetImg.contentMode = .scaleToFill
//        sunriseImg.image = #imageLiteral(resourceName: "icons8-sunrise-16")
//        sunriseImg.contentMode = .scaleToFill
//        let min = "\(data["forecast"]["forecastday"][0]["day"]["mintemp_c"].double!.rounded())".split(separator: ".")
//        let max = "\(data["forecast"]["forecastday"][0]["day"]["maxtemp_c"].double!.rounded())".split(separator: ".")
//        minTemp.text = "min: " + min[0] + "°"
//        maxTemp.text = "max: " + max[0] + "°"
//    }
//
//    func getAllDays(data: JSON) {
//        let all = data["forecast"]["forecastday"]
//        for day in all {
//            if day.0 == "0" {
//                continue
//            }
//            allDays.append(day.1)
//        }
//    }
    
    func configureNovigationBar () {
        navigationBar.topItem?.title = "Weather"
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDismis))
    }
    
    @objc func handleDismis () {
        performSegue(withIdentifier: "backFromWeatherSegue", sender: "Foo")
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return allDays.count
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = daysTableView.dequeueReusableCell(withIdentifier: "daysCell", for: indexPath) as! WeatherTableViewCell
//        cell.json = allDays[indexPath.row]
        cell.layer.cornerRadius = 5
        cell.selectionStyle = .none
        return cell
    }
}
