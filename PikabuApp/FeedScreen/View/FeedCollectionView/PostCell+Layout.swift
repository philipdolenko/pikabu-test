//
//  PostCell+Layout.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 06.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit
import SnapKit


extension PostCell {
    func setUpView(){
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        setUpTitleLbl()
        setUpImageTableView()
        setUpBodyLbl()
        setUpSaveButton()
        
        if let lastSubview = contentView.subviews.last {
            contentView.bottomAnchor.constraint(equalTo: lastSubview.bottomAnchor, constant: 4).isActive = true
        }
    }
    
    private func setUpTitleLbl(){
        let titleLbl = UILabel()
        setUpLabel(label: titleLbl, with: .systemFont(ofSize: 24, weight: .bold))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTitleClick))
        titleLbl.isUserInteractionEnabled = true
        titleLbl.addGestureRecognizer(tap)
        
        titleLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(contentMargin)
            make.right.equalToSuperview().offset(-contentMargin)
            make.top.equalToSuperview().offset(12)
        }
        
        self.titleLbl = titleLbl
    }
    
    private func setUpBodyLbl(){
        let bodyLbl = UILabel()
        setUpLabel(label: bodyLbl, with: .systemFont(ofSize: 16))
        
        bodyLbl.snp.makeConstraints { (make) in
            make.left.equalTo(titleLbl.snp.left)
            make.right.equalTo(titleLbl.snp.right)
            make.top.equalTo(imageTableView.snp.bottom).offset(8)
        }
        
        self.bodyLbl = bodyLbl
    }
    
    private func setUpLabel(label: UILabel, with font: UIFont) {
        label.numberOfLines = 0
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
    }
    
    private func setUpImageTableView(){
        let imageTableView = UITableView()
        contentView.addSubview(imageTableView)
        imageTableView.isScrollEnabled = false
        imageTableView.register(PostImageCell.self, forCellReuseIdentifier: PostImageCell.identifier)
        imageTableView.delegate = self
        imageTableView.dataSource = self
        imageTableView.showsVerticalScrollIndicator = false
        imageTableView.showsHorizontalScrollIndicator = false
        imageTableView.separatorStyle = .none
        imageTableView.allowsSelection = false
        imageTableView.rowHeight = imageTableHeight
        imageTableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLbl.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(contentMargin)
            make.right.equalToSuperview().offset(-contentMargin)
            make.height.equalTo(imageTableHeight)
        }
        
        self.imageTableView = imageTableView
    }
    
    private func setUpSaveButton(){
        let saveButton = UIButton()
        saveButton.backgroundColor = .clear
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.adjustsImageWhenHighlighted = false
        saveButton.contentHorizontalAlignment = .left
        saveButton.setTitle("Сохранить", for: .normal)
        
        saveButton.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
        
        contentView.addSubview(saveButton)
        
        let halfOfContentMargin = contentMargin / 2
        
        if let saveImage = UIImage(named: "save") {
            saveButton.setImage(saveImage.withRenderingMode(.alwaysTemplate), for: .normal)
            saveButton.imageView?.tintColor = .deepGreen
            saveButton.alignTextAndImage(spacing: 8, leftOffset: halfOfContentMargin, rightOffset: halfOfContentMargin)
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(halfOfContentMargin)
            make.top.equalTo(bodyLbl.snp.bottom).offset(8)
            make.height.equalTo(44)
        }
        self.saveButton = saveButton
    }
        
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        contentView.snp.remakeConstraints { (make) in
            make.width.equalTo(bounds.size.width)
        }
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }

}
