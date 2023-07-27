//
//  DefaultAccountRepository.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/21.
//

import Foundation
import Combine

struct DefaultAccountRepository: AccountRepository {
    private let provider: APIProvider<AccountAPI>
    
    init(provider: APIProvider<AccountAPI> = APIProvider<AccountAPI>()) {
        self.provider = provider
    }
}

// MARK: Interface
extension DefaultAccountRepository {
    func fetchGitHubAccessToken(code: String) -> AnyPublisher<GitHubAccessTokenData, APIError> {
        let target = AccountAPI.postGitHubAccessToken(code: code)
        return provider.request(target, decodeType: GitHubAccessTokenData.self)
    }
}
