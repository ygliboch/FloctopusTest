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
    @IBOutlet weak var navigationBar: UINavigationBar!
    private var viewModel = SourcesViewModel()
    private var userSources: [String] = []
    private var allSources: [Source] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNovigationBar()
        setupViewModel()
        viewModel.getAllSources()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupViewModel() {
        viewModel.allSourcesDone = { (response) in
            self.allSources = response.sources
            self.viewModel.getUserSources()
        }
        viewModel.userSourcesDone = { (response) in
            self.userSources = response
            self.tableView.reloadData()
        }
        viewModel.successSaveUserSources = {
            self.performSegue(withIdentifier: "backFromSourcesSegue", sender: nil)
        }
        viewModel.failedSaveUserSources = {
            self.showAlert(title: "", message: "")
        }
    }

    func configureNovigationBar () {
        navigationBar.topItem?.title = "Sources"
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDismis))
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.performSegue(withIdentifier: "backFromSourcesSegue", sender: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func handleDismis () {
        viewModel.saveUserSources(newSources: userSources)
    }
}

extension SourcesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSources.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sourcesCell", for: indexPath) as! SourcesCell
        let id = allSources[indexPath.row].id ?? ""
        cell.selectionStyle = .none
        if userSources.contains(id) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        cell.data = allSources[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let id = allSources[indexPath.row].id ?? ""
        if userSources.contains(id) {
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
        let id = allSources[indexPath.row].id ?? ""
        userSources.append(id)
    }
}
