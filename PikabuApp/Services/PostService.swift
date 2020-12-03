//
//  PostService.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 03.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import Foundation

class PostService {
    
    static let shared = PostService()
    
    func fetchPosts(completion: @escaping ([Post]) -> ()){
        completion([
            Post(id: "11", title: "11 title", images: [], body: "1 Text Text Text Text Text Text", isSaved: false),
            Post(id: "22", title: "22 title", images: [], body: "2 Text Text Text Text Text Text", isSaved: false),
            Post(id: "1", title: "1 title", images: [], body: "1 Text Text Text Text Text Text", isSaved: true),
            Post(id: "2", title: "2 title", images: [], body: "2 Text Text Text Text Text Text", isSaved: true),
            Post(id: "3", title: "3 title", images: [], body: "3 Text Text Text Text Text Text", isSaved: true),
            Post(id: "33", title: "33 title", images: [], body: "3 Text Text Text Text Text Text", isSaved: false),
            Post(id: "44", title: "44 title", images: [], body: "4 Text Text Text Text Text Text", isSaved: false),
            Post(id: "4", title: "4 title", images: [], body: "4 Text Text Text Text Text Text", isSaved: true)
        ])
    }
    
    func fetchSavedPosts() -> [Post] {
        [
            Post(id: "1", title: "1 title", images: [], body: "1 Text Text Text Text Text Text", isSaved: true),
            Post(id: "2", title: "2 title", images: [], body: "2 Text Text Text Text Text Text", isSaved: true),
            Post(id: "3", title: "3 title", images: [], body: "3 Text Text Text Text Text Text", isSaved: true),
            Post(id: "4", title: "4 title", images: [], body: "4 Text Text Text Text Text Text", isSaved: true)
        ]
    }
}
