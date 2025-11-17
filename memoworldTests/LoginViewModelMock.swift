//
//  LoginViewModelMock.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 20/10/25.
//

import SwiftUI
import Combine
import SwiftData

final class LoginViewModelMock: LoginViewModelProtocol {
    var isAliasValidBool = false
    var saveUserBool = false
    var cleanModelsBool = false
    var context: ModelContext?
    var saveGameBool = false
    
    @ValidateAlias var validateAlias: String?
    @Published var user: User?
    
    func isAliasValid(alias: String?) -> Bool {
        validateAlias = alias
        return _validateAlias.isValid
    }
    
    func updateContext(_ newContext: ModelContext) {
        self.context = newContext
    }
    
    func saveUser(_ user: User) -> Bool {
        self.user = user
        saveUserBool = true
        return saveUserBool
    }
    
    func getFirstUser() -> User? {
        return User(name: "Enrique")
    }
    
    func cleanModels() {
        cleanModelsBool = true
    }
    
    func saveGame() -> Bool {
        saveGameBool = true
        return saveGameBool
    }
}
