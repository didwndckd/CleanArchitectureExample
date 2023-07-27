//
//  AccountRepositoryStub.swift
//  CleanArchitectureExampleTests
//
//  Created by yjc on 2023/07/26.
//

import Foundation
import Combine
@testable import CleanArchitectureExample

struct AccountRepositoryStub: AccountRepository {
    func fetchGitHubAccessToken(code: String) -> AnyPublisher<GitHubAccessTokenData, APIError> {
        
        return Just(GitHubAccessTokenData(accessToken: code, scope: "user", tokenType: "bearer"))
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
}
