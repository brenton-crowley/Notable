//
//  StorageProvider.swift
//  Notable
//
//  Created by Brent Crowley on 24/3/2023.
//

import Foundation
import CoreData

enum StorageError: Error {
    
    case userAlreadyExists(String = "Cannot add user as the username is already taken")
    case failedToDeleteObject(object:NSManagedObject)
    
}

class StorageProvider {
    
    let persistentContainer: NSPersistentContainer
    
    static var preview: StorageProvider {
        
        let storageProvider = StorageProvider(inMemory: true)
        
        return storageProvider
    }
    
    static var previewWithLoggedInUser: StorageProvider {
        
        let storageProvider = StorageProvider(inMemory: true)
        
        // comment out if not wanting to have a logged in user
        try? storageProvider.addUserWithUsername("Test", andLoginToken: "some-login-token")
        try? storageProvider.save()
        
        return storageProvider
    }
    
    static var previewWithNotes: StorageProvider {
        
        let storageProvider = StorageProvider(inMemory: true)
        
        // comment out if not wanting to have a logged in user
        try? storageProvider.addUserWithUsername("Test", andLoginToken: "some-login-token")
        try? storageProvider.save()
        
        if let user = try? storageProvider.fetchLoggedInUser() {
            (1...4).forEach { index in
                try? storageProvider.addNoteWithName("Note \(index)", toUser: user)
            }
        }
        
        
        return storageProvider
    }
    
    init(inMemory:Bool = false) {
        
        persistentContainer = NSPersistentContainer(name: "Notable")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Attempt to load persistent stores (the underlying storage of data)
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                
                // For now, any failure to load the model is a programming error, and not recoverable
                fatalError("Core Data store failed to load with error: \(error)")
            } else {
                
                print("Successfully loaded persistent stores.")
            }
        }
        
    }
}

extension StorageProvider {
    
    // adds a new user to the data model unless that username already exists.
    func addUserWithUsername(_ username: String, andLoginToken loginToken: String? = nil) throws {
        
        var user = try fetchUserWithUsername(username)
        
        guard user == nil else {
            throw StorageError.userAlreadyExists()
        }
        
        user = User(context: persistentContainer.viewContext)
        user?.id = UUID()
        user?.username = username
        user?.timestamp = Date()
        user?.loginToken = loginToken
        
        try save()
        
    }
    
    // convenience method to commit any modifications to data model.
    func save() throws {
        try self.persistentContainer.viewContext.save()
    }
    
}

extension StorageProvider {
    
    func fetchUserWithUsername(_ username: String) throws -> User? {
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        let predicate = NSPredicate(format: "%K = %@", #keyPath(User.username), username
        )
        
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate
        
        let users = try persistentContainer.viewContext.fetch(fetchRequest)
        
        return users.first
    }
    
    func fetchLoggedInUser() throws -> User? {
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        let predicate = NSPredicate(format: "%K != nil", #keyPath(User.loginToken)
        )
        
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate
        
        let users = try persistentContainer.viewContext.fetch(fetchRequest)
        
        return users.first
    }
}

extension StorageProvider {
    
    /// Generic method to delete either a user or a note from the store.
    func delete<Entity:NSManagedObject>(_ object:Entity) throws {
        
        persistentContainer.viewContext.delete(object)
        
        do {
            try save()
        } catch {
            persistentContainer.viewContext.rollback()
            throw StorageError.failedToDeleteObject(object: object)
        }
    }
    
}

// MARK: - Notes
extension StorageProvider {
    
    func addNoteWithName(_ noteName: String, toUser user: User) throws {
        
        let note = Note(context: persistentContainer.viewContext)
        note.id = UUID()
        note.noteName = noteName
        note.timestamp = Date()
        note.user = user
        
        try save()
    }
    
}
