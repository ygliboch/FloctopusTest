//
//  WeatherControllerViewModel.swift
//  MyNews
//
//  Created by Yaroslava Hlibochko on 29.11.2019.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import Foundation

class WeatherControllerViewModel {
    private let repository = OnlineRepository()
    var successFetchingSity: ((String)->Void)?
    var failedFetchingSity: (()->Void)?
    
    func getCurrentCity() {
        repository.currentCity { (response) in
            guard response != nil else {
                self.failedFetchingSity?()
                return
            }
            self.successFetchingSity?(response!)
        }
    }
}
