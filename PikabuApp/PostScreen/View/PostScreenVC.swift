//
//  PostScreenVC.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 07.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit


class PostScreen: UIViewController {
    
    var viewModel: PostScreenViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        subscribeToViewModelChanges()
    }
    
    private func subscribeToViewModelChanges(){
        viewModel.post.observe { (post) in
            
        }
    }
    
    private func updateView(with: Post){
        
    }
}
