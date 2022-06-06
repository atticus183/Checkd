//
//  ListRepository.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import Combine
import CoreData
import Foundation

protocol ListRepository: Repository {

    /// Adds a `ListEntity`.
    /// - Parameter name: The desired name of the list.
    /// - Returns: A successfully added `ListEntity`.
    @discardableResult func add(name: String) -> ListEntity

    /// Deletes a `ListEntity`.
    /// - Parameter listEntity: The list to delete.
    func delete(listEntity: ListEntity)

    /// Fetches all lists.
    /// - Returns: An array of `ListEntity`.
    func fetchLists() -> [ListEntity]

    /// Reorders a `ListEntity`.
    /// - Parameters:
    ///   - list: The list to move.
    ///   - index: The destination index.
    ///   - lists: The lists displayed.
    func move(list: ListEntity, to index: Int, lists: [ListEntity])

    /// Updates a `ListEntity`.
    /// - Parameters:
    ///   - name: The desired new name.
    ///   - listEntity: The list to update.
    /// - Returns: The updated list.
    @discardableResult func update(name: String, listEntity: ListEntity) -> ListEntity
}

/// A concrete implementation of a `ListRepository`.
class DefaultListRepository: ListRepository {
    private var cancellables: Set<AnyCancellable> = []

    private(set) var coreDataStack: CoreDataStack

    var repositoryHasChanges = PassthroughSubject<Bool, Error>()

    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack

        coreDataStack.contextDidChange
            .sink(receiveCompletion: { _ in }) { [weak self] _ in
                self?.repositoryHasChanges.send(true)
            }.store(in: &cancellables)
    }

    @discardableResult
    func add(name: String) -> ListEntity {
        let list = ListEntity(context: coreDataStack.viewContext)
        list.id = UUID()
        list.name = name

        let numberOfLists = fetchLists().count
        list.sortIndex = Int64(numberOfLists == 0 ? 0 : numberOfLists - 1)

        coreDataStack.save()

        return list
    }

    func delete(listEntity: ListEntity) {
        coreDataStack.viewContext.delete(listEntity)
        coreDataStack.save()
    }

    func fetchLists() -> [ListEntity] {
        let request = ListEntity.request()

        do {
            return try coreDataStack.viewContext.fetch(request) as [ListEntity]
        } catch {
            assertionFailure("ERROR-ListRepository: \(error.localizedDescription)")
            return []
        }
    }

    func move(list: ListEntity, to index: Int, lists: [ListEntity]) {
        //Reassign lists below index
        let listToReassign = lists.filter { $0.sortIndex >= index }
        listToReassign.forEach { $0.sortIndex += 1 }

        //Reassign list being moved
        list.sortIndex = Int64(index)
        coreDataStack.save()
    }

    @discardableResult
    func update(name: String, listEntity: ListEntity) -> ListEntity {
        listEntity.name = name
        return listEntity
    }

}
