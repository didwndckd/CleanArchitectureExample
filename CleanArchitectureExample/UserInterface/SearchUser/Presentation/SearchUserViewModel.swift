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
    private let perPage = 30
    private var totalCount = 0
    
    @Published var searchKeyword = ""
    @Published var users: [GitHubUser] = []
    @Published var isSearchLoading = false
    @Published var isNextPageLoading = false
    
    init(useCase: SearchUserUseCase = SearchUserUseCase()) {
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
        guard useCase.requestLogout() else { return }
        let viewModel = LoginViewModel()
        AppManager.shared.rootViewType = .login(viewModel)
    }
    
    func requestSearchUsers() {
        guard searchKeyword.count > 0 else {
            users = []
            searchUserRequest = nil
            return
        }
//        searchUserRequest = useCase.requestSearchUsers(keyword: keyword, page: 1, perPage: perPage)
        searchUserRequest = useCase.requestSearchUsers(keyword: searchKeyword, latestUsers: [])
            .trackLoading(searchLoadingTracker)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        switch error {
                        case .decodeFailure(origin: let origin, data: let data):
                            print("decodeFailure origin error: \(origin), origin data: \(String(data: data, encoding: .utf8) ?? "")")
                        default:
                            print(error)
                        }
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
        
//        let currentPage = users.count / perPage
//        searchUserRequest = useCase.requestSearchUsers(keyword: searchKeyword, page: currentPage + 1, perPage: perPage)
        searchUserRequest = useCase.requestSearchUsers(keyword: searchKeyword, latestUsers: users)
            .trackLoading(nextPageLoadingTracker)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        switch error {
                        case .decodeFailure(origin: let origin, data: let data):
                            print("decodeFailure origin error: \(origin), origin data: \(String(data: data, encoding: .utf8) ?? "")")
                        default:
                            print(error)
                        }
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] userList in
                    self?.totalCount = userList.totalCount
                    self?.users = userList.items
//                    self?.users += userList.items
                })
    }
}
