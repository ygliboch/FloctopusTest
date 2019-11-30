

//
//  NewsCell.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/5/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    let sourceNameLabel: UILabel = {
        let source = UILabel()
        source.numberOfLines = 0
        source.textColor = .blue
        source.font = UIFont.systemFont(ofSize: 16)
        return source
    }()
    
    let descriptionLabel: UILabel = {
        let description = UILabel()
        description.numberOfLines = 0
        description.textColor = .gray
        description.font = UIFont.systemFont(ofSize: 20)
        return description
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSourceLabel()
        addDescriptionLabel()
    }
    
    private func addSourceLabel() {
        addSubview(sourceNameLabel)
        sourceNameLabel.translatesAutoresizingMaskIntoConstraints = false
        sourceNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        sourceNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        sourceNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
    }
    
    private func addDescriptionLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: sourceNameLabel.topAnchor, constant: 25).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
