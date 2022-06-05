//
//  TodoRepository.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import Combine
import Foundation

protocol TodoRepository: Repository {
    @discardableResult func add(name: String, to list: ListEntity) -> TodoEntity
    func delete(todoEntity: TodoEntity)
    func fetchTodos(in list: ListEntity) -> [TodoEntity]
    func toggleStatus(todoEntity: TodoEntity)
    @discardableResult func update(name: String, todoEntity: TodoEntity) -> TodoEntity
}

final class DefaultTodoRepository: TodoRepository {
    private var cancellables: Set<AnyCancellable> = []

    private(set) var coreDataStack: CoreDataStack = .shared

    var repositoryHasChanges = PassthroughSubject<Bool, Error>()

    init() {
        coreDataStack.contextDidChange
            .sink(receiveCompletion: { _ in }) { [weak self] _ in
                self?.repositoryHasChanges.send(true)
            }.store(in: &cancellables)
    }

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
        todoEntity.toggleIsDone()
        coreDataStack.save()
    }

    func update(name: String, todoEntity: TodoEntity) -> TodoEntity {
        todoEntity.name = name
        coreDataStack.save()
        return todoEntity
    }

}
