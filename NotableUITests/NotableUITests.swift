//
//  NotableUITests.swift
//  NotableUITests
//
//  Created by Brent Crowley on 24/3/2023.
//

import XCTest

final class NotableUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    // Feature: User Login
    // Scenario: Login screen
    func testOpenLoginScreenOnFirstRun() throws {
        
        //        As a user, I should be able to log in
        //        Given I open the app for the very first time Then I should see a Login screen
    }
    //Scenario: Login successful
    //Given I type my username in the "Username" field
    //And password in the "Password" field
    //When I press the login button
    //Then I should see an alert "Login Successful"
    
    //Scenario: Home screen after successful login
    //Given I type my username in the "Username" field And password in the "Password" field
    //When I press the login button
    //Then I should see the alert "Login Successful" When I tap the "Okay" button
    //Then I should see the "Notes" screen
    
    //Scenario: Validating Login
    //Given I type <username> in the "Username" field And <password> in the "Password" field
    //When I press the login button
    //Then I should see alert "Login <status>"
    //Examples:
    //| username |
    //| john01 |
    //| mike_ |
    //| nikita |
    //| test |
    //password | Ab01@1 | 20Mike | ZoPW_98 | test2@ |
    //status |
    //false | true | false | true |
    
    //Scenario: Auto Login
    //Given I open the app after a successful login Then I should see the "Notes" screen
}
