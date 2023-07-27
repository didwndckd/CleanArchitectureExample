//
//  SearchUserViewModel.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/24.
//

import Foundation
import Combine

final class SearchUserViewModel: ObservableObject {
    private var cancelBag: Set<AnyCancellable> = []
    private var searchUserRequest: AnyCancellable?
    
    private let useCase: SearchUserUseCase
    
    private let searchLoadingTracker = LoadingTracker()
    private let nextPageLoadingTracker = LoadingTracker()
    private let numberOfItemsInPage = 30
    private var totalCount = 0
    
    @Published var router = DefaultRouter<SearchUserRouterDestination>()
    @Published var searchKeyword = ""
    @Published var users: [GitHubUser] = []
    @Published var isSearchLoading = false
    @Published var isNextPageLoading = false
    
    init(useCase: SearchUserUseCase) {
        self.useCase = useCase
        bind()
    }
}

// MARK: private
extension SearchUserViewModel {
    private func bind() {
        searchLoadingTracker
            .sink(receiveValue: { [weak self] isLoading in
                self?.isSearchLoading = isLoading
            })
            .store(in: &cancelBag)
        
        nextPageLoadingTracker
            .sink(receiveValue: { [weak self] isLoading in
                self?.isNextPageLoading = isLoading
            })
            .store(in: &cancelBag)
    }
    
    private var canRequestNextPage: Bool {
        return users.count < totalCount
    }
}

// MARK: Interface
extension SearchUserViewModel {
    func requestLogout() {
        AccountManager.shared.removeAccessToken()
        let repository = DefaultAccountRepository()
        let useCase = DefaultAccountUseCase(repository: repository)
        let viewModel = LoginViewModel(useCase: useCase)
        AppManager.shared.rootViewType = .login(viewModel)
    }
    
    func requestSearchUsers() {
        guard searchKeyword.count > 0 else {
            searchUserRequest = nil
            users = []
            return
        }
        searchUserRequest = useCase.requestSearchUsers(searchKeyword: searchKeyword, page: 1, numberOfItemsInPage: numberOfItemsInPage)
            .trackLoading(searchLoadingTracker)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] userList in
                    self?.totalCount = userList.totalCount
                    self?.users = userList.items
                })
    }
    
    func requestNextPageUsers() {
        guard !searchLoadingTracker.value && !nextPageLoadingTracker.value && canRequestNextPage else { return }
        
        let currentPage = users.count / numberOfItemsInPage
        searchUserRequest = useCase.requestSearchUsers(searchKeyword: searchKeyword, page: currentPage + 1, numberOfItemsInPage: numberOfItemsInPage)
            .trackLoading(nextPageLoadingTracker)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] userList in
                    self?.totalCount = userList.totalCount
                    self?.users += userList.items
                })
    }
    
    func selectedUser(_ user: GitHubUser) {
        guard let url = URL(string: user.gitHubPageUrl) else { return }
        router.destination = .safari(url)
    }
}
