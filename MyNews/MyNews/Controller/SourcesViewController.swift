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
        var sellectSources = ""
        let cells = tableView.visibleCells
        for cell in cells {
            let cell = cell as! SourcesCell
            if cell.sellect == true {
                if sellectSources.isEmpty {
                    sellectSources = cell.id
                } else {
                    sellectSources += "," + cell.id
                }
            }
        }
        if sellectSources.isEmpty {
            sellectSources = "abc-news-au,news24,rbc,google-news-uk"
        }
        ref.child("users").child("\(user!.uid)").child("userSources").setValue("\(sellectSources)")
        performSegue(withIdentifier: "backFromSourcesSegue", sender: "Foo")
    }
}

extension SourcesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSources.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sourcesCell", for: indexPath) as! SourcesCell
        let id = allSources[indexPath.row]["id"].string!
        if userSources.contains(id) {
            cell.box.setImage(#imageLiteral(resourceName: "checkBox"), for: .normal)
            cell.sellect = true
        } else {
            cell.box.setImage(#imageLiteral(resourceName: "uncheckBox"), for: .normal)
            cell.sellect = false
        }
        cell.data = allSources[indexPath.row]
        return cell
    }
}
