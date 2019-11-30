//
//  HomeControllerViewModel.swift
//  MyNews
//
//  Created by Yaroslava Hlibochko on 25.11.2019.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Firebase

final class HomeControllerViewModel {
    private var repository = OnlineRepository()
    var userSources: ((String)->Void)?
    var newsList: ((NewsList)->Void)?
    
    func getUserSources() {
        repository.getUserSources { (userSources) in
            self.userSources?(userSources)
        }
    }
    
    func getNewsList(sources: String) {
        repository.getNews(sources: sources) { (response) in
            guard response != nil else { return }
            self.newsList?(response!)
        }
    }
}
