//
//  TodoListViewViewModel.swift
//  Checkd
//
//  Created by Josh R on 6/4/22.
//

import Combine
import SwiftUI

/// The view model for a `TodoListView`.
final class TodoListViewViewModel: ObservableObject {
    @Published var activeTodos: [TodoEntity] = []
    @Published var completedTodos: [TodoEntity] = []
    @Published var enteredText: String = ""

    private var cancellables: Set<AnyCancellable> = []

    /// The `Coordinator` for the view model.
    weak var coordinator: AppCoordinator?

    /// The list passed to retrieve the associated todos.
    var list: ListEntity? {
        didSet { fetchTodos() }
    }

    /// The `Repository` for the view model.
    private(set) var todoRepository: TodoRepository

    init(list: ListEntity?, todoRepository: TodoRepository = DefaultTodoRepository()) {
        self.list = list
        self.todoRepository = todoRepository

        todoRepository.repositoryHasChanges
            .sink(receiveCompletion: { _ in }) { [weak self] hasChanges in
            self?.fetchTodos()
        }.store(in: &cancellables)
    }

    /// A method to add a todo via the repository `add` method.
    func addTodo() {
        guard !enteredText.isEmpty, let list = list else { return }
        todoRepository.add(name: enteredText, to: list)
        enteredText.removeAll()
    }

    /// A method to delete a todo via the repository `delete` method.
    /// - Parameters:
    ///   - indexSet: The location of the todo.
    ///   - section: The section where the list originates.
    func deleteTodo(at indexSet: IndexSet, inSection section: Int) {
        for index in indexSet {
            let todo = section == 0 ? activeTodos[index] : completedTodos[index]
            todoRepository.delete(todoEntity: todo)
        }
    }

    /// Fetches todos from repository.
    func fetchTodos() {
        guard let list = list else { return }
        let allListTodos = todoRepository.fetchTodos(in: list)
        activeTodos = allListTodos.filter { !$0.isCompleted }
        completedTodos = allListTodos.filter { $0.isCompleted }
    }

    /// Toggles the status of a todo.
    func toggleTodoStatus(todo: TodoEntity) {
        todoRepository.toggleStatus(todoEntity: todo)
    }
}
