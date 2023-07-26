//
//  AccountUseCaseTests.swift
//  CleanArchitectureExampleTests
//
//  Created by yjc on 2023/07/26.
//

import XCTest

@testable import CleanArchitectureExample

final class AccountUseCaseTests: XCTestCase {
    var sut: DefaultAccountUseCase!
    
    override func setUp() {
        super.setUp()
        let repositoryStub = AccountRepositoryStub()
        sut = DefaultAccountUseCase(repository: repositoryStub)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
}
