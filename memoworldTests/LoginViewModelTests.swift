//
//  memoworldTests.swift
//  memoworldTests
//
//  Created by Isaac Rosas Camarillo on 16/10/25.
//

import XCTest
import SwiftData
@testable import memoworld

final class LoginViewModelTests: XCTestCase {
    var container: ModelContainer!
    var context: ModelContext!
    var viewModel: LoginViewModelMock!
    
    @MainActor
    override func setUpWithError() throws {
        try super.setUpWithError()
        let schema = Schema([User.self, Game.self])
        container = try! ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        context = ModelContext(container)
        viewModel = LoginViewModelMock()
        viewModel.updateContext(context)
    }

    override func tearDownWithError() throws {
        container = nil
        context = nil
        try super.tearDownWithError()
    }

    func test_isAliasValid_whenAliasIsTooShort_returnsFalse() {
        let result = viewModel.isAliasValid(alias: "ab")
        XCTAssertFalse(result)
    }
    
    func test_isAliasValid_whenAliasIsValid_returnsTrue() {
        let result = viewModel.isAliasValid(alias: "IsaacR")
        XCTAssertTrue(result)
    }
    
    @MainActor
    func test_updateContext_assignsNewContext() {
        let newContainer = try! ModelContainer(for: User.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let newContext = ModelContext(newContainer)
        
        viewModel.updateContext(newContext)
        
        XCTAssertTrue(viewModel.context === newContext)
    }
    
    @MainActor
    func test_saveUser_insertsUserSuccessfully() {
        let user = User(name: "Enrique")
        let success = viewModel.saveUser(user)
        XCTAssertTrue(success)
        XCTAssertEqual(user.name, viewModel.user?.name)
    }

    func test_getFirstUser_returnsFirstInsertedUser() {
        let first = viewModel.getFirstUser(context)
        XCTAssertEqual(first?.name, "Enrique") 
    }
}
