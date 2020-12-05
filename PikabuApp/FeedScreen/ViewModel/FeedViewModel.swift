//
//  FeedViewModel.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 03.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import Foundation


public class FeedViewModel: PostSaveStateHandler {
    
    enum SectionType: Int, CaseIterable {
        case feed
        case savedFeed
        
        var title: String {
            switch self {
            case .feed:
                return "Лента"
            case .savedFeed:
                return "Сохраненные"
            }
        }
    }
    
    func getPosts(for section: SectionType) -> [Post] {
        switch section {
        case .feed:
            return posts.value
        case .savedFeed:
            return savedPosts.value
        }
    }
    
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
                
                self.processPostsFromServer(fetchedPosts)
            }
        }
    }
    
    private func processPostsFromServer(_ fetchedPosts: [PostDTO]){
        var posts = [Post]()
        
        for postDTO in fetchedPosts {
            let isSaved = self.savedPosts.value.contains(where: {$0.id == postDTO.id})
            
            posts.append(postDTO.map(isSaved: isSaved))
        }
        
        self.posts.value = posts
    }
}
