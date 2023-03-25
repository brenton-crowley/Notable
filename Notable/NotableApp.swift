//
//  NotableApp.swift
//  Notable
//
//  Created by Brent Crowley on 24/3/2023.
//

import SwiftUI

@main
struct NotableApp: App {
    
    var storageProvider: StorageProvider {
        
        let arguments = ProcessInfo.processInfo.arguments
            for argument in arguments {
                switch argument {
                case "UI_TEST_ENV_LOGGED_IN_USER":
                    print("Testing: \(argument)")
                    return StorageProvider.previewWithLoggedInUser
                case "UI_TEST_ENV_FOUR_NOTES":
                    print("Testing: \(argument)")
                    return StorageProvider.previewWithNotes
                case "UI_TEST_ENV_EMPTY":
                    print("Testing: \(argument)")
                    return StorageProvider.preview
                default:
                    continue
                }
            }
        print("Load App's Main Storage")
        return StorageProvider()
    }
    
    var body: some Scene {
        WindowGroup {
            NotesView()
                .environmentObject(MyNotes(storageProvider: storageProvider))
        }
    }
}

extension NotableApp {
    
    static var UI_TEST_ENV_LOGGED_IN_USER:String { "UI_TEST_ENV_LOGGED_IN_USER" }
    static var UI_TEST_ENV_FOUR_NOTES: String { "UI_TEST_ENV_FOUR_NOTES" }
    static var UI_TEST_ENV_EMPTY: String { "UI_TEST_ENV_EMPTY" }
    
}
