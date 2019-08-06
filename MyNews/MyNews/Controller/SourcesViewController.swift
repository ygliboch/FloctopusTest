//
//  SourcesViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/2/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase

class SourcesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var json: JSON?
    var userSources: [String]!
    var allSources: [JSON] = []
    @IBOutlet weak var navigationBar: UINavigationBar!
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNovigationBar()
        getSourcesArray()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getSourcesArray () {
        for article in json!["sources"]{
            allSources.append(article.1)
        }
    }

    func configureNovigationBar () {
        navigationBar.topItem?.title = "Sources"
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDismis))
    }
    
    @objc func handleDismis () {
        var sources = ""
        for sellect in userSources {
            if sources == "" {
                sources = "\(sellect)"
            } else {
                sources += ",\(sellect)"
            }
        }
        ref.child("users").child("\(user!.uid)").child("userSources").setValue("\(sources)") { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
                self.performSegue(withIdentifier: "backFromSourcesSegue", sender: "Foo")
            }
        }
    }
}

extension SourcesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSources.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sourcesCell", for: indexPath) as! SourcesCell
        let id = allSources[indexPath.row]["id"].string!
        cell.selectionStyle = .none
        if userSources.contains(id) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        cell.data = allSources[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let id = allSources[indexPath.row]["id"].string
        if userSources.contains(id!) {
            let sources: [String] = userSources
            userSources = []
            for sour in sources {
                if id == "\(sour)" {
                    continue
                } else {
                    userSources.append("\(sour)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = allSources[indexPath.row]["id"].string
        userSources.append(id!)
    }
}
