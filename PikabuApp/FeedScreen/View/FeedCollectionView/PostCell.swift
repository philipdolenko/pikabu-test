//
//  PostCell.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 04.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit

protocol PostSaveStateHandler {
    func switchSaveState(for post: Post)
}

class PostCell: BaseCell {
    static let identifier = "PostCell"
    
    let titleLbl =  UILabel()
    let bodyLbl = UILabel()
    let saveButton = UIButton()
    

    private let contentMargin: CGFloat = 16
    private lazy var halfOfContentMargin = self.contentMargin / 2.0
    
    var post: Post? = nil
    var postSaver: PostSaveStateHandler? = nil
    
    func configure(with post: Post, and postSaver: PostSaveStateHandler){
        self.post = post
        self.postSaver = postSaver
        
        
        titleLbl.text = post.title
        bodyLbl.text = post.body ?? ""
        
        saveButton.imageView?.tintColor = post.isSaved ? .deepGreen : .gray
        
        let shouldHaveTopOffset = post.body != nil && post.body != ""
        bodyLbl.snp.updateConstraints { (make) in
            make.top.equalTo(titleLbl.snp.bottom).offset(shouldHaveTopOffset ? 8: 0)
        }
    }
    
    override func setupViews() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        setUpLabels()
        setUpSaveButton()
        
        if let lastSubview = contentView.subviews.last {
            contentView.bottomAnchor.constraint(equalTo: lastSubview.bottomAnchor, constant: 4).isActive = true
        }
    }
    
    private func setUpLabels(){
        setUpLabel(label: titleLbl, with: .systemFont(ofSize: 24, weight: .bold))
        
        titleLbl.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(contentMargin)
            make.right.equalTo(contentView.snp.right).offset(-contentMargin)
            make.top.equalTo(contentView.snp.top).offset(12)
        }
        
        setUpLabel(label: bodyLbl, with: .systemFont(ofSize: 16))
        
        bodyLbl.snp.makeConstraints { (make) in
            make.left.equalTo(titleLbl.snp.left)
            make.right.equalTo(titleLbl.snp.right)
            make.top.equalTo(titleLbl.snp.bottom).offset(8)
        }
    }
    
    @objc func didButtonClick(_ sender: UIButton) {
        if let post = post, let postSaver = postSaver {
            postSaver.switchSaveState(for: post)
        }
    }
    
    private func setUpLabel(label: UILabel, with font: UIFont) {
        label.numberOfLines = 0
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
    }
    
    private func setUpSaveButton(){
        saveButton.backgroundColor = .clear
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.adjustsImageWhenHighlighted = false
        saveButton.contentHorizontalAlignment = .left
        saveButton.setTitle("Сохранить", for: .normal)
        
        saveButton.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
        
        contentView.addSubview(saveButton)
        
        if let saveImage = UIImage(named: "save") {
            saveButton.setImage(saveImage.withRenderingMode(.alwaysTemplate), for: .normal)
            saveButton.imageView?.tintColor = .deepGreen
            saveButton.alignTextAndImage(spacing: 8, leftOffset: halfOfContentMargin, rightOffset: halfOfContentMargin)
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(halfOfContentMargin)
            make.top.equalTo(bodyLbl.snp.bottom).offset(8)
            make.height.equalTo(44)
        }
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        contentView.snp.remakeConstraints { (make) in
            make.width.equalTo(bounds.size.width)
        }
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
}
