//
//  FeedCell.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 03.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit
import SnapKit


public class FeedCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    static let identifier = "FeedCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    weak var collectionView: UICollectionView!
    weak var messageLbl: UILabel!
    weak var messageImg: UIImageView!
    var posts: [Post] = []
    var postSaver: PostCellDelegate? = nil
    
    var collectionViewOffset: CGPoint {
        set { collectionView.contentOffset = newValue }
        get { return collectionView.contentOffset }
    }
    
    public override func layoutIfNeeded() { 
        guard window != nil else {
            return
        }

        super.layoutIfNeeded()
    }
    
    func configure(with posts: [Post], postSaver: PostCellDelegate, scrollOffset: CGPoint, _ sectionType: FeedViewModel.SectionType) {
        self.posts = posts
        self.postSaver = postSaver
        
        self.collectionView.reloadData()
        self.setScrollOffset(scrollOffset)
        self.adoptLayoutIfNeeded()
        
        configureEmptyContentMsg(sectionType)
    }
    
    func configureEmptyContentMsg(_ sectionType: FeedViewModel.SectionType){
        messageLbl.isHidden = !posts.isEmpty
        messageImg.isHidden = !posts.isEmpty
        
        if let image = sectionType.emptyContentImg {
            messageImg.image = image.withRenderingMode(.alwaysTemplate)
        } else {
            messageImg.isHidden = true
        }
        messageLbl.text = sectionType.emptyContentMessege
        messageImg.tintColor = .deepGreen
    }
    
    func setScrollOffset(_ scrollOffset: CGPoint){
        self.layoutIfNeeded()
        
        let contentHeight = collectionView.contentSize.height
        let visibleHeight = collectionView.bounds.height + collectionView.contentInset.bottom
        
        let isScrollable = contentHeight >= visibleHeight
        
        collectionViewOffset = isScrollable ? scrollOffset : .init(x: 0, y: 0)
    }
    
    func adoptLayoutIfNeeded(){
        if let layout  = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            var width = UIScreen.main.bounds.size.width
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            
            width -= window?.safeAreaInsets.left ?? 0
            width -= window?.safeAreaInsets.right ?? 0
            
            if layout.estimatedItemSize.width != width {
                layout.estimatedItemSize.width = width
            }
        }
    }
    
    func setUpView() {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.estimatedItemSize = CGSize(width: width, height: 10)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        collectionView.backgroundColor = .white
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView = collectionView
        
        let messageLbl = UILabel()
        contentView.addSubview(messageLbl)
        messageLbl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.messageLbl = messageLbl
        
        let messageImg = UIImageView()
        messageImg.alpha = 0.8
        contentView.addSubview(messageImg)
        messageImg.contentMode = .scaleAspectFit
        messageImg.snp.makeConstraints { (make) in
            make.centerX.equalTo(messageLbl)
            make.width.equalTo(75)
            make.height.equalTo(75)
            make.bottom.equalTo(messageLbl.snp.top).offset(-16)
        }
        self.messageImg = messageImg
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.identifier, for: indexPath) as! PostCell
        if let postSaver = postSaver {
            cell.configure(with: self.posts[indexPath.row], and: postSaver)
        }
        return cell
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

