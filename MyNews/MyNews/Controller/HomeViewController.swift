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
    var refreshControl: UIRefreshControl!
    var fetchingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureNavigationBar()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
//        let nib = UINib(nibName: "LoadingCell", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: "loadingCell")
        tableView.register(NewsCell.self, forCellReuseIdentifier: "newsCell")
        tableView.backgroundColor = .darkGray
        tableView.separatorStyle = .singleLine
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    @objc func refresh() {
        requestsManager.getUserSources { (response) in
            if response != nil && response!.isEmpty == true {
                self.requestsManager.getNews(sources: "abc-news,business-insider-uk,infobae,info-money",
                                             completationHandler: { (news) in
                    if news != nil {
                        self.news = news!["articles"].arrayValue
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                })
            } else if response != nil {
                self.requestsManager.getNews(sources: response!, completationHandler: { (news) in
                    if news != nil {
                        self.news = news!["articles"].arrayValue
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                })
            }
        }
        
    }
    
    @objc func handleMenuToggle () {
        delegate?.handleMenuToggle(menuOption: nil, newsData: nil)
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
//        if section == 0 {
            return news.count
//        } else if fetchingMore {
//            return 1
//        }
//        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
            cell.descriptionLabel.text = news[indexPath.row]["title"].string
            cell.sourceNameLabel.text = news[indexPath.row]["source"]["name"].string
            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
//            cell.spinner.startAnimating()
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.handleMenuToggle(menuOption: nil, newsData: (news, indexPath.row))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHight = scrollView.contentSize.height
        
        if offsetY > contentHight - scrollView.frame.height * 4 {
            if !fetchingMore {
               beginBatchFatch()
            }
        }
    }
    
    func beginBatchFatch() {
        fetchingMore = true
//        print("hello")
//        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            let newNews = self.news
            self.news.append(contentsOf: newNews)
            self.fetchingMore = false
            self.tableView.reloadData()
        }
    }
}

