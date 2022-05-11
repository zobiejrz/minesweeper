//
//  minesweeperApp.swift
//  Shared
//
//  Created by Ben Zobrist on 8/21/21.
//

import SwiftUI

@main
struct minesweeperApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
