
//
//  BarCell.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 02.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit
import SnapKit

class BarCell: BaseCell {
    
    static let identifier = "BarCell"
    
    let tabLbl = UILabel()
    
    override var isHighlighted: Bool {
        didSet {
            tabLbl.textColor = isHighlighted ? .white : UIColor.white.withAlphaComponent(0.7)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            tabLbl.textColor = isSelected ? .white : UIColor.white.withAlphaComponent(0.7)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(tabLbl)
        
        tabLbl.textAlignment = .center
        tabLbl.textColor = UIColor.white.withAlphaComponent(0.7)
        
        tabLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(6)
            make.height.equalTo(40)
        }
    }
}
