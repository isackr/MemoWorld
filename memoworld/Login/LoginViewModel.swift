//
//  LoginViewModel.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 19/10/25.
//

import SwiftUI
import Combine
import SwiftData

protocol LoginViewModelProtocol: ObservableObject {
    func isAliasValid(alias: String?) -> Bool
    func updateContext(_ newContext: ModelContext)
    func saveUser(_ user: User) -> Bool
    func getFirstUser(_ context: ModelContext) -> User?
    func cleanModels()
}

@MainActor
final class LoginViewModel: LoginViewModelProtocol {
    var context: ModelContext?
    @ValidateAlias var validateAlias: String?
    
    init(){}
    
    func isAliasValid(alias: String?) -> Bool {
        validateAlias = alias
        return _validateAlias.isValid
    }
    
    func updateContext(_ newContext: ModelContext) {
        self.context = newContext
    }
    
    func saveUser(_ user: User) -> Bool {
        let newUser = User(name: user.name)
        guard let context = context else { return false }
        context.insert(newUser)
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
     
    func getFirstUser(_ context: ModelContext) -> User? {
        let descriptor = FetchDescriptor<User>(
            sortBy: [SortDescriptor(\.name)]
        )
        
        do {
            let results = try context.fetch(descriptor)
            print("el valor de regreso es: ", results.first?.name as Any)
            return results.last
        } catch {
            print("Error fetching first user: \(error)")
            return nil
        }
    }
    
    func deleteAllUsers() {
        guard let context = context else { return }
        let fetchDescriptor = FetchDescriptor<User>()
        if let users = try? context.fetch(fetchDescriptor) {
            for user in users {
                context.delete(user)
            }
            try? context.save()
        }
    }
    
    func deleteAllGames() {
        guard let context = context else { return }
        let fetchDescriptor = FetchDescriptor<Game>()
        if let games = try? context.fetch(fetchDescriptor) {
            for game in games {
                context.delete(game)
            }
            try? context.save()
        }
    }
    
    func cleanModels() {
        deleteAllGames()
        deleteAllUsers()
    }
}
