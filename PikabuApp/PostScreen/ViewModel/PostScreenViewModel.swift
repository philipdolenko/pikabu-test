//
//  PostScreenViewModel.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 07.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import Foundation

class PostScreenViewModel {
    
    let postSaveStateDelegate: PostSaveStateDelegate
    var post: Observable<Post>
    
    init(postSaveStateDelegate: PostSaveStateDelegate, post: Post) {
        self.postSaveStateDelegate = postSaveStateDelegate
        self.post = Observable(post)
    }
    
    func viewDidLoad(){
        post.notifyObservers()
    }
    
    func switchPostSaveState(){
        postSaveStateDelegate.switchSaveState(for: post.value)
        post.value.isSaved = !post.value.isSaved
    }
}
