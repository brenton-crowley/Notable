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
        let testEnv: String = "UI_TEST_ENV_EMPTY" // Xcode wouldn't let me use an enum or static var 🤷‍♂️
        app = XCUIApplication()
        app.launchArguments = [testEnv]
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
        let username = app.collectionViews/*@START_MENU_TOKEN@*/.textFields["Username"]/*[[".cells.textFields[\"Username\"]",".textFields[\"Username\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        XCTAssertTrue(username.exists)
        
        username.tap()
        username.typeText("mike_")
        
        let password = app.collectionViews/*@START_MENU_TOKEN@*/.secureTextFields["Password"]/*[[".cells.secureTextFields[\"Password\"]",".secureTextFields[\"Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/

        XCTAssertTrue(password.exists)
        
        //And password in the "Password" field
        password.tap()
        password.typeText("20Mike")
        
        //When I press the login button
        let loginButton = app.navigationBars["User Login"]/*@START_MENU_TOKEN@*/.buttons["Login"]/*[[".otherElements[\"Login\"].buttons[\"Login\"]",".buttons[\"Login\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(loginButton.exists)
        loginButton.tap()
        
        let elementsQuery = app.alerts["Login Successful"].scrollViews.otherElements
        let successTitle = elementsQuery.staticTexts["Login Successful"]
        
        //Then I should see an alert "Login Successful"
        XCTAssertTrue(successTitle.exists)
    }
    
    //Scenario: Home screen after successful login
    func testShowNotesScreenAfterSuccessfulLogin() {
        
        //Given I type my username in the "Username" field And password in the "Password" field
        let collectionViewsQuery = app.collectionViews
        let textView = collectionViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
        textView.tap()
        textView.typeText("mike_")
        
        let secureTextField = app/*@START_MENU_TOKEN@*/.collectionViews.containing(.other, identifier:"Vertical scroll bar, 1 page")/*[[".collectionViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\")",".collectionViews.containing(.other, identifier:\"Vertical scroll bar, 1 page\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .cell).element(boundBy: 3).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .secureTextField).element
        secureTextField.tap()
        secureTextField.typeText("20Mike")
        
        //When I press the login button
        app.navigationBars["User Login"]/*@START_MENU_TOKEN@*/.buttons["Login"]/*[[".otherElements[\"Login\"].buttons[\"Login\"]",".buttons[\"Login\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let elementsQuery = app.alerts["Login Successful"].scrollViews.otherElements
        //Then I should see the alert "Login Successful" When I tap the "Okay" button
        
    }
    
    
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
