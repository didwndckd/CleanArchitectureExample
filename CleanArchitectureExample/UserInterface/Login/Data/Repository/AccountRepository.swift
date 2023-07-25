//
//  LoginRepository.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/21.
//

import Foundation
import Combine

protocol AccountRepository {
    func fetchGitHubAccessToken(code: String) -> AnyPublisher<GitHubAccessTokenData, APIError>
}

struct DefaultLoginRepository: AccountRepository {
    private let provider = APIProvider<AccountAPI>()
    
    func fetchGitHubAccessToken(code: String) -> AnyPublisher<GitHubAccessTokenData, APIError> {
        let target = AccountAPI.postGitHubAccessToken(code: code)
        return provider.request(target, decodeType: GitHubAccessTokenData.self)
    }
}
