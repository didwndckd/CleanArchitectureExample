//
//  GitHubUserList.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/24.
//

import Foundation

struct GitHubUserList: Equatable {
    let totalCount: Int
    let items: [GitHubUser]
}

extension GitHubUserList: Decodable {
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalCount = try container.decode(Int.self, forKey: .totalCount)
        self.items = try container.decode([GitHubUser].self, forKey: .items)
    }
}
