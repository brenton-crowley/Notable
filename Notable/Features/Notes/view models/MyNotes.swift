//
//  MyNotes.swift
//  Notable
//
//  Created by Brent Crowley on 24/3/2023.
//

import Foundation
import SwiftUI

class MyNotes: ObservableObject, Loginable {
    
    @Published var user: User?
    @Published var presentLoginScreen: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertText: String?
    
    private let storageProvider: StorageProvider
    
    /// Sort the notes based on a timestamp of creation.
    /// You could also make a fetchRequest with a predicate and sortDescriptors
    var notes: [Note]? {
        let notes = user?.notes?.allObjects as? [Note]
        
        return notes?.sorted { $0.timestamp < $1.timestamp }
    }
    
    init(storageProvider:StorageProvider = StorageProvider.preview) {
        
        self.storageProvider = storageProvider
        
        self.user = try? self.storageProvider.fetchLoggedInUser()
        
        if self.user == nil { self.presentLoginScreen = true }
    }
    
    /// User intent to log in.
    /// Displays an alert of a successful or failed log in attempt with feedback.
    func tryLoginWithUsername(_ username: String, andPassword password: String) {
        
        do {
            let (username, loginToken) = try makeMockLoginRequest(username, andPassword: password)
            
            // check to see if the user already can be fetched
            if let user = try? storageProvider.fetchUserWithUsername(username) {
                // we have a user, set the login token
                user.loginToken = loginToken
                try? storageProvider.save()
                self.user = user
            } else {
                // if no user, then we'll need to add a new user with details
                try? storageProvider.addUserWithUsername(username, andLoginToken: loginToken)
                // fetch the added user
                user = try? storageProvider.fetchUserWithUsername(username)
            }
            
            self.alertText = "Login Successful"
            
        } catch {
            
            switch error {
            case LoginError.invalidUsername(let description),
                LoginError.invalidPassword(let description):
                self.alertText = description
            default:
                self.alertText = error.localizedDescription
            }
            
        }
        
        self.showAlert = true
    }
    
    func logOut() {
        self.user?.loginToken = nil
        try? storageProvider.save()
        self.user = nil
        
        self.presentLoginScreen = true
    }
    
    /// Creates a new note in the core data store with the supplied name.
    func makeNoteWithName(_ noteName: String) {
        if let user = self.user {
            try? storageProvider.addNoteWithName(noteName, toUser: user)
            objectWillChange.send() // Tells the view that it needs to redraw itself based on a model change
        }
    }
    
    /// Deletes a note from the core data store at the specified indicies.
    func deleteNotes(fromOffsets offsets: IndexSet) {
        
        guard let notes = notes,
              notes.count > 0 else { return }
        
        offsets.forEach { index in
            let note = notes[index]
            try? storageProvider.delete(note)
        }
        
        objectWillChange.send()
    }
}
