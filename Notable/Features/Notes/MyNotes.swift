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
    
    init(storageProvider:StorageProvider = StorageProvider.preview) {
        
        self.storageProvider = storageProvider
        
        self.user = try? self.storageProvider.fetchLoggedInUser()
        
        if self.user == nil { self.presentLoginScreen = true }
    }
    
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
    
}
