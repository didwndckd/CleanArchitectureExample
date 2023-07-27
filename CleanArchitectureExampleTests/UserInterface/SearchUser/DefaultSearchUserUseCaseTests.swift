//
//  DefaultSearchUserUseCaseTests.swift
//  CleanArchitectureExampleTests
//
//  Created by yjc on 2023/07/27.
//

import XCTest
import Combine

import Moya
@testable import CleanArchitectureExample

final class DefaultSearchUserUseCaseTests: XCTestCase {
    var sut: DefaultSearchUserUseCase!
    var cancelableBag: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let repository = SearchUserRepositoryStub()
        sut = DefaultSearchUserUseCase(repository: repository)
        cancelableBag = []
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        cancelableBag = []
    }
    
    func testDefaultSearchUserUseCase_receiveGitHubUserList_requestSearchUsers() {
        // given
        let keyword = "kmong"
        let numberOfItemsInPage = 30
        
        // when
        sut.requestSearchUsers(searchKeyword: keyword, page: 1, numberOfItemsInPage: numberOfItemsInPage)
            .sink(
                receiveCompletion: { compleiton in
                    switch compleiton {
                    case .failure(let error):
                        XCTAssert(false, error.localizedDescription)
                    case .finished:
                        XCTAssert(true)
                    }
                }, receiveValue: { userList in
                    // then
                    XCTAssertEqual(userList.items.count, numberOfItemsInPage)
                }
            )
            .store(in: &cancelableBag)
    }
    
}
