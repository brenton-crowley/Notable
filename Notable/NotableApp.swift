//
//  NotableApp.swift
//  Notable
//
//  Created by Brent Crowley on 24/3/2023.
//

import SwiftUI

@main
struct NotableApp: App {
//    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
