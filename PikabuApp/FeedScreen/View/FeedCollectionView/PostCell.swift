//
//  PostCell.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 04.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit
import Kingfisher

class PostCell: UICollectionViewCell {
    static let identifier = "PostCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var titleLbl: UILabel!
    weak var bodyLbl: UILabel!
    weak var saveButton: UIButton!
    weak var imageTableView: UITableView!
    
    let contentMargin: CGFloat = 16
    let imageTableHeight: CGFloat = 300
    
    var post: Post? = nil
    var postSaver: PostCellDelegate? = nil
    
    func configure(with post: Post, and postSaver: PostCellDelegate){
        self.post = post
        self.postSaver = postSaver
        
        titleLbl.text = post.title
        bodyLbl.text = post.body ?? ""
        
        let buttonTitle = post.isSaved ? "Убрать из сохраненного" : "Сохранить"
        saveButton.setTitle(buttonTitle, for: .normal)
        saveButton.imageView?.tintColor = post.isSaved ? .deepGreen : .gray
        
        let shouldHaveTopOffset = post.body != nil && post.body != ""
        
        imageTableView.reloadData()
        
        bodyLbl.snp.updateConstraints { (make) in
            make.top.equalTo(imageTableView.snp.bottom).offset(shouldHaveTopOffset ? 8: 0)
        }
        
        imageTableView.snp.updateConstraints { (make) in
            let imagesCount = CGFloat(post.images?.count ?? 0)
            let contentHeight:CGFloat = imagesCount * imageTableHeight

            make.height.equalTo(contentHeight)
        }
    }
    
    @objc func didButtonClick(_ sender: UIButton) {
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
    weak var postImageView: UIImageView!
    weak var postBgImageView: UIImageView!
    weak var errorView: UIView!
    
    func configure(urlString: String) {
        if let url = URL(string: urlString) {
            postImageView.kf.setImage(with: url, completionHandler:  {
                [weak self] result in
                guard let `self` = self else { return }
                var imageFailedToLoad: Bool = false
                
                if case .failure = result {
                    imageFailedToLoad = true
                } else {
                    let processor = BlurImageProcessor(blurRadius: 18)
                    
                    self.postBgImageView.kf.setImage(with: url, options: [.processor(processor)])
                }
                
                self.postBgImageView.isHidden = imageFailedToLoad
                self.postImageView.isHidden = imageFailedToLoad
                self.errorView.isHidden = !imageFailedToLoad
            })
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
        let postBgImageView = UIImageView()
        contentView.addSubview(postBgImageView)
        postBgImageView.contentMode = .scaleAspectFill
        postBgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        postBgImageView.layer.masksToBounds = true
        postBgImageView.alpha = 0.7
        
        self.postBgImageView = postBgImageView
        let postImageView = UIImageView()
        contentView.addSubview(postImageView)
        postImageView.contentMode = .scaleAspectFit
        
        postImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.postImageView = postImageView
        
        let errorImage = UIImageView(image: #imageLiteral(resourceName: "broken_image"))
        errorImage.alpha = 0.6
        let errorTitle = UILabel()
        errorTitle.text = "Не удалось\nзагрузить изображение"
        errorTitle.numberOfLines = 2
        errorTitle.textAlignment = .center
        let errorView  = UIView()
        
        errorView.addSubview(errorImage)
        errorView.addSubview(errorTitle)
        addSubview(errorView)
        
        errorView.isHidden = true
        
        errorView.snp.makeConstraints { (make) in
            make.height.equalTo(300)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        errorImage.snp.makeConstraints { (make) in
            make.height.equalTo(100)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
        }
        errorTitle.snp.makeConstraints { (make) in
            make.top.equalTo(errorImage.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        
        self.errorView = errorView
    }
}
