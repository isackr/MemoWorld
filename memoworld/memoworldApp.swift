//
//  memoworldApp.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 16/10/25.
//

import SwiftUI
import SwiftData

@available(iOS 17, *)
@main
struct memoworldApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [User.self, Game.self])
    }
}
