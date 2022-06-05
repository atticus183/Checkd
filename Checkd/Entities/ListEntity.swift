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
    var activeTodos: Int {
        sortedTodos.filter { !$0.isCompleted }.count
    }

    var sortedTodos: [TodoEntity] {
        guard let sortedTodos = self.todos?
            .compactMap({ $0 as? TodoEntity })
            .sorted(by: { $0.dateCreated ?? Date() > $1.dateCreated ?? Date() }) else { return [] }

        return sortedTodos
    }

    var status: String {
        todoCount == 0 ? "0" : "\(activeTodos) / \(todoCount)"
    }

    var todoCount: Int {
        todos?.count ?? 0
    }

    func toggleIsPinned() {
        self.isPinned.toggle()
    }
}

// MARK: `ListEntity`s for Preview

extension ListEntity {
    #if DEBUG
    static func createForPreview() {
        let repo = DefaultListRepository()
        let listNames = ["Groceries", "Kids", "Bills", "Home"]
        guard repo.fetchLists().count < listNames.count else { return }

        for list in listNames {
            repo.add(name: list)
        }
    }

    static func sampleList() -> ListEntity {
        let repo = DefaultListRepository()
        let list = repo.add(name: "Test List")
        return list
    }
    #endif
}
