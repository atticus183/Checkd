//
//  TodoListViewViewModel.swift
//  Checkd
//
//  Created by Josh R on 6/4/22.
//

import Combine
import SwiftUI

final class TodoListViewViewModel: ObservableObject {
    @Published var activeTodos: [TodoEntity] = []
    @Published var completedTodos: [TodoEntity] = []
    @Published var enteredText: String = ""

    weak var coordinator: AppCoordinator?

    /// The list passed to retrieve the associated todos.
    var list: ListEntity? {
        didSet { fetchTodos() }
    }

    private var cancellables: Set<AnyCancellable> = []

    private let todoRepository: TodoRepository

    init(list: ListEntity?, todoRepository: TodoRepository = DefaultTodoRepository()) {
        self.list = list
        self.todoRepository = todoRepository

        todoRepository.repositoryHasChanges
            .sink(receiveCompletion: { _ in }) { [weak self] hasChanges in
            self?.fetchTodos()
        }.store(in: &cancellables)
    }

    func addTodo() {
        guard !enteredText.isEmpty, let list = list else { return }
        todoRepository.add(name: enteredText, to: list)
        enteredText.removeAll()
    }

    func deleteTodo(at indexSet: IndexSet, inSection section: Int) {
        for index in indexSet {
            let todo = section == 0 ? activeTodos[index] : completedTodos[index]
            todoRepository.delete(todoEntity: todo)
        }
    }

    func fetchTodos() {
        guard let list = list else { return }
        let allListTodos = todoRepository.fetchTodos(in: list)
        activeTodos = allListTodos.filter { !$0.isCompleted }
        completedTodos = allListTodos.filter { $0.isCompleted }
    }

    func toggleTodoStatus(todo: TodoEntity) {
        todoRepository.toggleStatus(todoEntity: todo)
    }
}
