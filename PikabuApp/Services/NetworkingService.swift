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
                
                DispatchQueue.main.async {
                    completion(res, nil)
                }
            } catch let error {
                print(error)
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    func fetchAllPosts(completion: @escaping ([Post]?, Error?) -> ()){
        completion([
            Post(id: 11, title: "Проблема рыбы-меч", images: nil, body: "1 Text Text Text Text Text Text Text Text Text Text Text Text", isSaved: false),
            Post(id: 22, title: "А что если...", images: nil, body: "... у Древних Египтян была развитая письменность как наша, но они стали так зависимы от мемов, что стали просто использовать картинки для общения?", isSaved: false),
            Post(id: 1, title: "Как я сходил на почту", images: ["https://cs8.pikabu.ru/post_img/2017/07/09/11/1499623910130079808.jpg"], body: "Почта России в Кудрово, работает с апреля месяца с 09:00 до 18:00 что оставляет большинству рабочего населения вроде меня попасть туда только в субботу, но в единственный день забрать свои посылки, увидев очередь с улицы метров на двадцать, чувствуешь что что-то пошло не так. От безысходности набираю горячую линию почты и там отвечают \"если перед вами очередь больше пяти человек нажмите один\" заржал в голос прям на улице.", isSaved: true),
            Post(id: 2, title: "2 title", images: [], body: "2 Text Text Text Text Text TextText Text Text Text Text Text", isSaved: true),
            Post(id: 3, title: "3 title", images: nil, body: nil, isSaved: true),
            Post(id: 33, title: "33 title", images: [], body: "3 Text Text Text Text Text Text", isSaved: false),
            Post(id: 44, title: "44 title", images: [], body: "4 Text TexText Text Text Text Text Text Text Text Text Text Text TextText Text Text Text Text Text Text Text Text Text Text Textt Text Text Text Text", isSaved: false),
            Post(id: 33, title: "33 title", images: [], body: nil, isSaved: false),
            Post(id: 44, title: "44 title", images: [], body: "4 Text Text Text Text Text Text", isSaved: false),
            Post(id: 4, title: "4 title", images: [], body: "4 Text Text Text Text Text Text", isSaved: true)
        ], nil)
//        let url = "https://pikabu.ru/page/interview/mobile-app/test-api/feed.php"
//        makeGetRequest(to: url, with: completion)
    }
    
    func fetchPost(by id: String, completion: @escaping (Post?, Error?) -> ()){
//        let url = "https://pikabu.ru/page/interview/mobile-app/test-api/story.php?id=\(id)"
//        makeGetRequest(to: url, with: completion)
    }
    
}
