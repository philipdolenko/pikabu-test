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
        createLoadingIndicator()
        
        view.backgroundColor = .white
    }
    
    func createLoadingIndicator(){
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)
        indicator.center = view.center
        indicator.layer.backgroundColor = UIColor.black.withAlphaComponent(0.4).cgColor
        indicator.layer.cornerRadius = 5
        view.addSubview(indicator)
        
        self.indicator = indicator
        
        self.view.bringSubviewToFront(indicator)
    }
    
    func createCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(topBar.snp.bottom)
            if #available(iOS 11, *) {
                make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
                make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            } else {
                make.left.equalToSuperview()
                make.right.equalToSuperview()
            }
            make.bottom.equalToSuperview()
        }

        self.navigationCollectionView = collectionView
    }
    
    func createTopBar(){
        let topBar = TopBar()
        let bgView = UIView()
        topBar.backgroundColor = .deepGreen
        bgView.backgroundColor = .deepGreen
        
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
