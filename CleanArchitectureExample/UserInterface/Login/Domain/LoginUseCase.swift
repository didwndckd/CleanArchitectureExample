//
//  LoginUseCase.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/21.
//

import Foundation

final class LoginUseCase {
    private let repository: LoginRepository
    init(repository: LoginRepository = DefaultLoginRepository()) {
        self.repository = repository
    }
}

// MARK: private
extension LoginUseCase {
}

// MARK: Interface
extension LoginUseCase {
    func parsingGitHubCode(url: URL) -> String? {
        guard let component = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let code = component.queryItems?.first(where: { $0.name == "code" })?.value,
              code.count > 0
        else {
            return nil
        }
        
        return code
    }
    
    func requestGitHubLogin(code: String) {
        
    }
}
