//
//  NotableNoteTests.swift
//  NotableTests
//
//  Created by Brent Crowley on 25/3/2023.
//

import XCTest
@testable import Notable

final class NotableNoteTests: XCTestCase {

    var sut: StorageProvider!
    var user: User!
    
    let noteName = "My First Note"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = StorageProvider.preview
        try? sut.addUserWithUsername("Test User", andLoginToken: "login-token-test")
        user = try? sut.fetchLoggedInUser()
    }

    override func tearDownWithError() throws {
        
        try sut.delete(user)
        
        sut = nil
        user = nil
        
        try super.tearDownWithError()
    }

    func testUserExists() {
        XCTAssertNotNil(user)
    }
    
//Scenario: Add a note
    func testAddNoteToStore() {
        
        try? sut.addNoteWithName(noteName, toUser: user)
        
        XCTAssertTrue(user.notes?.count == 1)
        
        if let note = user.notes?.allObjects.first as? Note { XCTAssertEqual(noteName, note.noteName) }
    }
    
    func testAddFourNotesToStore() {
    
        (1...4).forEach { index in
            try? sut.addNoteWithName("Note \(index)", toUser: user)
        }
        
        XCTAssertTrue(user.notes?.count == 4)
    }

    func testDeleteSingleNote() throws {
        
        (1...4).forEach { index in
            try? sut.addNoteWithName("Note \(index)", toUser: user)
        }
        
        XCTAssertTrue(user.notes?.count == 4)
        
        if let noteToDelete = user.notes?.allObjects.first as? Note {
            try sut.delete(noteToDelete)
            XCTAssertTrue(user.notes?.count == 3)
        }
    }
    
    func testDeleteMultipleNotes() {
        
        (1...4).forEach { index in
            try? sut.addNoteWithName("Note \(index)", toUser: user)
        }
        
        XCTAssertTrue(user.notes?.count == 4)
        
        (0..<2).forEach { index in
            if let noteToDelete = user.notes?.allObjects[index] as? Note {
                try? sut.delete(noteToDelete)
            }
        }
        XCTAssertTrue(user.notes?.count == 2)
        
    }
    
    func testFetchSortedNotesForUser() {
        
        // given
        sut = StorageProvider.previewWithNotes
        user = try? sut.fetchLoggedInUser()
        
        let sortedNotes = sut.fetchAllNotesSortedByCreationDateForUser(user)
        
    }
    
}
