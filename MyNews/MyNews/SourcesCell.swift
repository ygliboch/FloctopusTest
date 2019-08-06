//
//  SourcesCell.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/5/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit
import SwiftyJSON

class SourcesCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var box: UIButton!
    var sellect: Bool!
    var id: String!
    
    var data: JSON? {
        didSet {
            if data != nil {
                nameLabel.text = data!["name"].string
                categoryLabel.text = data!["category"].string
                descriptionLabel.text = data!["description"].string
                id = data!["id"].string
                box.isUserInteractionEnabled = false
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        box.setImage(UIImage(named: selected ? "checkBox" : "uncheckBox"), for:.normal)
    }
}
