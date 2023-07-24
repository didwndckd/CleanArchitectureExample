//
//  LoginViewModel.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/21.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    private var cancelBag: Set<AnyCancellable> = []
    private let useCase: LoginUseCase
    
    init(useCase: LoginUseCase = LoginUseCase()) {
        self.useCase = useCase
    }
}

// MARK: private
extension LoginViewModel {
}

// MARK: Interface
extension LoginViewModel {
    func requestLogin() {
        let urlString = Constant.URL.gitHub + "/login/oauth/authorize?client_id=\(Constant.APIKey.gitHubClientId)&scope=user"
        AppManager.shared.openUrl(urlString: urlString) { result in
            guard result else { return }
            
        }
    }
    
    func receiveUrl(url: URL) {
        useCase.requestGitHubLogin(url: url)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        break
                    }
                },
                receiveValue: { result in
                    guard result else { return }
                    let viewModel = SearchUserViewModel()
                    AppManager.shared.rootViewType = .searchUser(viewModel)
                })
            .store(in: &cancelBag)
    }
}
