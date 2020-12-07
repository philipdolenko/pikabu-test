//
//  FeedViewModel.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 03.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit

protocol PostSaveStateDelegate {
    func switchSaveState(for post: Post)
}

protocol PostCellDelegate: PostSaveStateDelegate {
    func tappedOnPost(with id: Int)
}

public class FeedViewModel: PostCellDelegate {
    
    init(localStorageService: LocalStorageService, networkingService: NetworkingService) {
        self.localStorageService = localStorageService
        self.networkingService = networkingService
    }
    
    let localStorageService: LocalStorageService
    let networkingService: NetworkingService
    
    let posts: Observable<[Post]> = Observable([])
    let savedPosts: Observable<[Post]> = Observable([])
    let postToDisplay: Observable<PostScreenViewModel?> = Observable(nil)
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
        fetchPosts()
    }
    
    private func fetchPosts(){
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
            posts[i].isSaved = getSaveStatus(for: posts[i])
        }
        
        self.posts.value = posts
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
    
    func tappedOnPost(with id: Int) {
        isLoading.value = true
        
        networkingService.fetchPost(by: id) {[weak self] (postDTO, err) in
            guard let `self` = self else { return }
            
            self.isLoading.value = false
            
            if let postDTO = postDTO {
                var post = postDTO.map()
                post.isSaved = self.getSaveStatus(for: post)
                
                let viewModel = PostScreenViewModel.init(postSaveStateDelegate: self, post: post)
                self.postToDisplay.value = viewModel
            }
        }
    }
    
    func getSaveStatus(for post: Post) -> Bool {
        self.savedPosts.value.contains(where: {($0.id ==  post.id) && $0.isSaved})
    }
}

extension FeedViewModel {
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

        var emptyContentMessege: String {
            switch self {
            case .feed:
                if InternetConnectionManager.isConnectedToNetwork() {
                    return ""
                } else {
                    return "Ошибка соединения."
                }
            case .savedFeed:
                return "Нет сохраненных постов."
            }
        }
        
        var emptyContentImg: UIImage? {
            switch self {
            case .feed:
                if InternetConnectionManager.isConnectedToNetwork() {
                    return nil
                } else {
                    return #imageLiteral(resourceName: "cloud_off")
                }
            case .savedFeed:
                return #imageLiteral(resourceName: "save_alt")
            }
        }
    }
}
