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
        todo.name = name
        todo.list = list

        return todo
    }

    func delete(todoEntity: TodoEntity) {
        coreDataStack.viewContext.delete(todoEntity)
    }

    func update(name: String, todoEntity: TodoEntity) -> TodoEntity {
        todoEntity.name = name
        return todoEntity
    }

}
