//
//  DataStoreManager.swift
//  Notes
//
//  Created by Никита Андриянников on 26.03.2022.
//

import Foundation
import CoreData

// MARK: - Core Data support

class DataStoreManager {

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Note")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    lazy var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()

    // MARK: - CRUD

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // Create note.
    func createNote(title: String, content: String) -> Note {
        let note = Note(context: viewContext)
        note.title = title
        note.content = content

        do {
            try viewContext.save()
        } catch let error {
            print("Error: \(error)")
        }
        return note
    }
    // Get notes.
    func getNotes() -> [Note] {
        var notes: [Note] = []
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")

        do {
            notes = try viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        return notes
    }

    func updateNote(idx: Int, title: String, content: String) {
        
    }
}
