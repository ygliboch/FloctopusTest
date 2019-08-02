//
//  MenuViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/1/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit

enum MenuOptions: Int, CustomStringConvertible {
//    case News
    case Sources
    case Weather
    case Profile
    case Exit
    
    var description: String {
        switch self {
//        case .News:
//            return "News"
        case .Sources:
            return "Sources"
        case .Weather:
            return "Weater"
        case .Profile:
            return "Profile"
        case .Exit:
            return "Exit"
        }
    }
    
    var image: UIImage {
        switch self {
//        case .News:
//            return UIImage(named: "news") ?? UIImage()
        case .Sources:
            return UIImage(named: "sources") ?? UIImage()
        case .Weather:
            return UIImage(named: "weather") ?? UIImage()
        case .Profile:
            return UIImage(named: "profile") ?? UIImage()
        case .Exit:
            return UIImage(named: "exit") ?? UIImage()
        }
    }
}

class MenuViewController: UIViewController {

    var tableView: UITableView!
    var delegate: HomeControllerDelegete?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // Do any additional setup after loading the view.
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.backgroundColor = .darkGray
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
        let menuOption = MenuOptions(rawValue: indexPath.row)
        cell.iconView.image = menuOption?.image
        cell.descriptionLabel.text = menuOption?.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = MenuOptions(rawValue: indexPath.row)
        delegate?.handleMenuToggle(menuOption: menuOption)
    }
}
