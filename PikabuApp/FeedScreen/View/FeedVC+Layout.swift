//
//  FeedVC+Layout.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 02.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit
import SnapKit


extension FeedVC {
    func setUpView(){
        createTopBar()
        createCollectionView()
    }
    
    func createCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(topBar.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        self.collectionView = collectionView
    }
    
    func createTopBar(){
        let topBar = TopBar()
        let bgView = UIView()
        topBar.backgroundColor = #colorLiteral(red: 0.4918432832, green: 0.6988996863, blue: 0.2623156905, alpha: 1)
        bgView.backgroundColor = #colorLiteral(red: 0.4918432832, green: 0.6988996863, blue: 0.2623156905, alpha: 1)
        
        view.addSubview(topBar)
        view.addSubview(bgView)
        
        topBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            make.height.equalTo(60)
        }
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(topBar.snp.top)
        }
        
        self.topBar = topBar
    }
}
