//
//  WeatherViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/2/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        configureNovigationBar()
        // Do any additional setup after loading the view.
    }
    

    func configureNovigationBar () {
        navigationBar.topItem?.title = "Weather"
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDismis))
//        navigationController?.navigationBar.barTintColor = .gray
//        navigationController?.navigationBar.barStyle = .black
//        navigationItem.title = "Weather"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "dismiss").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismis))
    }
    
    @objc func handleDismis () {
        performSegue(withIdentifier: "backFromWeatherSegue", sender: "Foo")
//        dismiss(animated: true, completion: nil)
    }

}
