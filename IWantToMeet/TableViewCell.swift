//
//  TableViewCell.swift
//  IWantToMeet
//
//  Created by Rafaela Galdino on 12/08/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {    
    let cellImage = UIImageView()
    let cellTitle = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        cellImage.contentMode = .scaleAspectFill
        cellImage.layer.masksToBounds = true
        addSubview(cellImage)
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        cellImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        cellImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cellImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        cellTitle.textColor = .black
        addSubview(cellTitle)
        cellTitle.translatesAutoresizingMaskIntoConstraints = false
        cellTitle.centerYAnchor.constraint(equalTo: cellImage.centerYAnchor, constant: 0).isActive = true
        cellTitle.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 20).isActive = true

    }
}
