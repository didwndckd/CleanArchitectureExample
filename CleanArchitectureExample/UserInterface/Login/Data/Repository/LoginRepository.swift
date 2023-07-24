//
//  LoginRepository.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/21.
//

import Foundation
import Combine

protocol LoginRepository {
    func fetchGitHubAccessToken(code: String) -> AnyPublisher<GitHubAccessTokenData, APIError>
}

struct DefaultLoginRepository: LoginRepository {
    private let provider = APIProvider<LoginAPI>()
    
    func fetchGitHubAccessToken(code: String) -> AnyPublisher<GitHubAccessTokenData, APIError> {
        let target = LoginAPI.postGitHubAccessToken(code: code)
        return provider.request(target, decodeType: GitHubAccessTokenData.self)
    }
}
