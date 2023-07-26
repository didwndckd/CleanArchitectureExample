//
//  AccountRepository.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/26.
//

import Foundation
import Combine

protocol AccountRepository {
    func fetchGitHubAccessToken(code: String) -> AnyPublisher<GitHubAccessTokenData, APIError>
}
