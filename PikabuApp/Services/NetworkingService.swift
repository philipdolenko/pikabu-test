//
//  NetworkingService.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 03.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import Foundation


class NetworkingService {
    
    private func makeGetRequest<T>(to url: String, with completion: @escaping (T?, Error?) -> ()) where T: Decodable {
        func completionFromMain(_ res: T?,_ err: Error?){
            DispatchQueue.main.async {
                completion(res, err)
            }
        }
        
        let url = URL(string: url)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                completionFromMain(nil, error)
                return
            }
            
            do {
                let res = try JSONDecoder().decode(T.self, from: data)
                
                completionFromMain(res, nil)
            } catch let error {
                completionFromMain(nil, error)
            }
        }
        
        task.resume()
    }
    
    func fetchAllPosts(completion: @escaping ([PostDTO]?, Error?) -> ()){
        let url = "https://pikabu.ru/page/interview/mobile-app/test-api/feed.php"
        makeGetRequest(to: url, with: completion)
    }
    
    func fetchPost(by id: Int, completion: @escaping (PostDTO?, Error?) -> ()){
        let url = "https://pikabu.ru/page/interview/mobile-app/test-api/story.php?id=\(id)"
        makeGetRequest(to: url, with: completion)
    }
    
}
