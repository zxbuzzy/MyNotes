//
//  Note+CoreDataProperties.swift
//  Notes
//
//  Created by Никита Андриянников on 26.03.2022.
//
//

import Foundation
import CoreData

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?

}

extension Note: Identifiable {

}
