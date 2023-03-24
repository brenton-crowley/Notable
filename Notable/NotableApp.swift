//
//  NotableApp.swift
//  Notable
//
//  Created by Brent Crowley on 24/3/2023.
//

import SwiftUI

@main
struct NotableApp: App {
    
    var body: some Scene {
        WindowGroup {
            NotesView()
                .environmentObject(MyNotes(storageProvider: StorageProvider()))
        }
    }
}
