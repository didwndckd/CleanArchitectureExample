//
//  AccountUseCase.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/25.
//

import Foundation
import Combine

enum AccountError: Error {
    case apiError(APIError)
    case invalidGitHubCodeUrl
}

protocol AccountUseCase {
    func requestGitHubLogin(url: URL) -> AnyPublisher<GitHubAccessTokenData, AccountError>
}

final class DefaultAccountUseCase {
    private let repository: AccountRepository
    init(repository: AccountRepository) {
        self.repository = repository
    }
}

// MARK: private
extension DefaultAccountUseCase {
    private func parsingGitHubCode(url: URL) -> String? {
        guard url.absoluteString.hasPrefix(Constant.URL.gitHubLoginCallbackUrl),
              let component = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let code = component.queryItems?.first(where: { $0.name == "code" })?.value,
              code.count > 0
        else {
            return nil
        }
        
        return code
    }
}

// MARK: Interface
extension DefaultAccountUseCase: AccountUseCase {
    func requestGitHubLogin(url: URL) -> AnyPublisher<GitHubAccessTokenData, AccountError> {
        guard let code = parsingGitHubCode(url: url) else {
            return Fail(error: AccountError.invalidGitHubCodeUrl)
                .eraseToAnyPublisher()
        }
        
        return repository.fetchGitHubAccessToken(code: code)
            .mapError { AccountError.apiError($0) }
            .eraseToAnyPublisher()
    }
}
