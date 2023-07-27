//
//  DefaultSearchUserRepositoryTests.swift
//  CleanArchitectureExampleTests
//
//  Created by yjc on 2023/07/27.
//

import XCTest
import Combine

import Moya
@testable import CleanArchitectureExample

final class DefaultSearchUserRepositoryTests: XCTestCase {
    var sut: DefaultSearchUserRepository!
    var cancelableBag: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let provider = APIProvider<SearchUserAPI>(stubClosure: { _ in .immediate })
        sut = DefaultSearchUserRepository(provider: provider)
        cancelableBag = []
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        cancelableBag = []
    }
    
    func testDefaultSearchUserRepository_receiveUserList_fetchGitHubUserList() {
        // given
        let query = "didwndckd"
        let user = GitHubUser(id: 56557507, userName: "didwndckd", gitHubPageUrl: "https://github.com/didwndckd", profileImageUrl: "https://avatars.githubusercontent.com/u/56557507?v=4")
        let expectation = GitHubUserList(totalCount: 1, items: [user])
        
        // when
        sut.fetchGitHubUserList(query: query, page: 1, perPage: 30)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        XCTAssert(false, error.localizedDescription)
                    case .finished:
                        XCTAssert(true)
                    }
                },
                receiveValue: { userList in
                    // then
                    XCTAssertEqual(expectation.totalCount, userList.totalCount)
                    XCTAssertEqual(expectation.items.map { $0.id }, userList.items.map { $0.id })
                })
            .store(in: &cancelableBag)
    }
}
