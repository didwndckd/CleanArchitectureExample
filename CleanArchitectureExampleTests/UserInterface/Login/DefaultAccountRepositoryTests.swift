//
//  DefaultAccountRepositoryTests.swift
//  CleanArchitectureExampleTests
//
//  Created by yjc on 2023/07/27.
//

import XCTest
import Combine
import Moya
@testable import CleanArchitectureExample

final class DefaultAccountRepositoryTests: XCTestCase {
    var sut: DefaultAccountRepository!
    var cancelableBag: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        let provider = APIProvider<AccountAPI>(
            endpointClosure: { target in
                return Endpoint(url: URL(target: target).absoluteString,
                                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                                method: target.method,
                                task: target.task,
                                httpHeaderFields: target.headers)
            },
            stubClosure: { _ in .immediate }
        )
        sut = DefaultAccountRepository(provider: provider)
        cancelableBag = []
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancelableBag = []
    }
    
    func testDefaultAccountRepository_receiveGitHubAccessTokenData_fetchGitHubAccessToken() {
        // given
        let expectationToken = GitHubAccessTokenData(accessToken: "123", scope: "user", tokenType: "bearer")
        
        // when
        sut.fetchGitHubAccessToken(code: "123")
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        XCTAssert(false, error.localizedDescription)
                    case.finished:
                        break
                    }
                },
                receiveValue: { token in
                    // then
                    XCTAssertEqual(expectationToken, token)
                })
            .store(in: &cancelableBag)
    }
}
