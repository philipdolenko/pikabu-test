//
//  FeedCell.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 03.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit
import SnapKit


public class FeedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    static let identifier = "FeedCell"
    
    weak var collectionView: UICollectionView!
    var posts: [Post] = []
    var postSaver: PostSaveStateHandler? = nil
    
    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.y = newValue }
        get { return collectionView.contentOffset.y }
    }
    
    func configure(with posts: [Post], postSaver: PostSaveStateHandler, scrollOffset: CGFloat) {
        self.posts = posts
        self.postSaver = postSaver
        
        self.collectionView.reloadData()
        self.setScrollOffset(scrollOffset)
        self.adoptLayoutIfNeeded()
    }
    
    func setScrollOffset(_ scrollOffset: CGFloat){
        self.layoutIfNeeded()
        
        let contentHeight = collectionView.contentSize.height
        let visibleHeight = collectionView.bounds.height + collectionView.contentInset.bottom
        
        let isScrollable = contentHeight >= visibleHeight
        
        collectionViewOffset = isScrollable ? scrollOffset : 0
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
    
    override func setupViews() {
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
}

