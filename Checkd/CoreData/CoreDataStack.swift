//
//  CoreDataStack.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import Combine
import CoreData

/// The Core Data object for the application.
final class CoreDataStack {
    static let shared = CoreDataStack()

    /// A `PassthroughSubject` that emits a value when the viewContext has changed.
    var contextDidChange = PassthroughSubject<Void, Error>()

    /// A `Boolean` to set if the store should be in memory.
    /// Set to `true` during unit tests.
    private(set) var inMemory: Bool

    /// The name of the core data model.
    private(set) var modelName: String = "Checkd"

    /// The view context of the `NSPersistentContainer`.
    var viewContext: NSManagedObjectContext { container.viewContext }

    /// Initializes a `CoreDataStack`.
    /// - Parameter inMemory: Determines if the store should be in memory.
    init(inMemory: Bool = false) {
        self.inMemory = inMemory

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didSave),
            name: NSManagedObjectContext.didSaveObjectsNotification,
            object: viewContext
        )
    }

    // MARK: NSPersistentContainer

    /// The `NSPersistentContainer` of the application.
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType
        })
        return container
    }()

    @objc func didSave() {
        contextDidChange.send(())
    }

    /// A method to save the `NSManagedObjectContext`.
    func save() {
        guard container.viewContext.hasChanges else { return }

        do {
            try container.viewContext.save()
        } catch {
            assertionFailure("Error saving context: \(error)")
        }
    }
}
