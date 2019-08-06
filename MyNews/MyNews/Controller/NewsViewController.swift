//
//  NewsViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/2/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit
import SwiftyJSON
class NewsViewController: UIViewController {
    
    @IBOutlet weak var novigationBar: UINavigationBar!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLable: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    var data: [JSON]!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNovigationBar()
        configurateView()
    }
    
    func configureNovigationBar () {
        novigationBar.topItem?.title = data[index]["source"]["name"].string
        novigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDismis))
        novigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextNews))
    }
    
    @objc func nextNews() {
        index += 1
        if index >= data.count { return }
        configurateView()
    }
    
    @objc func handleDismis () {
        performSegue(withIdentifier: "backFromNews", sender: nil)
    }
    
    func configurateView() {
        titleLabel.text = data[index]["title"].string
        novigationBar.topItem?.title = data[index]["source"]["name"].string
        if data[index]["author"].string != nil {
            authorLable.text = data[index]["author"].string
        }
        descriptionLabel.text = data[index]["description"].string
        contentLabel.text = data[index]["content"].string
        urlLabel.text = data[index]["url"].string
        let url = data[index]["urlToImage"].url
        if url != nil, let data = try? Data(contentsOf: url!) {
            DispatchQueue.main.async {
                self.photo.image = UIImage(data: data)
                self.photo.contentMode = .scaleAspectFit
            }
        } else {
            print("error")
        }
    }
}
