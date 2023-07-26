//
//  SearchUserUseCase.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/24.
//

import Foundation
import Combine

protocol SearchUserUseCase {
    func requestSearchUsers(searchKeyword: String, page: Int, numberOfItemsInPage: Int) -> AnyPublisher<GitHubUserList, APIError>
}

final class DefaultSearchUserUseCase: SearchUserUseCase {
    private let repository: SearchUserRepository
    
    init(repository: SearchUserRepository) {
        self.repository = repository
    }
}

// MARK: Interface
extension DefaultSearchUserUseCase {
    func requestSearchUsers(searchKeyword: String, page: Int, numberOfItemsInPage: Int) -> AnyPublisher<GitHubUserList, APIError> {
        return repository.fetchGitHubUserList(query: searchKeyword, page: page, perPage: numberOfItemsInPage)
    }
}
