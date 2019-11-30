//
//  WeatherTableViewCell.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/4/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit
import SwiftyJSON

enum WeekDay: Int, CustomStringConvertible {
    
    case Sunday = 1
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    
    var description: String {
        switch self {
        case .Sunday:
            return "Sunday"
        case .Monday:
            return "Monday"
        case .Tuesday:
            return "Tuesday"
        case .Wednesday:
            return "Wednesday"
        case .Thursday:
            return "Thursday"
        case .Friday:
            return "Friday"
        case .Saturday:
            return "Saturday"
        }
    }
}

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayImage: UIImageView!
    @IBOutlet weak var max: UILabel!
    @IBOutlet weak var min: UILabel!
    @IBOutlet weak var weather: UILabel!
    
    var json: JSON? {
        didSet {
            if let data = json {
                let maxTemp = "\(data["day"]["maxtemp_c"].double!.rounded())".split(separator: ".")
                max.text = maxTemp[0] + "°"
                let minTemp = "\(data["day"]["mintemp_c"].double!.rounded())".split(separator: ".")
                min.text = minTemp[0] + "°"
                weather.text = data["day"]["condition"]["text"].string!
                let url = URL(string: "https:" + "\(data["day"]["condition"]["icon"].url!)")
                if let data = try? Data(contentsOf: url!) {
                    DispatchQueue.main.async {
                        self.dayImage.image = UIImage(data: data)
                        self.dayImage.contentMode = .scaleAspectFit
                    }
                } else {
                    print("error")
                }
                let weekDay = WeekDay(rawValue: getDayOfWeek(data["date"].string!)!)
                dateLabel.text = weekDay!.description
            }
        }
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
}
