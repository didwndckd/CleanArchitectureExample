//
//  AppManager.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/21.
//

import UIKit
import Combine

final class AppManager: ObservableObject {
    static let shared = AppManager()
    private init() {
        if AccountManager.shared.isLogin {
            self.rootViewType = .searchUser(SearchUserViewModel())
        }
        else {
            self.rootViewType = .login(LoginViewModel())
        }
    }
    
    @Published var rootViewType: RootViewType
}

// MARK: Interface
extension AppManager {
    func openUrl(urlString: String, completion: ((Bool) -> Void)? = nil) {
        guard let url = URL(string: urlString) else {
            completion?(false)
            return
        }
        
        openUrl(url: url, completion: completion)
    }
    
    func openUrl(url: URL, completion: ((Bool) -> Void)? = nil) {
        UIApplication.shared.open(url) { result in
            completion?(result)
        }
    }
}
