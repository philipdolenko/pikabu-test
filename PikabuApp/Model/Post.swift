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
    var isSaved: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case id, title, images, body, isSaved
    }
    
    init(
        id: Int,
        title: String,
        images: [String]?,
        body: String?,
        isSaved: Bool? = nil
    ) {
        self.id = id
        self.title = title
        self.images = images
        self.body = body
        self.isSaved = isSaved
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        images = try? container.decode([String].self, forKey: .images)
        body = try? container.decode(String.self, forKey: .body)
        isSaved = try? container.decode(Bool.self, forKey: .body)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        
        if let images = images {
            try container.encode(images, forKey: .images)
        }
        
        if let body = body {
            try container.encode(body, forKey: .body)
        }
        
        if let isSaved = isSaved {
            try container.encode(isSaved, forKey: .isSaved)
        }
    }
}
