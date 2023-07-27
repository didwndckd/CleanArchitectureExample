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
    private let useCase: AccountUseCase
    
    init(useCase: AccountUseCase) {
        self.useCase = useCase
    }
}

// MARK: Interface
extension LoginViewModel {
    func requestLogin() {
        let urlString = Constant.URL.gitHub + "/login/oauth/authorize?client_id=\(Constant.APIKey.gitHubClientId)&scope=user"
        AppManager.shared.openUrl(urlString: urlString) { result in
            guard result else { return }
            print("fail open url: \(urlString)")
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
                receiveValue: { token in
                    AccountManager.shared.registAccessToken(token)
                    let repository = DefaultSearchUserRepository()
                    let useCase = DefaultSearchUserUseCase(repository: repository)
                    let viewModel = SearchUserViewModel(useCase: useCase)
                    AppManager.shared.rootViewType = .searchUser(viewModel)
                })
            .store(in: &cancelBag)
    }
}
