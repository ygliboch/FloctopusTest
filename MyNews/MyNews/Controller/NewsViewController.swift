//
//  NewsViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/2/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        configureNovigationBar()
    }
    
    func configureNovigationBar () {
        navigationController?.navigationBar.barTintColor = .gray
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "MyNews"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "dismiss").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismis))
    }
    
    @objc func handleDismis () {
        dismiss(animated: true, completion: nil)
    }
}
