//
//  Model.swift
//  RxSwift_Github_ex
//
//  Created by kokojong on 2022/05/15.
//

import Foundation

struct Repositories: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [Item]?

    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
    
}

struct Item: Codable {
    var fullName: String
    var description: String?
    var stargazersCount: Int
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case description
        case stargazersCount = "stargazers_count"
    }
    
}
