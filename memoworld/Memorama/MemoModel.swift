//
//  MemoModel.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 16/11/25.
//

import SwiftData

protocol MemoModelProtocol: AnyObject {
    func getFirstUser() -> User?
    func updateContext(_ context: ModelContext)
    func saveGamePlayed(isWinner: Bool)
}

final class MemoModel: MemoModelProtocol {
    func getFirstUser() -> User? {
        return DBManager.shared.getFirstUser()
    }
    
    func updateContext(_ context: ModelContext) {
        DBManager.shared.updateContext(context)
    }
    
    func saveGamePlayed(isWinner: Bool) {
        let user = DBManager.shared.getFirstUser()
        let game = DBManager.shared.getFirstGame()
        let played = GamesPlayed(pointsEarned: isWinner ? 5 : 0, status: isWinner)
        _ = DBManager.shared.saveGamePlayed(played)
    }    
}
