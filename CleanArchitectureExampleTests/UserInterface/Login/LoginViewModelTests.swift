//
//  LoginViewModelTests.swift
//  CleanArchitectureExampleTests
//
//  Created by yjc on 2023/07/27.
//

import XCTest
import Combine

@testable import CleanArchitectureExample

final class LoginViewModelTests: XCTestCase {
    var sut: LoginViewModel!
    var cancelableBag: Set<AnyCancellable> = []
    override func setUp() {
        super.setUp()
        let repository = AccountRepositoryStub()
        let useCase = DefaultAccountUseCase(repository: repository)
        sut = LoginViewModel(useCase: useCase)
        cancelableBag = []
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancelableBag = []
    }
    
    func testLoginViewModel_setAccessTokenAndReplaceRootViewType_receiveUrl() {
        // given
        let url = URL(string: "\(Constant.URL.gitHubLoginCallbackUrl)?code=123")!
        let expectationToken = AccountRepositoryStub.defaultTestToken
        
        // when
        sut.receiveUrl(url: url)
        
        // then
        XCTAssertEqual(AccountManager.shared.accessToken, expectationToken)
        switch AppManager.shared.rootViewType {
        case .searchUser:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }
}
