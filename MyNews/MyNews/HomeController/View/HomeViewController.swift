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
    private var tableView = UITableView()
    var delegate: HomeControllerDelegete?
    private var news: [NewsArticle] = []
    private var refreshControl = UIRefreshControl()
    private var fetchingMore = false
    private let viewModel = HomeControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        configureNavigationBar()
        configureTableView()
        configureRefreshControl()
        addTableViewConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    private func setupViewModel() {
        viewModel.userSources = { (sources) in
            var sources = sources
            if sources.isEmpty {
                sources = "abc-news,business-insider-uk,infobae,info-money"
            }
            self.viewModel.getNewsList(sources: sources)
        }
        viewModel.newsList = { (list) in
            self.news = list.articles
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    
    private func configureNavigationBar () {
        navigationController?.navigationBar.barTintColor = .gray
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "MyNews"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-menu-30").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: "newsCell")
        tableView.backgroundColor = .darkGray
        tableView.separatorStyle = .singleLine
        view.addSubview(tableView)
    }
    
    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func addTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
    }

    @objc func refresh() {
        viewModel.getUserSources()
    }
    
    @objc func handleMenuToggle () {
        delegate?.handleMenuToggle(menuOption: nil)
    }
}

//MARK: - TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        cell.descriptionLabel.text = news[indexPath.row].description ?? ""
        cell.sourceNameLabel.text = news[indexPath.row].source.name ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (delegate as? ContainerViewController)?.performSegue(withIdentifier: "newsSegue", sender: (news, indexPath.row))
    }
}

