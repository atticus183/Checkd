//
//  CoreDataStack.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    private(set) var inMemory: Bool = false

    private(set) var modelName: String = "Checkd"

    init(inMemory: Bool = false) {
        self.inMemory = inMemory
    }

    // MARK: NSPersistentContainer
    lazy var container: NSPersistentContainer = {
        let container: NSPersistentContainer
        container = NSPersistentContainer(name: modelName)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

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

// MARK: Preview

extension CoreDataStack {
    static var preview: CoreDataStack = {
        let result = CoreDataStack(inMemory: true)
        let viewContext = result.container.viewContext

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
