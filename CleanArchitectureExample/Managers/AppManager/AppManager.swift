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
    
    @Published var rootViewType: RootViewType
    
    private init() {
        if AccountManager.shared.isLogin {
            let repository = DefaultSearchUserRepository()
            let useCase = DefaultSearchUserUseCase(repository: repository)
            let viewModel = SearchUserViewModel(useCase: useCase)
            self.rootViewType = .searchUser(viewModel)
        }
        else {
            let repository = DefaultAccountRepository()
            let useCase = DefaultAccountUseCase(repository: repository)
            let viewModel = LoginViewModel(useCase: useCase)
            self.rootViewType = .login(viewModel)
        }
    }
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
