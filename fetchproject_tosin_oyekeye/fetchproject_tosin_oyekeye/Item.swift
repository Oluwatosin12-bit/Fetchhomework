//
//  Item.swift
//  fetchproject_tosin_oyekeye
//
//  Created by Oluwatosin Oyekeye on 10/7/23.
//

import Foundation
struct Item: Codable, Comparable {
    let id: Int
    let listId: Int
    let name: String?
    
    static func < (lhs: Item, rhs: Item) -> Bool {
        if lhs.listId == rhs.listId {
            return lhs.name ?? "" < rhs.name ?? ""
        }
        return lhs.listId < rhs.listId
    }
}
