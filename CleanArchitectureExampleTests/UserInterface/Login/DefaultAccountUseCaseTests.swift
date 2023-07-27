//
//  DefaultAccountUseCaseTests.swift
//  CleanArchitectureExampleTests
//
//  Created by yjc on 2023/07/26.
//

import XCTest
import Combine

@testable import CleanArchitectureExample

final class DefaultAccountUseCaseTests: XCTestCase {
    var sut: DefaultAccountUseCase!
    var cancelableBag: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        let repositoryStub = AccountRepositoryStub()
        sut = DefaultAccountUseCase(repository: repositoryStub)
        cancelableBag = []
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancelableBag = []
    }
    
    func testDefaultAccountUseCase_receiveInvalidGitHubCodeUrlError_requestGitHubLoginWithWrongScheme() {
        // given
        let url = URL(string: "abc://login?code=123")!
        
        // when
        sut.requestGitHubLogin(url: url)
            .sink(
                receiveCompletion: { completion in
                    // then
                    switch completion {
                    case .failure(let error):
                        if case AccountError.invalidGitHubCodeUrl = error {
                            XCTAssert(true)
                        }
                        else {
                            XCTAssert(false)
                        }
                    case .finished:
                        XCTAssert(false)
                    }
                },
                receiveValue: { value in
                    XCTAssert(false)
                })
            .store(in: &cancelableBag)
    }
    
    func testDefaultAccountUseCase_receiveInvalidGitHubCodeUrlError_requestGitHubLoginWithWrongHost() {
        // given
        let url = URL(string: "\(Constant.Scheme.appScheme)://test?code=123")!
        
        // when
        sut.requestGitHubLogin(url: url)
            .sink(
                receiveCompletion: { completion in
                    // then
                    switch completion {
                    case .failure(let error):
                        if case AccountError.invalidGitHubCodeUrl = error {
                            XCTAssert(true)
                        }
                        else {
                            XCTAssert(false)
                        }
                    case .finished:
                        XCTAssert(false)
                    }
                },
                receiveValue: { value in
                    XCTAssert(false)
                })
            .store(in: &cancelableBag)
    }
    
    func testDefaultAccountUseCase_receiveInvalidGitHubCodeUrlError_requestGitHubLoginWithEmptyCode() {
        // given
        let url = URL(string: "\(Constant.Scheme.appScheme)://login?code=")!
        
        // when
        sut.requestGitHubLogin(url: url)
            .sink(
                receiveCompletion: { completion in
                    // then
                    switch completion {
                    case .failure(let error):
                        if case AccountError.invalidGitHubCodeUrl = error {
                            XCTAssert(true)
                        }
                        else {
                            XCTAssert(false)
                        }
                    case .finished:
                        XCTAssert(false)
                    }
                },
                receiveValue: { value in
                    XCTAssert(false)
                })
            .store(in: &cancelableBag)
    }
    
    func testDefaultAccountUseCase_receiveAccessTokenData_requestHitHubLogin() {
        // given
        let url = URL(string: "\(Constant.URL.gitHubLoginCallbackUrl)?code=123")!
        let expectation = AccountRepositoryStub.defaultTestToken
        
        // when
        sut.requestGitHubLogin(url: url)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        XCTAssert(false, "\(error)")
                    case .finished:
                        break
                    }
                },
                receiveValue: { token in
                    // then
                    XCTAssertEqual(expectation, token)
                })
            .store(in: &cancelableBag)
    }
}
