//
//  FeedViewModel.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 03.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import Foundation

protocol PostSaveStateDelegate {
    func switchSaveState(for post: Post)
}

protocol PostCellDelegate: PostSaveStateDelegate {
    func tappedOnPost(with id: Int)
}

public class FeedViewModel: PostCellDelegate {
    
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
    
    init(localStorageService: LocalStorageService, networkingService: NetworkingService) {
        self.localStorageService = localStorageService
        self.networkingService = networkingService
    }
    
    let localStorageService: LocalStorageService
    let networkingService: NetworkingService
    
    let posts: Observable<[Post]> = Observable([])
    let savedPosts: Observable<[Post]> = Observable([])
    let isLoading: Observable<Bool> = Observable(false)
    
    func getPosts(for section: SectionType) -> [Post] {
        switch section {
        case .feed:
            return posts.value
        case .savedFeed:
            return savedPosts.value
        }
    }
    
    func viewDidLoad() {
        savedPosts.value = localStorageService.getAllSavedPosts()
        
        isLoading.value = true
        networkingService.fetchAllPosts { [weak self] (fetchedPosts, err) in
            guard let `self` = self else { return }
            
            self.isLoading.value = false
            
            if let fetchedPosts = fetchedPosts {
                self.processPostsFromServer(fetchedPosts)
            }
        }
    }
    
    private func processPostsFromServer(_ fetchedPosts: [PostDTO]){
        var posts = fetchedPosts.map({$0.map()})

        for i in 0..<posts.count {
            posts[i].isSaved = self.savedPosts.value.contains(where: {$0.id ==  posts[i].id})
        }
        
        self.posts.value = posts
    }
    
    func getSaveStatus(for post: Post) -> Bool {
        let index = savedPosts.value.first(where: {$0.id == post.id})
        
        return index != nil
    }
    
    func tappedOnPost(with id: Int) {
        print("tappedOnPost \(id)")
        isLoading.value = !isLoading.value
    }
    
    func switchSaveState(for post: Post) {
        var updatedPost = post
        updatedPost.isSaved = !post.isSaved
        
        if let index = savedPosts.value.firstIndex(where: {$0.id == updatedPost.id}) {
            savedPosts.value[index] = updatedPost
        } else {
            savedPosts.value.append(updatedPost)
        }
        
        localStorageService.savePosts(posts: savedPosts.value.filter({$0.isSaved}))
        
        if let index = posts.value.firstIndex(where: {$0.id == updatedPost.id}) {
            posts.value[index] = updatedPost
        }
    }
    
}
