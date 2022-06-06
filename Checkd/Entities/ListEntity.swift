//
//  ListEntity.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import CoreData

extension ListEntity {
    static func request() -> NSFetchRequest<ListEntity> {
        let request: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(ListEntity.sortIndex), ascending: true)
        request.sortDescriptors = [sort]
        return request
    }
}

extension ListEntity {

    /// The number of active todos.
    var activeTodoCount: Int {
        sortedTodos.filter { !$0.isCompleted }.count
    }

    /// A collection of sorted todos with the most recent first.
    var sortedTodos: [TodoEntity] {
        guard let sortedTodos = self.todos?
            .compactMap({ $0 as? TodoEntity })
            .sorted(by: { $0.dateCreated ?? Date() > $1.dateCreated ?? Date() }) else { return [] }

        return sortedTodos
    }

    /// A string representation of the number of active todos compared to total todos.
    var status: String {
        if todoCount == 0 {
            return "0"
        } else if activeTodoCount == 0 {
            return "Complete"
        } else {
            return "\(activeTodoCount) / \(todoCount)"
        }
    }

    /// The total number of todos.
    var todoCount: Int {
        todos?.count ?? 0
    }
}

// MARK: `ListEntity`s for Preview

extension ListEntity {
#if DEBUG
    @discardableResult
    static func createForPreview(coreDataStack: CoreDataStack) -> [ListEntity] {
        let todoRepo = DefaultTodoRepository(coreDataStack: coreDataStack)
        let listRepo = DefaultListRepository(coreDataStack: coreDataStack)
        let lists: [String: [String]] = [
            "Groceries": ["Buy bread", "Buy milk", "Buy sugar"],
            "Kids": ["Pay sports bill"],
            "Bills": ["Pay credit cards", "Pay mortgage"],
            "Home": ["Clean kitchen", "Clean bathroom"]
        ]
        guard listRepo.fetchLists().count < lists.count else { return [] }

        var addedLists: [ListEntity] = []

        for list in lists {
            let addedList = listRepo.add(name: list.key)
            addedLists.append(addedList)
            if let todos = lists[list.key] {
                for todo in todos {
                    let addedTodo = todoRepo.add(name: todo, to: addedList)
                    if addedTodo.name!.contains("sugar") {
                        addedTodo.isCompleted = true
                    }
                }
            }
        }

        return addedLists
    }
    #endif
}
