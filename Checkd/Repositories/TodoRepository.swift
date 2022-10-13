//
//  TodoRepository.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import Combine
import Foundation

protocol TodoRepository: Repository {

    /// Adds a `TodoEntity`.
    /// - Parameters:
    ///   - name: The desired name of the todo.
    ///   - list: The list belonging to the todo.
    /// - Returns: A successfully added `TodoEntity`.
    @discardableResult
    func add(name: String, to list: ListEntity) -> TodoEntity

    /// Deletes a `TodoEntity`.
    /// - Parameter todoEntity: The todo to delete.
    func delete(todoEntity: TodoEntity)

    /// Fetches all todos.
    /// - Returns: An array of `TodoEntity`.
    func fetchAllTodos() -> [TodoEntity]

    /// Fetches todos in a `ListEntity`.
    /// - Parameter list: The list to filter on.
    /// - Returns: An array of `TodoEntity`.
    func fetchTodos(in list: ListEntity) -> [TodoEntity]

    /// Toggles the completion state of the todo.
    /// - Parameter todoEntity: The todo to toggle.
    func toggleStatus(todoEntity: TodoEntity)

    /// Updates a `TodoEntity`.
    /// - Parameters:
    ///   - name: The desired new name.
    ///   - todoEntity: The todo to update.
    /// - Returns: The updated todo.
    @discardableResult
    func update(name: String, todoEntity: TodoEntity) -> TodoEntity
}

/// A concrete implementation of a `TodoRepository`.
class DefaultTodoRepository: TodoRepository {
    private var cancellables: Set<AnyCancellable> = []

    private(set) var coreDataStack: CoreDataStack

    let repositoryHasChanges = PassthroughSubject<Bool, Error>()

    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack

        coreDataStack.contextDidChange
            .sink(receiveCompletion: { _ in }) { [weak self] _ in
                self?.repositoryHasChanges.send(true)
            }.store(in: &cancellables)
    }

    @discardableResult
    func add(name: String, to list: ListEntity) -> TodoEntity {
        let todo = TodoEntity(context: coreDataStack.viewContext)
        todo.id = UUID()
        todo.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        todo.dateCreated = Date()
        todo.list = list

        coreDataStack.save()

        return todo
    }

    func delete(todoEntity: TodoEntity) {
        coreDataStack.viewContext.delete(todoEntity)
        coreDataStack.save()
    }

    func fetchAllTodos() -> [TodoEntity] {
        let request = TodoEntity.request(in: nil)

        do {
            return try coreDataStack.viewContext.fetch(request) as [TodoEntity]
        } catch {
            assertionFailure("ERROR-TodoRepository: \(error.localizedDescription)")
            return []
        }
    }

    func fetchTodos(in list: ListEntity) -> [TodoEntity] {
        let request = TodoEntity.request(in: list)

        do {
            return try coreDataStack.viewContext.fetch(request) as [TodoEntity]
        } catch {
            assertionFailure("ERROR-TodoRepository: \(error.localizedDescription)")
            return []
        }
    }

    func toggleStatus(todoEntity: TodoEntity) {
        //Change from Complete to Not Done
        if todoEntity.isCompleted {
            todoEntity.dateCompleted = nil
        } else {
            //Mark Complete
            todoEntity.dateCompleted = Date()
        }

        todoEntity.toggleIsDone()
        coreDataStack.save()
    }

    @discardableResult
    func update(name: String, todoEntity: TodoEntity) -> TodoEntity {
        todoEntity.name = name
        coreDataStack.save()
        return todoEntity
    }

}
