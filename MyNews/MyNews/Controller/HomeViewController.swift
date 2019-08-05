//
//  HomeViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/1/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class HomeViewController: UIViewController {
    var tableView: UITableView!
    var delegate: HomeControllerDelegete?
    var userSources: String = ""
    var news: [JSON] = []
    var requestsManager = RequestsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureNavigationBar()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestsManager.getUserSources { (response) in
            if response != nil {
                self.requestsManager.getNews(sources: response!, completationHandler: { (news) in
                    if news != nil {
                        self.news = news!["articles"].arrayValue
                        self.tableView.reloadData()
                    }
                })
//                print(response!)
            }
        }
    }
    
    
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: "newsCell")
        tableView.backgroundColor = .darkGray
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 80
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }

    @objc func handleMenuToggle () {
        delegate?.handleMenuToggle(menuOption: nil)
    }
    
    func configureNavigationBar () {
        navigationController?.navigationBar.barTintColor = .gray
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "MyNews"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-menu-30").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        cell.descriptionLabel.text = news[indexPath.row]["title"].string
        return cell
    }
    
    
}

