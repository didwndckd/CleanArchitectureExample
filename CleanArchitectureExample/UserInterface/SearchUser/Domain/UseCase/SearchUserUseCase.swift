//
//  SearchUserUseCase.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/24.
//

import Foundation
import Combine

final class SearchUserUseCase {
    private let repository: SearchUserRepository
    private let numberOfUsersInPage: Int
    init(repository: SearchUserRepository = DefaultSearchUserRepository(), numberOfUsersInPage: Int = 30) {
        self.repository = repository
        self.numberOfUsersInPage = numberOfUsersInPage
    }
}

// MARK: Interface
extension SearchUserUseCase {
    func requestLogout() -> Bool {
        LoginManager.shared.removeAccessToken()
        return !LoginManager.shared.isLogin
    }
    
    func requestSearchUsers(keyword: String, page: Int, perPage: Int) -> some Publisher<GitHubUserList, APIError> {
        return repository.fetchGitHubUserList(query: keyword, page: page, perPage: perPage)
    }
    
    func requestSearchUsers(keyword: String, latestUsers: [GitHubUser]) -> some Publisher<GitHubUserList, APIError> {
        let currentPage = latestUsers.count / numberOfUsersInPage
        print("request page: \(currentPage + 1)")
        return repository.fetchGitHubUserList(query: keyword, page: currentPage + 1, perPage: numberOfUsersInPage)
            .map { userList in
                return GitHubUserList(totalCount: userList.totalCount, items: latestUsers + userList.items)
            }
    }
}
