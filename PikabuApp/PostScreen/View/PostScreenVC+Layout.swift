//
//  PostScreen+Layout.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 07.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit
import SnapKit

extension PostScreenVC {
    
    func setUpView(){
        view.backgroundColor = .white
        setUpNavBar()
        setUpScrollView()
        setUpTitleLbl()
        setUpImageTableView()
        setUpBodyLbl()
        setUpSaveButton()
    }
    
    private func setUpNavBar(){
        let backButton = UIBarButtonItem(
            title: "Назад",
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        backButton.tintColor = .deepGreen
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setUpScrollView(){
        let scrollView = UIScrollView()
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalToSuperview()
        }
        
        self.scrollView = scrollView
    }
    
    private func setUpTitleLbl(){
        let titleLbl = UILabel()
        titleLbl.setUpLabel(with: .systemFont(ofSize: 24, weight: .bold), parent: scrollView)
        
        titleLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(contentMargin)
            make.right.equalToSuperview().offset(-contentMargin)
            make.top.equalTo(scrollView.snp.top).offset(16)
        }
        
        self.titleLbl = titleLbl
    }
    
    private func setUpImageTableView(){
        let imageTableView = FullContentTableView()
        scrollView.addSubview(imageTableView)
        imageTableView.register(PostImageCell.self, forCellReuseIdentifier: PostImageCell.identifier)
        imageTableView.delegate = self
        imageTableView.dataSource = self
        imageTableView.isScrollEnabled = false
        imageTableView.separatorStyle = .none
        imageTableView.allowsSelection = false
        imageTableView.rowHeight = 300;
        var width = UIScreen.main.bounds.size.width
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
                   
        width -= window?.safeAreaInsets.left ?? 0
        width -= window?.safeAreaInsets.right ?? 0
        
        imageTableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLbl.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(contentMargin)
            make.right.equalToSuperview().offset(-contentMargin)
            make.width.equalTo(width - contentMargin * 2)
        }
        
        self.imageTableView = imageTableView
    }
    
    private func setUpBodyLbl(){
        let bodyLbl = UILabel()
        bodyLbl.setUpLabel(with: .systemFont(ofSize: 16), parent: scrollView)
        
        bodyLbl.snp.makeConstraints { (make) in
            make.left.equalTo(titleLbl.snp.left)
            make.right.equalTo(titleLbl.snp.right)
            make.top.equalTo(imageTableView.snp.bottom).offset(8)
        }
        
        self.bodyLbl = bodyLbl
    }
    
    private func setUpSaveButton(){
        let halfOfContentMargin = contentMargin / 2
        let saveButton = SaveButton(isSaved: false, offset: halfOfContentMargin)
        saveButton.addTarget(self, action: #selector(didSaveButtonClick), for: .touchUpInside)
        scrollView.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(halfOfContentMargin)
            make.right.equalToSuperview().offset(halfOfContentMargin)
            make.top.equalTo(bodyLbl.snp.bottom).offset(8)
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
        self.saveButton = saveButton
    }
    
}
