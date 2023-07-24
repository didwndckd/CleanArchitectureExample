//
//  LoginUseCase.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/21.
//

import Foundation
import Combine

enum LoginError: Error {
    case apiError(APIError)
    case invalidGitHubCode
}

final class LoginUseCase {
    private let repository: LoginRepository
    init(repository: LoginRepository = DefaultLoginRepository()) {
        self.repository = repository
    }
}

// MARK: private
extension LoginUseCase {
    private func parsingGitHubCode(url: URL) -> String? {
        guard let component = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let code = component.queryItems?.first(where: { $0.name == "code" })?.value,
              code.count > 0
        else {
            return nil
        }
        
        return code
    }
}

// MARK: Interface
extension LoginUseCase {
    func requestGitHubLogin(url: URL) -> some Publisher<Bool, LoginError> {
        guard let code = parsingGitHubCode(url: url) else {
            return Fail(error: LoginError.invalidGitHubCode)
                .eraseToAnyPublisher()
        }
        
        return repository.fetchGitHubAccessToken(code: code)
            .handleEvents(receiveOutput: { token in
                LoginManager.shared.registAccessToken(token)
            })
            .map { _ in LoginManager.shared.accessToken != nil }
            .mapError { LoginError.apiError($0) }
            .eraseToAnyPublisher()
    }
}
