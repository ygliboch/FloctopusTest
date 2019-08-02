//
//  MenuTableViewCell.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/2/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    let iconView: UIImageView = {
        let icon = UIImageView()
//        icon.contentMode = .scaleAspectFill
        icon.clipsToBounds = true
        return icon
    }()
    
    let descriptionLabel: UILabel = {
        let description = UILabel()
        description.textColor = .gray
        description.font = UIFont.systemFont(ofSize: 16)
        return description
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
//        iconView.widthAnchor.constraint(equalTo: widthAnchor, constant: 5).isActive = true
//        iconView.heightAnchor.constraint(equalTo: heightAnchor, constant: 5).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
