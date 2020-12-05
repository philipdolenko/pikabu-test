//
//  FeedViewModel.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 03.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import Foundation


public class FeedViewModel: PostSaveStateHandler {
    
    struct Section {
        let type: SectionType
        let posts: () -> [Post]
        let postSaver: PostSaveStateHandler
    }
    
    enum SectionType: String {
        case feed = "Лента"
        case savedFeed = "Сохраненные"
    }
    
    lazy var sections: [Section] = {
        [
            .init(
                type: .feed,
                posts: { [unowned self] in
                    self.posts.value
                },
                postSaver: self
            ),
            .init(
                type: .savedFeed,
                posts: { [unowned self] in
                    self.savedPosts.value
                },
                postSaver: self
            )
        ]
    }()
    
    init(localStorageService: LocalStorageService, networkingService: NetworkingService) {
        self.localStorageService = localStorageService
        self.networkingService = networkingService
    }
    
    let localStorageService: LocalStorageService
    let networkingService: NetworkingService
    
    let posts: Observable<[Post]> = Observable([])
    let savedPosts: Observable<[Post]> = Observable([])
    
    func getSaveStatus(for post: Post) -> Bool {
        let index = savedPosts.value.first(where: {$0.id == post.id})
        
        return index != nil
    }
    
    func switchSaveState(for post: Post) {
        let oldIsSavedState = post.isSaved
        
        var updatedPost = post
        updatedPost.isSaved = !oldIsSavedState
        
        if oldIsSavedState {
            savedPosts.value.removeAll(where: {$0.id == updatedPost.id})
        } else {
            savedPosts.value.append(updatedPost)
        }
        
        localStorageService.savePosts(posts: savedPosts.value)
        
        let index = posts.value.firstIndex(where: {$0.id == updatedPost.id})
        
        if let index = index {
            posts.value[index] = updatedPost
        }
    }
    
    func viewDidLoad() {
        savedPosts.value = localStorageService.getAllSavedPosts()
        
        networkingService.fetchAllPosts { [weak self] (fetchedPosts, err) in
            if let fetchedPosts = fetchedPosts {
                guard let `self` = self else { return }
                
                var posts = [Post]()
                
                for postDTO in fetchedPosts {
                    let isSaved = self.savedPosts.value.contains(where: {$0.id == postDTO.id})
                    
                    posts.append(postDTO.map(isSaved: isSaved))
                }
                
                self.posts.value = posts
            }
        }
    }
}
