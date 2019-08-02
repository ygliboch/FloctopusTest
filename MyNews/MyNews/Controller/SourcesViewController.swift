//
//  SourcesViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/2/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit

class SourcesViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        configureNovigationBar()
        // Do any additional setup after loading the view.
    }
    

    func configureNovigationBar () {
        navigationBar.topItem?.title = "Sources"
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDismis))
//        navigationController?.navigationBar.barTintColor = .gray
//        navigationController?.navigationBar.barStyle = .black
//        navigationItem.title = "Sources"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "dismiss").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismis))
    }
    
    @objc func handleDismis () {
         performSegue(withIdentifier: "backFromSourcesSegue", sender: "Foo")
//        dismiss(animated: true, completion: nil)
    }

}
