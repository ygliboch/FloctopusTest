//
//  SourcesViewModel.swift
//  MyNews
//
//  Created by Yaroslava Hlibochko on 25.11.2019.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Firebase

final class SourcesViewModel {
    private let repository = OnlineRepository()
    var allSourcesDone: ((SourcesList)->Void)?
    var userSourcesDone: (([String])->Void)?
    var successSaveUserSources: (()->Void)?
    var failedSaveUserSources: (()->Void)?
    
    func getUserSources() {
        repository.getUserSources { (response) in
            self.userSourcesDone?(self.parseUserSources(sources: response))
        }
    }
    
    func parseUserSources(sources: String) -> [String] {
        guard !sources.isEmpty else {
            return []
        }
        var userSources: [String] = []
        let splitSources = sources.split(separator: ",")
        for sub in splitSources {
            userSources.append(String(sub))
        }
        return userSources
    }
    
    func getAllSources() {
        repository.getSources { (response) in
            guard response != nil else { return }
            self.allSourcesDone?(response!)
        }
    }
    
    func saveUserSources(newSources: [String]) {
        let sources = parseNewUserSources(newSources: newSources)
        ref.child("users").child("\(user!.uid)").child("userSources").setValue("\(sources)") { (error :Error?, ref: DatabaseReference) in
            if error != nil {
                self.failedSaveUserSources?()
            } else {
                self.successSaveUserSources?()
            }
        }
    }
        
    private func parseNewUserSources(newSources: [String]) -> String {
        var sources = ""
        for sellect in newSources {
            if sources == "" {
                sources = "\(sellect)"
            } else {
                sources += ",\(sellect)"
            }
        }
        return sources
    }
    
}
