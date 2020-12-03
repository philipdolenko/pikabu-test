//
//  NetworkingService.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 03.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import Foundation


class NetworkingService {
    
    static let shared = NetworkingService()
    
    private func makeGetRequest<T>(to url: String, with completion: @escaping (T?, Error?) -> ()) where T: Decodable {
        let url = URL(string: url)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            do {
                let res = try JSONDecoder().decode(T.self, from: data)
                completion(res, nil)
            } catch let error {
                print(error)
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    func fetchAllPosts(completion: @escaping ([Post]?, Error?) -> ()){
        let url = "https://pikabu.ru/page/interview/mobile-app/test-api/feed.php"
        makeGetRequest(to: url, with: completion)
    }
    
    func fetchPost(by id: String, completion: @escaping (Post?, Error?) -> ()){
        let url = "https://pikabu.ru/page/interview/mobile-app/test-api/story.php?id=\(id)"
        makeGetRequest(to: url, with: completion)
    }
    
}
