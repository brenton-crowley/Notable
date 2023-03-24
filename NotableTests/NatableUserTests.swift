//
//  NatableUserTests.swift
//  NotableTests
//
//  Created by Brent Crowley on 24/3/2023.
//

import XCTest
@testable import Notable

final class NatableUserTests: XCTestCase {

    var sut: StorageProvider!
    
    let username = "mike_"
    let loginToken = "0000-1111-2222-3333"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = StorageProvider.preview
    }

    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }

    func testFetchNilUserInStorageProvider() throws {
        
        let user = try sut.fetchUserWithUsername(username)
        
        XCTAssertNil(user)
    }
    
    /// This test also fetches a user from the data base given a username so I will not
    func testAddUserToStorageProvider() throws {
        
        // given a user name and login token
        var user = try sut.fetchUserWithUsername(username)
        XCTAssertNil(user)
        
        // create a user
        // save that user to core data
        XCTAssertNoThrow(
            try sut.addUserWithUsername(username, andLoginToken: loginToken)
        )
        
        // fetch the user
        user = try sut.fetchUserWithUsername(username)
        XCTAssertNotNil(user)
        
    }
    
    func testFetchLoggedInUserFromStorageProvider() throws {
        
        let notLoggedInUsername = "some_user"
        // create users
        
        // add logged in user
        XCTAssertNoThrow(
            try sut.addUserWithUsername(username, andLoginToken: loginToken)
        )
        
        // add non logged in user
        XCTAssertNoThrow(
            try sut.addUserWithUsername(notLoggedInUsername)
        )
        
        // fetch the user
        let loggedInUser = try sut.fetchLoggedInUser()
        XCTAssertEqual(loggedInUser?.username, username)
        XCTAssertNotEqual(loggedInUser?.username, notLoggedInUsername)
        
    }
    
    // Test for a logged in user.
    // If no logged in user, then present the login screen.
    func testNoLoggedInUser() throws {
        
        // fetch the user
        let loggedInUser = try sut.fetchLoggedInUser()
        XCTAssertNil(loggedInUser)
        
    }
    
    func testCannotAddDuplicateUser() throws {
        
        // attempt to add the same username twice
        XCTAssertNoThrow(
            try sut.addUserWithUsername(username, andLoginToken: loginToken)
        )
        XCTAssertThrowsError(
            try sut.addUserWithUsername(username, andLoginToken: loginToken)
        )
    }
    
    func testDeleteUserFromStorageProvider() throws {
        
        // given a user name and login token
        var user = try sut.fetchUserWithUsername(username)
        XCTAssertNil(user)
        
        // create a user
        // save that user to core data
        XCTAssertNoThrow(
            try sut.addUserWithUsername(username, andLoginToken: loginToken)
        )
        
        // fetch the user
        user = try sut.fetchUserWithUsername(username)
        XCTAssertNotNil(user)
        
        // delete the user
        XCTAssertNoThrow( try sut.delete(user!) )
        
        // Test that the username no longer exists
        user = try sut.fetchUserWithUsername(username)
        XCTAssertNil(user)
    }

}
