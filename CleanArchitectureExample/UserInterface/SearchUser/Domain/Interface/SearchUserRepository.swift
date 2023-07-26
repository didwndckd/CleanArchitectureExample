//
//  SearchUserRepository.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/26.
//

import Foundation
import Combine

protocol SearchUserRepository {
    func fetchGitHubUserList(query: String, page: Int, perPage: Int) -> AnyPublisher<GitHubUserList, APIError>
}
