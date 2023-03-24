//
//  NotableLoginTests.swift
//  NotableTests
//
//  Created by Brent Crowley on 24/3/2023.
//

import XCTest
@testable import Notable

final class NotableLoginableTests: XCTestCase {

    var sut: MyNotes!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = MyNotes()
    }

    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }

    func testLoginSuccess() throws {
        // given a valid username and password
        let username = "mike_"
        let password = "20Mike"
        
        // then return a user with a login token
        let result = try sut.makeMockLoginRequest(username, andPassword: password)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(username, result.username)
        
    }
    
    func testLoginUsernameFail() throws {
        // given a valid username and password
        let username = "st_johns"
        let password = "ZoPW_98"
        
        // then return a user with a login token
        XCTAssertThrowsError(try sut.makeMockLoginRequest(username, andPassword: password))
        
    }
    
    func testLoginUnmatchedPasswordFail() throws {
        // given a valid username and password
        let username = "mike_"
        let password = "ZoPW_98"
        
        // then return a user with a login token
        XCTAssertThrowsError(try sut.makeMockLoginRequest(username, andPassword: password))
        
    }
    
    func testLoginNilPasswordFail() throws {
        // given a valid username and password
        let username = "nikita"
        let password = "ZoPW_98"
        
        // then return a user with a login token
        XCTAssertThrowsError(try sut.makeMockLoginRequest(username, andPassword: password))
        
    }

}
