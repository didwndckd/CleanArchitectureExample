//
//  SearchUserViewModelTests.swift
//  CleanArchitectureExampleTests
//
//  Created by yjc on 2023/07/27.
//

import XCTest
import Combine

@testable import CleanArchitectureExample

final class SearchUserViewModelTests: XCTestCase {
    var sut: SearchUserViewModel!
    var cancelableBag: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let repository = SearchUserRepositoryStub()
        let useCase = DefaultSearchUserUseCase(repository: repository)
        sut = SearchUserViewModel(useCase: useCase)
        cancelableBag = []
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        cancelableBag = []
    }
    
    func testSearchUserViewModel_deleteAccessTokenData_requestLogout() {
        // given
        let dummyToken = GitHubAccessTokenData(accessToken: "123", scope: "user", tokenType: "bearer")
        AccountManager.shared.registAccessToken(dummyToken)
        
        // when
        sut.requestLogout()
        
        // then
        XCTAssertEqual(AccountManager.shared.accessToken, nil)
        switch AppManager.shared.rootViewType {
        case .login:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }
    
    func testSearchUserViewModel_replaceUsers_requestSearchUsers() {
        // given
        sut.searchKeyword = "kmong"
        let expectationCount = 30
        
        // when
        sut.requestSearchUsers()
        
        // then
        XCTAssertEqual(sut.users.count, expectationCount)
    }
    
    func testSearchUserViewModel_addUsers_requestNextPageUsers() {
        print("test - next")
        // given
        sut.searchKeyword = "kmong"
        sut.users = []
        sut.requestSearchUsers()
        let expectationCount = 60
        
        // when
        sut.requestNextPageUsers()
        
        // then
        XCTAssertEqual(expectationCount, sut.users.count)
    }
    
    func testSearchUser_routerDestinationIsSafari_selectedUser() {
        // given
        sut.router.destination = nil
        let dummyUser = GitHubUser(id: 0, userName: "", gitHubPageUrl: "https://github.com", profileImageUrl: "")
        
        // when
        sut.selectedUser(dummyUser)
        
        // then
        switch sut.router.destination {
        case .safari(let url):
            XCTAssertEqual(url.absoluteString, dummyUser.gitHubPageUrl)
        default:
            XCTAssert(false)
        }
    }
}
