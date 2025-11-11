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
final class User {
    @Attribute(.unique) var id: UUID
    var name: String
    var email: String?
    var status: Bool
    
    // Relación uno a muchos con Game
    @Relationship(deleteRule: .cascade, inverse: \Game.user)
    var games: [Game]
    
    init(id: UUID = UUID(), name: String, email: String? = nil, status: Bool = true, games: [Game] = []) {
        self.id = id
        self.name = name
        self.email = email
        self.status = status
        self.games = games
    }
}

@Model
final class Game {
    @Attribute(.unique) var id: UUID
    var name: String
    var points: Int
    
    // Relación inversa: muchos juegos pertenecen a un usuario
    var user: User?
    
    init(id: UUID = UUID(), name: String, points: Int = 0, user: User? = nil) {
        self.id = id
        self.name = name
        self.points = points
        self.user = user
    }
}

@propertyWrapper
struct ValidateAlias {
    private var name: String? = nil
    private var minLength: Int = 3
    private var maxLength: Int = 20
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
