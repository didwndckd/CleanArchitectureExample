//
//  LoginManager.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/21.
//

import Foundation
import Combine

final class LoginManager {
    static let shared = LoginManager()
    private init() {}
    
    @KeyChainStorage(key: "accessToken", defaultValue: nil)
    var accessToken: GitHubAccessTokenData?
}

// MARK: Interface
extension LoginManager {
    var isLogin: Bool {
        return accessToken != nil
    }
}
