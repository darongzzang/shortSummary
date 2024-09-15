//
//  shortsSummaryApp.swift
//  shortsSummary
//
//  Created by 김이예은 on 9/10/24.
//

import SwiftUI
import SwiftData

@main
struct shortsSummaryApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ScriptView()
        }
        .modelContainer(sharedModelContainer)
    }
}
