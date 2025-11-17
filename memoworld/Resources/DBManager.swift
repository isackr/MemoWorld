//
//  ManageDB.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 15/11/25.
//

import SwiftData
import Foundation

protocol DBManagerProtocol: AnyObject {
    func updateContext(_ newContext: ModelContext)
    func saveUser(_ user: User) async -> Bool
    func getFirstUser() async -> User?
    func saveGamePlayed(_ gamePlayed: GamesPlayed) -> Bool
    func deleteAllUsers()
    func deleteAllGames()
}

final class DBManager: DBManagerProtocol {
    static let shared = DBManager()
    
    var context: ModelContext?
    
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
    
    func saveGame(_ game: Game) -> Bool {
        let newUser = Game(name: game.name)
        guard let context = context else { return false }
        context.insert(newUser)
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func saveGamePlayed(_ gamePlayed: GamesPlayed) -> Bool {
        let newUser = GamesPlayed(pointsEarned: gamePlayed.pointsEarned, status: gamePlayed.status)
        guard let context = context else { return false }
        context.insert(newUser)
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func getFirstUser() -> User? {
        let descriptor = FetchDescriptor<User>(
            sortBy: [SortDescriptor(\.name)]
        )
        
        do {
            let results = try context?.fetch(descriptor)
            return results?.first
        } catch {
            print("Error fetching user:", error)
            return nil
        }
    }
    
    func getFirstGame() -> Game? {
        let descriptor = FetchDescriptor<Game>(
            sortBy: [SortDescriptor(\.name)]
        )
        
        do {
            let results = try context?.fetch(descriptor)
            return results?.first
        } catch {
            print("Error fetching user:", error)
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
    
    func deleteAllGamesPlayed() {
        guard let context = context else { return }
        let fetchDescriptor = FetchDescriptor<GamesPlayed>()
        if let games = try? context.fetch(fetchDescriptor) {
            for game in games {
                context.delete(game)
            }
            try? context.save()
        }
    }
}
