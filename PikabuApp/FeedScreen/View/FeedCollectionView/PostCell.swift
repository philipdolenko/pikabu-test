//
//  PostCell.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 04.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    static let identifier = "PostCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    weak var titleLbl: UILabel!
    weak var bodyLbl: UILabel!
    weak var saveButton: SaveButton!
    weak var imageTableView: UITableView!
    
    let contentMargin: CGFloat = 16
    let imgTableRowHeight: CGFloat = 300
    
    var post: Post? = nil
    var postSaver: PostCellDelegate? = nil
    
    func configure(with post: Post, and postSaver: PostCellDelegate){
        self.post = post
        self.postSaver = postSaver
        
        titleLbl.text = post.title
        bodyLbl.text = post.body ?? ""
        
        saveButton.setState(post.isSaved ? .saved : .unsaved)
        
        let shouldHaveTopOffset = post.body != nil && post.body != ""
        
        imageTableView.reloadData()
        
        bodyLbl.snp.updateConstraints { (make) in
            make.top.equalTo(imageTableView.snp.bottom).offset(shouldHaveTopOffset ? 8: 0)
        }
        
        imageTableView.snp.updateConstraints { (make) in
            let imagesCount = CGFloat(post.images?.count ?? 0)
            let contentHeight:CGFloat = imagesCount * imgTableRowHeight

            make.height.equalTo(contentHeight)
        }
    }
    
    @objc func didSaveButtonClick(_ sender: UIButton) {
        if let post = post, let postSaver = postSaver {
            postSaver.switchSaveState(for: post)
        }
    }
    
    @objc
    func didTitleClick(sender:UITapGestureRecognizer) {
        if let post = post, let postSaver = postSaver {
            postSaver.tappedOnPost(with: post.id)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        post?.images?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostImageCell.identifier, for: indexPath) as? PostImageCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        if let images = post?.images {
            cell.configure(urlString: images[indexPath.row])
        }
        
        return cell
    }
}

