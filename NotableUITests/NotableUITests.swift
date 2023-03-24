//
//  NotableUITests.swift
//  NotableUITests
//
//  Created by Brent Crowley on 24/3/2023.
//

import XCTest
@testable import Notable

final class NotableUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
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
//        As a user, I should be able to log in
    func testOpenLoginScreenOnFirstRun() throws {
//        Given I open the app for the very first time Then I should see a Login screen
        let isFirstLaunchKey = "IsFirstLaunchKey"
        let userDefaults = UserDefaults.standard
        XCTAssertFalse(userDefaults.bool(forKey: isFirstLaunchKey), "isFirstLaunchKey should initially be false")

        // simulate app launch for the first time
        userDefaults.set(true, forKey: isFirstLaunchKey)
        userDefaults.synchronize()

        let loginTitle = app.navigationBars["User Login"].staticTexts["User Login"]
        XCTAssertTrue(loginTitle.exists)

        XCTAssertTrue(userDefaults.bool(forKey: isFirstLaunchKey), "isFirstLaunchKey should be true after app is launched for the first time")
    }
    //Scenario: Login successful
    func testSuccessfulLogin() throws {
        //Given I type my username in the "Username" field
        //And password in the "Password" field
        app.textFields.element.typeText("mike_")
        app.secureTextFields.element.typeText("20Mike")
                
        //When I press the login button
        
        
        //Then I should see an alert "Login Successful"
        

    }
    
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
