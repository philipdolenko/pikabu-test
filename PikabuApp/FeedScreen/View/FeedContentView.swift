//
//  FeedContentView.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 04.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit

//
//public class FeedContentView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        posts.count
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.identifier, for: indexPath) as! PostCell
//        cell.configure(with: self.posts[indexPath.row])
//        return cell
//    }
//    
//    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: frame.width , height: 100)
//    }
//    
//    weak var collectionView: UICollectionView!
//    var posts: [Post]!
//    
//    func configure(posts: [Post]) {
//        self.posts = posts
//        
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        
//        let collectionView = UICollectionView(
//            frame: .zero,
//            collectionViewLayout: layout
//        )
//        
//        addSubview(collectionView)
//        
//        collectionView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//
//        collectionView.isScrollEnabled = false
//        collectionView.backgroundColor = .white
//        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.identifier)
//        
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        
//        self.collectionView = collectionView
//    }
//}
//
//
//class PostCell: BaseCell {
//    static let identifier = "PostCell"
//    
//    let postTitleLbl = UILabel()
//    
//    func configure(with post: Post){
//        postTitleLbl.text = post.title
//    }
//    
//    override func setupViews() {
//        super.setupViews()
//        
//        addSubview(postTitleLbl)
//        
//        postTitleLbl.textAlignment = .center
//        postTitleLbl.textColor = .black
//        
//        postTitleLbl.snp.makeConstraints { (make) in
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//            make.top.equalToSuperview().offset(6)
//            make.height.equalTo(40)
//        }
//    }
//}
