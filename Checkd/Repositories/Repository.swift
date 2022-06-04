//
//  Repository.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

protocol Repository: AnyObject {
    /// The core data stack for the application.
    var coreDataStack: CoreDataStack { get }

    /// A method to search a `Repository`.
    /// - Parameter searchText: The text to search with.
    func search(with searchText: String)
}


final class Repositories {
    let listRepository: ListRepository
    let todoRepository: TodoRepository

    init(
        listRepository: ListRepository = DefaultListRepository(),
        todoRepository: TodoRepository = DefaultTodoRepository()
    ) {
        self.listRepository = listRepository
        self.todoRepository = todoRepository
    }

}
