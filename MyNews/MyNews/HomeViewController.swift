//
//  HomeViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/1/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var delegate: HomeControllerDelegete?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureNavigationBar()
        // Do any additional setup after loading the view.
    }
    

    @objc func handleMenuToggle () {
        delegate?.handleMenuToggle()
    }
    
    func configureNavigationBar () {
        navigationController?.navigationBar.barTintColor = .gray
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "MyNews"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-menu-30").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
    }

}
