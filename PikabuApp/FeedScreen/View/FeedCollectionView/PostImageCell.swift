//
//  PostImageCell.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 07.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit
import Kingfisher

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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
