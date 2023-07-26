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
    func fetchGitHubAccessToken(code: String) -> AnyPublisher<CleanArchitectureExample.GitHubAccessTokenData, CleanArchitectureExample.APIError> {
        let token = GitHubAccessTokenData(accessToken: "accessToken", scope: "user", tokenType: "bearer")
        return Just(token)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
}
