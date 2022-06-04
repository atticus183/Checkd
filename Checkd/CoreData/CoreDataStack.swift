//
//  CoreDataStack.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import Combine
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    var contextDidChange = PassthroughSubject<Void, Error>()

    var inMemory: Bool {
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            //Running in the preview
            return true
        } else if let _ = NSClassFromString("XCTest") {
            //Running unit tests
            return true
        } else {
            //Running in the simulator
            return false
        }
        #else
        //Running in production/release builds
        return false
        #endif
    }

    private(set) var modelName: String = "Checkd"

    var viewContext: NSManagedObjectContext { container.viewContext }

    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didSave),
            name: NSManagedObjectContext.didSaveObjectsNotification,
            object: viewContext
        )
    }

    // MARK: NSPersistentContainer
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
