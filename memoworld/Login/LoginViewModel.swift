//
//  LoginViewModel.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 19/10/25.
//

import Combine
import SwiftData

protocol LoginViewModelProtocol: ObservableObject {
    func isAliasValid(alias: String?) async -> Bool
    func cleanModels() async
    func saveUser(_ user: User) -> Bool
    func getFirstUser() -> User?
    func updateContext(_ newContext: ModelContext)
    func saveGame() -> Bool
}


final class LoginViewModel: LoginViewModelProtocol {
    @ValidateAlias var validateAlias: String?
    private var loginModel: LoginModelProtocol?
    
    init(loginModel: LoginModelProtocol) {
        self.loginModel = loginModel
    }
    
    func updateContext(_ newContext: ModelContext) {
        loginModel?.updateContext(newContext)
    }
    
    func saveUser(_ user: User) -> Bool {
        return loginModel?.saveUser(user) ?? false
    }
    
    func getFirstUser() -> User? {
        return loginModel?.getFirstUser()
    }
    
    func saveGame() -> Bool {
        return loginModel?.saveGame() ?? false
    }
    
    func isAliasValid(alias: String?) -> Bool {
        validateAlias = alias
        return _validateAlias.isValid
    }
    
    func cleanModels() {
       loginModel?.cleanDB()
    }
}
