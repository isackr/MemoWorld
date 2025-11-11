//
//  MemoEntities.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 25/10/25.
//

import Foundation

struct CardCircle: Identifiable {
    var id: UUID
    var imageNameDefault: String
    var imageName: String
    var isRevealed: Bool
    var matchStatus: Bool
    
    init(id: UUID = UUID(),
         imageNameDefault: String = "badKid",
         imageName: String,
         isRevealed: Bool = false,
         matchStatus: Bool = false) {
        self.id = id
        self.imageNameDefault = imageNameDefault
        self.imageName = imageName
        self.isRevealed = isRevealed
        self.matchStatus = matchStatus
    }
    
    mutating func setImageName(_ name: String) {
        imageName = name
    }
    
    mutating func setIsRevealed(to status: Bool) {
        isRevealed = status
    }
    
    mutating func setMatchStatus(to status: Bool) {
        matchStatus = status
    }
}
