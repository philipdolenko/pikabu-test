//
//  PostCell.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 04.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit

class PostCell: BaseCell {
    static let identifier = "PostCell"
    
    let titleLbl =  UILabel()
    let bodyLbl = UILabel()
    let saveButton = UIButton()
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        contentView.snp.remakeConstraints { (make) in
            make.width.equalTo(bounds.size.width)
        }
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    override func setupViews() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLbl.backgroundColor = .yellow
        titleLbl.numberOfLines = 0
        titleLbl.font = UIFont.systemFont(ofSize: 24)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLbl)
        
        titleLbl.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(16)
            make.right.equalTo(contentView.snp.right).offset(-16)
            make.top.equalTo(contentView.snp.top).offset(8)
        }
        
        bodyLbl.backgroundColor = .green
        bodyLbl.numberOfLines = 0
        bodyLbl.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(bodyLbl)
        
        bodyLbl.snp.makeConstraints { (make) in
            make.left.equalTo(titleLbl.snp.left)
            make.right.equalTo(titleLbl.snp.right)
            make.top.equalTo(titleLbl.snp.bottom)
        }
        
        saveButton.backgroundColor = .red
        contentView.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { (make) in
            make.right.equalTo(bodyLbl.snp.right)
            make.left.equalTo(bodyLbl.snp.left)
            make.top.equalTo(bodyLbl.snp.bottom).offset(16)
            make.height.equalTo(44)
        }
        
        if let lastSubview = contentView.subviews.last {
            contentView.bottomAnchor.constraint(equalTo: lastSubview.bottomAnchor, constant: 10).isActive = true
        }
    }
    
    func configure(with post: Post){
        titleLbl.text = post.title ?? ""
        bodyLbl.text = post.body ?? ""
        
        saveButton.setTitle("Save Post", for: .normal)
    }
    
}
