//
//  DefaultSearchUserRepository.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/24.
//

import Foundation
import Combine

struct DefaultSearchUserRepository: SearchUserRepository {
    private let provider = APIProvider<SearchUserAPI>()
}

// MARK: Interface
extension DefaultSearchUserRepository {
    func fetchGitHubUserList(query: String, page: Int, perPage: Int) -> AnyPublisher<GitHubUserList, APIError> {
        let target = SearchUserAPI.getUsers(query: query, page: page, perPage: perPage)
        return provider.request(target, decodeType: GitHubUserList.self)
    }
}
