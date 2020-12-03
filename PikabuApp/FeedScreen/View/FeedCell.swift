//
//  FeedCell.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 03.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit
import SnapKit

class FeedCell: BaseCell {
    
    static let identifier = "FeedCell"
    
    let tableView = UITableView()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
