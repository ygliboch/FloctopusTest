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
    var data: [NewsArticle]!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNovigationBar()
        configurateView()
        configurateUrl()
    }
    
    func configureNovigationBar () {
        novigationBar.topItem?.title = data[index].source.name ?? ""
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
    
    private func configurateView() {
        titleLabel.text = data[index].title ?? ""
        authorLable.text = data[index].author ?? ""
        descriptionLabel.text = data[index].description ?? ""
        contentLabel.text = data[index].content ?? ""
        let url = data[index].urlToImage ?? ""
        if let data = try? Data(contentsOf: URL(string: url)!) {
            DispatchQueue.main.async {
                self.photo.image = UIImage(data: data)
                self.photo.contentMode = .scaleAspectFit
            }
        } else {
            print("error")
        }
    }
    
    private func configurateUrl() {
        urlLabel.text = data[index].url ?? ""
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (openLink))
        urlLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func openLink() {
        guard let url = URL(string: urlLabel.text ?? "") else { return }
        UIApplication.shared.open(url)
    }
}
