//
//  NotableUIAddNoteTests.swift
//  NotableUITests
//
//  Created by Brent Crowley on 25/3/2023.
//

import XCTest
@testable import Notable

final class NotableUINoteTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        let testEnv: String = "UI_TEST_ENV_FOUR_NOTES" // Xcode wouldn't let me use an enum or static var 🤷‍♂️
        app.launchArguments = [testEnv]
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }
    
    //Scenario: Add a note
    func testAddNote() {
        //Given it is notes screen
        // Must override the default set up as we don't want four notes
        app = XCUIApplication()
        let testEnv: String = "UI_TEST_ENV_LOGGED_IN_USER" // Xcode wouldn't let me use an enum or static var 🤷‍♂️
        app.launchArguments = [testEnv]
        app.launch()
        
        //And all data cleared
        let myNotesScreen = app.navigationBars["Notable"].staticTexts["Notable"]
        XCTAssertTrue(myNotesScreen.exists)
        
        // Then I add a note
        addNote(noteName: "My first note")
        
        //Then I should see "My first note" on the home screen
        let myFirstNote = app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["My first note"]/*[[".cells.staticTexts[\"My first note\"]",".staticTexts[\"My first note\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        XCTAssertTrue(myFirstNote.exists)
    }
    
    //Scenario: Preparing for multiple adding Given it is notes screen
    func testAddingMultipleNotes() {
        //And all data cleared
        app = XCUIApplication()
        let testEnv: String = "UI_TEST_ENV_LOGGED_IN_USER" // Xcode wouldn't let me use an enum or static var 🤷‍♂️
        app.launchArguments = [testEnv]
        app.launch()
        
        //Given it is notes screen
        let myNotesScreen = app.navigationBars["Notable"].staticTexts["Notable"]
        XCTAssertTrue(myNotesScreen.exists)
        
        //Examples:
        //| name|
        //| Note1|
        //| Note2|
        //| Note3|
        //| Note4|
        (1...4).forEach { index in
            addNote(noteName: "Note\(index)")
        }
        
        
    }
    
    //Scenario: Validating added notes Given it is notes screen
    func testValidateFourNotes() {
        
        //Then I should see 4 rows on the notes screen
        (1...4).forEach { index in
            let note = app.collectionViews.staticTexts["Note\(index)"]
            XCTAssertTrue(note.exists)
        }
    }
    
    //Scenario: Validating added notes order Given it is notes screen
    func testNote2IsSecondInList() {
        
        //Then I should see "Note 2" positioned in the second row
        let row2 = app.collectionViews.staticTexts.allElementsBoundByIndex[1].identifier
        let note2 = app.collectionViews.staticTexts["Note2"].identifier
        XCTAssertEqual(row2, note2)
    }
    
    //Scenario: Deleting multiple notes Given it is notes screen
    func testDeleteNotes1And3() {
        
        //Examples:
        //| name|
        //| Note 2 | | Note 4 |
        deleteNote("Note2")
        deleteNote("Note4")
        
    }
    
    //Scenario: Validating deleted notes Given it is notes screen
    func testDeleteNotes12And4SoOnlyNote3Remains() {
        
        deleteNote("Note1")
        deleteNote("Note2")
        deleteNote("Note4")
        
        let row1 = app.collectionViews.staticTexts.allElementsBoundByIndex[0].identifier
        let note = app.collectionViews.staticTexts["Note3"].identifier
        XCTAssertEqual(row1, note)
        
    }
    //Then I should see 1 row on the notes screen And the note name is "Note 3"
    
    
}

// MARK: Helper Functions
extension NotableUINoteTests {
    
    func addNote(noteName: String) {
        //Then I tap the "Add Note" button
        let addButton = app.navigationBars["Notable"]/*@START_MENU_TOKEN@*/.buttons["Add"]/*[[".otherElements[\"Add\"].buttons[\"Add\"]",".buttons[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(addButton.exists)
        addButton.tap()
        
        //And write "<name>" into the "Note Name" field Then I tap the "Save" button
        let note = app.collectionViews.textFields["NoteName"]
        XCTAssertTrue(note.exists)
        note.tap()
        note.typeText(noteName)
        
        let saveButton = app.navigationBars["Add Note"]/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".otherElements[\"Save\"].buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(saveButton.exists)
        saveButton.tap()
        
        //Then I should see "My first note" on the home screen
        let addedNote = app.collectionViews.staticTexts[noteName]
        
        XCTAssertTrue(addedNote.exists)
    }
    
    func deleteNote(_ noteName: String) {
        //When I tap on a "<name>"
        let note = app.collectionViews.staticTexts[noteName]
        XCTAssertTrue(note.exists)
        
        note.tap()
        
        //Then I should see the "Delete" prompt Then I press "Delete"
        let deleteNoteAlert = app.alerts["Delete: \(noteName)"].scrollViews.otherElements.buttons["Delete"]
        XCTAssertTrue(deleteNoteAlert.exists)
        deleteNoteAlert.tap()
        
        XCTAssertFalse(note.exists)
    }
    
}
