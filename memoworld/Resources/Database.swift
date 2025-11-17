//
//  LoginEntities.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 20/10/25.
//
import SwiftData
import Foundation
import SwiftUI

@Model
final class GamesPlayed {
    @Attribute(.unique) var id: UUID
    var pointsEarned: Int
    var status: Bool        // ganada / perdida
    var date: Date
    
    // RELACIÓN HACIA USER
    var user: User?
    
    // RELACIÓN HACIA GAME
    var game: Game?
    
    init(id: UUID = UUID(),
         pointsEarned: Int,
         status: Bool,
         date: Date = Date(),
         user: User? = nil,
         game: Game? = nil) {
        
        self.id = id
        self.pointsEarned = pointsEarned
        self.status = status
        self.date = date
        self.user = user
        self.game = game
    }
}

@Model
final class User {
    @Attribute(.unique) var id: UUID
    var name: String
    var email: String?
    var status: Bool
    
    // RELACIÓN: Un usuario puede tener muchas partidas jugadas
    @Relationship(deleteRule: .cascade, inverse: \GamesPlayed.user)
    var gamesPlayed: [GamesPlayed]
    
    init(id: UUID = UUID(),
         name: String,
         email: String? = nil,
         status: Bool = true) {
        self.id = id
        self.name = name
        self.email = email
        self.status = status
        self.gamesPlayed = []
    }
}
@Model
final class Game {
    @Attribute(.unique) var id: UUID
    var name: String
    var pointsToBeEarned: Int
    var pointsToBeLost: Int
    
    // RELACIÓN: Un juego puede tener muchas partidas jugadas
    @Relationship(deleteRule: .cascade, inverse: \GamesPlayed.game)
    var gamesPlayed: [GamesPlayed]
    
    init(id: UUID = UUID(),
         name: String,
         pointsToBeEarned: Int = 5,
         pointsToBeLost: Int = 0) {
        self.id = id
        self.name = name
        self.pointsToBeEarned = pointsToBeEarned
        self.pointsToBeLost = pointsToBeLost
        self.gamesPlayed = []
    }
}
