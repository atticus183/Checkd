//
//  TodoListViewViewModelTests.swift
//  CheckdTests
//
//  Created by Josh R on 6/5/22.
//

import XCTest

@testable import Checkd

class TodoListViewViewModelTests: XCTestCase {
    var mockListRepository: MockListRepository!
    var mockRepository: MockTodoRepository!
    var subject: TodoListViewViewModel!

    override func setUp() {
        super.setUp()
        let coreDataStack = CoreDataStack(inMemory: true)
        mockListRepository = MockListRepository(coreDataStack: coreDataStack)
        mockRepository = MockTodoRepository(coreDataStack: coreDataStack)
        subject = TodoListViewViewModel(list: nil, todoRepository: mockRepository)
    }

    override func tearDown() {
        super.tearDown()
        subject = nil
    }

    func testAddTodo() {
        let list = mockListRepository.add(name: "Shopping")
        subject.list = list
        subject.enteredText = "Buy milk"
        subject.addTodo()

        XCTAssertEqual(list.todoCount, 1)
        let todos = mockRepository.fetchTodos(in: list)
        XCTAssertEqual(todos.count, 1)
    }

    func testCoreDataStack() {
        XCTAssertTrue(subject.todoRepository.coreDataStack.inMemory)
    }

    func testDeleteTodo() {
        let list = mockListRepository.add(name: "Shopping")
        subject.list = list
        subject.enteredText = "Buy milk"
        subject.addTodo()

        let todos = mockRepository.fetchTodos(in: list)
        XCTAssertEqual(todos.count, 1)

        let indexSet = IndexSet(integer: 0)
        subject.deleteTodo(at: indexSet, inSection: 0)

        let todos2 = mockRepository.fetchTodos(in: list)
        XCTAssertEqual(todos2.count, 0)
        XCTAssertEqual(list.todoCount, 0)
    }

    func testFetchTodos() {
        let list = mockListRepository.add(name: "Shopping")
        subject.list = list
        subject.enteredText = "Buy milk"
        subject.addTodo()

        let todos = mockRepository.fetchTodos(in: list)
        XCTAssertEqual(todos.count, 1)
    }

    func testToggleTodoStatus() {
        let list = mockListRepository.add(name: "Shopping")
        subject.list = list
        subject.enteredText = "Buy milk"
        subject.addTodo()

        let todos = mockRepository.fetchTodos(in: list)
        let buyMilkTodo = todos.first!
        XCTAssertFalse(buyMilkTodo.isCompleted)
        XCTAssertNil(buyMilkTodo.dateCompleted)

        subject.toggleTodoStatus(todo: buyMilkTodo)
        XCTAssertTrue(buyMilkTodo.isCompleted)
        XCTAssertNotNil(buyMilkTodo.dateCompleted)
    }
}
