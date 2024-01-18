//
//  CoreDataStorage.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import CoreData

enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

final class CoreDataStorage {
    // MARK: - Properties

    static let shared = CoreDataStorage()

    private let containerName = "CoreDataStorage"

    private lazy var persistentContainer: NSPersistentContainer = {
        let container: NSPersistentContainer = NSPersistentContainer(name: containerName)

        container.loadPersistentStores { [weak self] _, error in
            if let self,
               let error = error as NSError? {
                assertionFailure("\(containerName) Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Initialization

    private init() {}

    // MARK: - Core Data Saving support

    func saveContext() throws {
        let context = viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw CoreDataStorageError.saveError(error)
            }
        }
    }

    // MARK: - Background Task

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
