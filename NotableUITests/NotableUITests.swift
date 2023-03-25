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
        enterUsername("mike_", andPassword: "20Mike")
        
        //When I press the login button
        login()
        
        let elementsQuery = app.alerts["Login Successful"].scrollViews.otherElements
        let successTitle = elementsQuery.staticTexts["Login Successful"]
        
        //Then I should see an alert "Login Successful"
        XCTAssertTrue(successTitle.exists)
    }
    
    //Scenario: Home screen after successful login
    func testShowNotesScreenAfterSuccessfulLogin() {
        
        //Given I type my username in the "Username" field And password in the "Password" field
        enterUsername("mike_", andPassword: "20Mike")
        
        //When I press the login button
        login()
        
        let elementsQuery = app.alerts["Login Successful"].scrollViews.otherElements
        let successTitle = elementsQuery.staticTexts["Login Successful"]
        
        XCTAssertTrue(successTitle.exists)
        
        //Then I should see the alert "Login Successful" When I tap the "Okay" button
        let myNotesScreen = app.navigationBars["MyNotes"].staticTexts["MyNotes"]
        XCTAssertTrue(myNotesScreen.exists)
        
    }
    
    
    //Scenario: Validating Login
    /// This test is a bit odd as there isn't a login button to bring up the login screen.
    func testFailedLogins() {
        
        //Given I type <username> in the "Username" field And <password> in the "Password" field
        //Examples:
        //| username | password
        //| mike_ | 20Mike -> Tested multipole times above -> true
        //| john01 | Ab01@1 -> false
        performInvalidLogin(username: "john01", password: "Ab01@1", feedbackText: "Invalid Password")
        //| nikita | ZoPW_98 -> false
        performInvalidLogin(username: "nikita", password: "ZoPW_98", feedbackText: "Invalid Password")
        //| test | test2@ -> true
        performValidLogin(username: "test", password: "test2@")
    }
    
    //Scenario: Auto Login
    func testAutoLogin() {
        //Given I open the app after a successful login Then I should see the "Notes" screen
        
        // Need to kill the default flag first
        // Probably a better way to go about this, but it will do for now.
        let testEnv: String = "UI_TEST_ENV_LOGGED_IN_USER"
        app = XCUIApplication()
        app.launchArguments = [testEnv]
        app.launch()
        
        //Then I should see the alert "Login Successful" When I tap the "Okay" button
        let myNotesScreen = app.navigationBars["MyNotes"].staticTexts["MyNotes"]
        XCTAssertTrue(myNotesScreen.exists)
    }
}

/// I've created some convenience methods for repeatable code. Not sure if this is best practice or not. I could see it going either way
/// Reduces clutter at the expenses of some readability with the assert statements.
extension NotableUITests {
    
    func enterUsername(_ usernameText: String, andPassword passwordText:String ) {
        
        let username = app.collectionViews/*@START_MENU_TOKEN@*/.textFields["Username"]/*[[".cells.textFields[\"Username\"]",".textFields[\"Username\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(username.exists)
        
        username.tap()
        username.clearAndEnterText(text: usernameText)
        
        let password = app.collectionViews/*@START_MENU_TOKEN@*/.secureTextFields["Password"]/*[[".cells.secureTextFields[\"Password\"]",".secureTextFields[\"Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(password.exists)
        
        password.tap()
        password.clearAndEnterText(text: passwordText)
    }
    
    func login() {
        let loginButton = app.navigationBars["User Login"]/*@START_MENU_TOKEN@*/.buttons["Login"]/*[[".otherElements[\"Login\"].buttons[\"Login\"]",".buttons[\"Login\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(loginButton.exists)
        
        loginButton.tap()
    }
    
    func validateAlertFeedbackWith(_ feedbackText: String) {
        
        let alertQuery = app.alerts[feedbackText].scrollViews.otherElements
        let alertTitle = alertQuery.staticTexts[feedbackText]
        
        XCTAssertTrue(alertTitle.exists)
        
        let okButton = app.alerts[feedbackText].scrollViews.otherElements.buttons["OK"]
        XCTAssertTrue(okButton.exists)
        
        okButton.tap()
    }
    
    func performValidLogin(username: String, password: String) {
        //Given I type <username> in the "Username" field And <password> in the "Password" field
        enterUsername(username, andPassword: password)
        //When I press the login button
        login()
        //Then I should see alert "Login <status>"
        validateAlertFeedbackWith("Login Successful")
    }
    
    func performInvalidLogin(username: String, password: String, feedbackText: String = "Invalid Password") {
        //Given I type <username> in the "Username" field And <password> in the "Password" field
        enterUsername(username, andPassword: password)
        //When I press the login button
        login()
        //Then I should see alert "Login <status>"
        validateAlertFeedbackWith(feedbackText)
    }
    
}

/// This is from stack overflow. Source: https://stackoverflow.com/questions/32821880/ui-test-deleting-text-in-text-field
extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        self.tap()

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)

        self.typeText(deleteString)
        self.typeText(text)
    }
}
