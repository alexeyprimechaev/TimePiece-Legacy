//
//  TimePieceApp.swift
//  Shared
//
//  Created by Alexey Primechaev on 8/25/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

@main
struct TimePieceApp: App {
    let persistenceController = PersistenceController.shared
    var settings = Settings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(settings)
        }
    }
}
