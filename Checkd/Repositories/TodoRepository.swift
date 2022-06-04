//
//  TodoRepository.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import Foundation

protocol TodoRepository: Repository {
    @discardableResult func add(name: String) -> TodoEntity
    func delete(todoEntity: TodoEntity)
    @discardableResult func update(name: String, todoEntity: TodoEntity) -> TodoEntity
}

final class DefaultTodoRepository: TodoRepository {
    private(set) var coreDataStack: CoreDataStack = .shared

    func add(name: String) -> TodoEntity {
        let todo = TodoEntity(context: coreDataStack.viewContext)
        todo.id = UUID()
        todo.name = name
        return todo
    }

    func delete(todoEntity: TodoEntity) {
        coreDataStack.viewContext.delete(todoEntity)
    }

    func search(with searchText: String) {
        return
    }

    func update(name: String, todoEntity: TodoEntity) -> TodoEntity {
        todoEntity.name = name
        return todoEntity
    }

}
