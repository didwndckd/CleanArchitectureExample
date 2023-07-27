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
    static let defaultTestToken = GitHubAccessTokenData(accessToken: "accessToken", scope: "user", tokenType: "bearer")
    
    func fetchGitHubAccessToken(code: String) -> AnyPublisher<CleanArchitectureExample.GitHubAccessTokenData, CleanArchitectureExample.APIError> {
        
        return Just(AccountRepositoryStub.defaultTestToken)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
}
