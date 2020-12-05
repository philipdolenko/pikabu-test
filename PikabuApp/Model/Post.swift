//
//  Post.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 03.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import Foundation

public struct Post: Codable {
    let id: Int
    let title: String
    let images: [String]?
    let body: String?
    var isSaved: Bool
    
    func map() -> PostDTO {
        .init(id: id, title: title, images: images, body: body)
    }
}

public struct PostDTO: Codable {
    let id: Int
    let title: String
    let images: [String]?
    let body: String?
    
    
    func map(isSaved: Bool = false) -> Post {
        .init(id: id, title: title, images: images, body: body, isSaved: isSaved)
    }
}
