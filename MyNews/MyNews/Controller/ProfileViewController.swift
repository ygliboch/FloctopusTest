//
//  ProfileViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/2/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let countryArray: [String] = ["Ukrain", "Poland", "Germany"]
    var filterCountryArray: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterCountryArray = countryArray
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.icon
        configureNovigationBar()
    }
    
    func configureNovigationBar () {
        navigationBar.topItem?.title = "My Profile"
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDismis))
    }
    
    @objc func handleDismis () {
        performSegue(withIdentifier: "backFromProfile", sender: "Foo")
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCountryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryCell
        cell.countryLabel.text = filterCountryArray[indexPath.row]
        return cell
    }
    
    
}

extension ProfileViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterCountryArray = searchText.isEmpty ? countryArray : countryArray.filter { (item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
}
