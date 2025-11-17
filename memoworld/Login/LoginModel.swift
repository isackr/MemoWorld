//
//  LoginModel.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 15/11/25.
//

import SwiftData
import Foundation

protocol LoginModelProtocol: AnyObject {
    func cleanDB()
    func saveUser(_ user: User) -> Bool
    func getFirstUser() -> User?
    func updateContext(_ newContext: ModelContext)
    func saveGame() -> Bool
}

final class LoginModel: LoginModelProtocol {
    func saveUser(_ user: User) -> Bool {
        return DBManager.shared.saveUser(user)
    }
    
    func saveGame() -> Bool {
        let game = Game(name: "memorama")
        return DBManager.shared.saveGame(game)
    }
    
    func getFirstUser() -> User? {
        return DBManager.shared.getFirstUser()
    }

    func updateContext(_ newContext: ModelContext) {
        DBManager.shared.updateContext(newContext)
    }
    
    func cleanDB() {
        DBManager.shared.deleteAllGames()
        DBManager.shared.deleteAllUsers()
        DBManager.shared.deleteAllGamesPlayed()
    }
}

@propertyWrapper
struct ValidateAlias {
    private var name: String? = nil
    private var minLength: Int = 3
    private var maxLength: Int = 15
    private var valid: Bool = false
    
    var isValid: Bool { valid }
    var projectedValue: Bool { valid }
    
    var wrappedValue: String? {
        get { name }
        set {
            guard let value = newValue else {
                valid = false
                name = nil
                return
            }
            
            if value.count < minLength {
                valid = false
                name = value
            } else if value.count > maxLength {
                valid = false
                name = String(value.prefix(maxLength))
            } else {
                valid = true
                name = value
            }
        }
    }
    
    init(wrappedValue: String?) {
        self.wrappedValue = wrappedValue
    }
}
