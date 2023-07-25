//
//  AccountManager.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/21.
//

import Foundation
import Combine

final class AccountManager {
    static let shared = AccountManager()
    private init() {}
    
    private let lock = NSLock()
    @KeyChainStorage(key: "accessToken", defaultValue: nil)
    private(set) var accessToken: GitHubAccessTokenData?
}

// MARK: Interface
extension AccountManager {
    var isLogin: Bool {
        return accessToken != nil
    }
    
    func registAccessToken(_ token: GitHubAccessTokenData) {
        lock.lock()
        accessToken = token
        lock.unlock()
    }
    
    func removeAccessToken() {
        lock.lock()
        accessToken = nil
        lock.unlock()
    }
}
