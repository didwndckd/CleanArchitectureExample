//
//  SearchUserRepositoryStub.swift
//  CleanArchitectureExampleTests
//
//  Created by yjc on 2023/07/27.
//

import Foundation
import Combine

@testable import CleanArchitectureExample

struct SearchUserRepositoryStub: SearchUserRepository {
    func fetchGitHubUserList(query: String, page: Int, perPage: Int) -> AnyPublisher<GitHubUserList, APIError> {
        let users = (0...(perPage - 1)).map { index in
            return GitHubUser(id: index,
                              userName: query + "\(index)",
                              gitHubPageUrl: "https://github.com/\(query)\(index)",
                              profileImageUrl: "https://avatars.githubusercontent.com/u/56557507?v=4")
        }
        let userList = GitHubUserList(totalCount: Int.max, items: users)
        return Just(userList)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
}
