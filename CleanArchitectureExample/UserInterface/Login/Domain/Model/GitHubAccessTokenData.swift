//
//  GitHubAccessTokenData.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/21.
//

import Foundation

struct GitHubAccessTokenData: Equatable {
    let accessToken: String
    let scope: String
    let tokenType: String
}

extension GitHubAccessTokenData: Codable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope = "scope"
        case tokenType = "token_type"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.scope = try container.decode(String.self, forKey: .scope)
        self.tokenType = try container.decode(String.self, forKey: .tokenType)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.accessToken, forKey: .accessToken)
        try container.encode(self.scope, forKey: .scope)
        try container.encode(self.tokenType, forKey: .tokenType)
    }
}

