//
//  TodoListViewViewModel.swift
//  Checkd
//
//  Created by Josh R on 6/4/22.
//

import Combine
import SwiftUI

@MainActor
final class TodoListViewViewModel: ObservableObject {
    @Published var todos: [TodoEntity] = []

    var list: ListEntity

    private var cancellables: Set<AnyCancellable> = []

    private let todoRepository: TodoRepository

    init(list: ListEntity, todoRepository: TodoRepository = DefaultTodoRepository()) {
        self.list = list
        self.todoRepository = todoRepository
    }

    func deleteTodo(at indexSet: IndexSet) {
        for index in indexSet {
            let todo = todos[index]
            todoRepository.delete(todoEntity: todo)
        }
    }

    func fetchTodos() {
        todos = todoRepository.fetchTodos()
    }
}
