//
//  PostCell.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 04.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit
import Kingfisher


protocol PostSaveStateHandler {
    func switchSaveState(for post: Post)
}

class PostCell: BaseCell {
    static let identifier = "PostCell"
    
    let titleLbl =  UILabel()
    let bodyLbl = UILabel()
    let saveButton = UIButton()
    let imageTableView = UITableView()
    let contentMargin: CGFloat = 16
    let imageTableHeight: CGFloat = 300
    
    var post: Post? = nil
    var postSaver: PostSaveStateHandler? = nil
    
    func configure(with post: Post, and postSaver: PostSaveStateHandler){
        self.post = post
        self.postSaver = postSaver
        
        titleLbl.text = post.title
        bodyLbl.text = post.body ?? ""
        
        let buttonTitle = post.isSaved ? "Убрать из сохраненного" : "Сохранить"
        saveButton.setTitle(buttonTitle, for: .normal)
        saveButton.imageView?.tintColor = post.isSaved ? .deepGreen : .gray
        
        let shouldHaveTopOffset = post.body != nil && post.body != ""
        bodyLbl.snp.updateConstraints { (make) in
            make.top.equalTo(imageTableView.snp.bottom).offset(shouldHaveTopOffset ? 8: 0)
        }
        imageTableView.reloadData()
        let hideImages = post.images?.isEmpty ?? true
        imageTableView.isHidden = hideImages
        imageTableView.snp.updateConstraints { (make) in
            make.top.equalTo(titleLbl.snp.bottom).offset(hideImages ? 0: 8)
            let y: CGFloat = CGFloat((post.images?.count ?? 1))
            let x:CGFloat = imageTableHeight * y
            make.height.equalTo(hideImages ? 0 : x)
        }
    }
    
    override func setupViews() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        setUpTitleLbl()
        setUpImageTableView()
        setUpBodyLbl()
        setUpSaveButton()
        
        if let lastSubview = contentView.subviews.last {
            contentView.bottomAnchor.constraint(equalTo: lastSubview.bottomAnchor, constant: 4).isActive = true
        }
    }
    
    @objc func didButtonClick(_ sender: UIButton) {
        if let post = post, let postSaver = postSaver {
            postSaver.switchSaveState(for: post)
        }
    }
}

extension PostCell {
    private func setUpTitleLbl(){
        setUpLabel(label: titleLbl, with: .systemFont(ofSize: 24, weight: .bold))
        
        titleLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(contentMargin)
            make.right.equalToSuperview().offset(-contentMargin)
            make.top.equalToSuperview().offset(12)
        }
    }
    
    private func setUpBodyLbl(){
        setUpLabel(label: bodyLbl, with: .systemFont(ofSize: 16))
        
        bodyLbl.snp.makeConstraints { (make) in
            make.left.equalTo(titleLbl.snp.left)
            make.right.equalTo(titleLbl.snp.right)
            make.top.equalTo(imageTableView.snp.bottom).offset(8)
        }
    }
    
    private func setUpLabel(label: UILabel, with font: UIFont) {
        label.numberOfLines = 0
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
    }
    
    private func setUpImageTableView(){
        contentView.addSubview(imageTableView)
        imageTableView.isScrollEnabled = false
        imageTableView.register(PostImageCell.self, forCellReuseIdentifier: PostImageCell.identifier)
        imageTableView.rowHeight = imageTableHeight
        imageTableView.delegate = self
        imageTableView.dataSource = self
        imageTableView.backgroundColor = .red
        imageTableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLbl.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(contentMargin)
            make.right.equalToSuperview().offset(-contentMargin)
            make.height.equalTo(imageTableHeight)
        }
    }
    
    private func setUpSaveButton(){
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
    }
        
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        contentView.snp.remakeConstraints { (make) in
            make.width.equalTo(bounds.size.width)
        }
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
}


extension PostCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        post?.images?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostImageCell.identifier, for: indexPath) as? PostImageCell else { return UITableViewCell() }
        
        if let images = post?.images {
            cell.configure(urlString: images[indexPath.row])
        }
        
        return cell
    }
}


class PostImageCell: UITableViewCell {
    static let identifier = "PostImageCell"
    let postImageView: UIImageView = UIImageView()
    
    func configure(urlString: String) {
        if let url = URL(string: urlString) {
            postImageView.kf.setImage(with: url)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(postImageView)
        
        postImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
