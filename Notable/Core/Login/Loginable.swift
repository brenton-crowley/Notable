//
//  Loginable.swift
//  Notable
//
//  Created by Brent Crowley on 24/3/2023.
//

import Foundation

enum LoginError: Error {
    
    case invalidUsername(String = "Username does not exist")
    case invalidPassword(String = "Password does not exist")
    
}

protocol Loginable {
    
    static var validLogins: [String: String?] { get }
    
    func makeMockLoginRequest(_ username:String, andPassword password: String) throws -> (username: String, loginToken: String)
    
}

extension Loginable {
    
    static var validLogins: [String: String?] {  [
            "mike_": "20Mike",
            "test": "test2@",
            "john01": nil,
            "nikita": nil
        ]
    }
}

extension Loginable {
    
    func makeMockLoginRequest(_ username:String, andPassword password: String) throws -> (username: String, loginToken: String) {
        
        // look up user name and password
        
        guard Self.validLogins.keys.contains(username) else {
            throw LoginError.invalidUsername()
        }
        
        guard let pw = Self.validLogins[username] else {
            throw LoginError.invalidPassword("No password set")
        }
        
        guard pw == password else {
            throw LoginError.invalidPassword("Invalid Password")
        }
        
        let loginToken = UUID().uuidString
        return (username, loginToken)
    }
    
}
