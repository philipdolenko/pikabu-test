//
//  LocalStorageService.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 03.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import Foundation

class LocalStorageService {
    
    static let shared = LocalStorageService()
    
    let defaults = UserDefaults.standard
    
    private let savedPostsKey = "savedPostsKey"
    
    func savePosts(posts: [Post]){
        var postsToSave = posts
        
        for i in 0..<posts.count {
            postsToSave[i].isSaved = true
        }
        
        if let data = try? JSONEncoder().encode(postsToSave) {
            defaults.set(data, forKey: savedPostsKey)
            
        }
    }
    
    func getAllSavedPosts() -> [Post] {
        if let data = defaults.value(forKey: savedPostsKey) as? Data,
            let posts = try? JSONDecoder().decode([Post].self, from: data) {
            return posts
        }
        
        return []
    }
}
