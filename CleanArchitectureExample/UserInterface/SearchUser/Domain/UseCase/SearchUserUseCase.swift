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

final class DetaultSearchUserUseCase: SearchUserUseCase {
    private let repository: SearchUserRepository
    private let numberOfUsersInPage: Int
    
    init(repository: SearchUserRepository = DefaultSearchUserRepository(), numberOfUsersInPage: Int = 30) {
        self.repository = repository
        self.numberOfUsersInPage = numberOfUsersInPage
    }
}

// MARK: Interface
extension DetaultSearchUserUseCase {
    func requestSearchUsers(searchKeyword: String, page: Int, numberOfItemsInPage: Int) -> AnyPublisher<GitHubUserList, APIError> {
        return repository.fetchGitHubUserList(query: searchKeyword, page: page, perPage: numberOfItemsInPage)
    }
}
