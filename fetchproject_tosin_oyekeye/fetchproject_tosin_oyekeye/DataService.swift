//
//  DataService.swift
//  fetchproject_tosin_oyekeye
//
//  Created by Oluwatosin Oyekeye on 10/7/23.
//

import Foundation

class DataService {
    static let shared = DataService()
    private init() {}
    
    func fetchItems(completion: @escaping ([Item]?) -> Void) {
        guard let url = URL(string: "https://fetch-hiring.s3.amazonaws.com/hiring.json") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else {
                completion(nil)
                return
            }
            
            let items = try? JSONDecoder().decode([Item].self, from: data)
            completion(items)
        }.resume()
    }
}

