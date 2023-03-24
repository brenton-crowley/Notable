//
//  Note+CoreDataProperties.swift
//  Notable
//
//  Created by Brent Crowley on 24/3/2023.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var user: User?

}

extension Note : Identifiable {

}
