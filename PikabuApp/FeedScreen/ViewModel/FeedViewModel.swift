//
//  FeedViewModel.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 03.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import Foundation


public class FeedViewModel {
    
    let posts: Observable<[Post]> = Observable([])
    let savedPosts: Observable<[Post]> = Observable([])
    
    func getSaveStatus(for post: Post) -> Bool {
        let index = savedPosts.value.first(where: {$0.id == post.id})
        
        return index != nil
    }
    
    func tuggleSaveState(for post: Post) {
        let oldSavedStatus = post.isSaved ?? getSaveStatus(for: post)
        
        if oldSavedStatus {
            savedPosts.value.removeAll(where: {$0.id == post.id})
        } else {
            savedPosts.value.append(post)
        }
        
        LocalStorageService.shared.savePosts(posts: savedPosts.value)
        
        let index = posts.value.firstIndex(where: {$0.id == post.id})
        
        if let index = index {
            posts.value[index].isSaved = !oldSavedStatus
        }
    }
    
    func selectPostAt() {
        
    }
    
    func viewDidLoad() {
        savedPosts.value = LocalStorageService.shared.getAllSavedPosts()
        
        NetworkingService.shared.fetchAllPosts { [weak self] (fetchedPosts, err) in
            if var posts = fetchedPosts {
                guard let `self` = self else { return }
                
                for i in 0..<posts.count {
                    posts[i].isSaved = self.savedPosts.value.contains(where: {$0.id == posts[i].id})
                }
                
                self.posts.value = posts
            }
        }
    }
    
}
