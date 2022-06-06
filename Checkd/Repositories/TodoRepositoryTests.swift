//
//  TodoRepositoryTests.swift
//  CheckdTests
//
//  Created by Josh R on 6/5/22.
//

import XCTest

@testable import Checkd

class TodoRepositoryTests: XCTestCase {
    var subject: MockTodoRepository!

    override func setUp() {
        super.setUp()

        subject = MockTodoRepository()
    }

    override func tearDown() {
        super.tearDown()
        subject = nil
    }

    /// Ensures the repository `add` method successfully adds a todo to the database.
    func testAdd() {
        let list = ListEntity(context: subject.coreDataStack.viewContext)
        list.name = "Groceries"

        let desiredTodoName = "Milk"
        subject.add(name: desiredTodoName, to: list)

        let allTodos = subject.fetchTodos(in: list)
        let databaseTodo = allTodos.first

        XCTAssertEqual(allTodos.count, 1)
        XCTAssertEqual(databaseTodo?.name, desiredTodoName)
        XCTAssertNotNil(databaseTodo?.id)
        XCTAssertNotNil(databaseTodo?.dateCreated)
        XCTAssertEqual(databaseTodo?.list, list)
        XCTAssertEqual(databaseTodo?.list?.todoCount, 1)
    }

    /// Ensures the `CoreDataStack` is in memory.
    func testCoreDataStack() {
        XCTAssertTrue(subject.coreDataStack.inMemory)
    }

    /// Ensures the repository `delete` method successfully deletes a todo from the database.
    func testDelete() {
        let list = ListEntity(context: subject.coreDataStack.viewContext)
        list.name = "Groceries"

        let desiredTodoName = "Milk"
        let milkTodo = subject.add(name: desiredTodoName, to: list)

        let allTodos = subject.fetchTodos(in: list)
        XCTAssertEqual(allTodos.count, 1)

        subject.delete(todoEntity: milkTodo)

        let allTodos2 = subject.fetchTodos(in: list)
        XCTAssertEqual(allTodos2.count, 0)
    }

    /// Ensures the repository `update` method successfully updates the todo in the database.
    func testUpdate() {
        let list = ListEntity(context: subject.coreDataStack.viewContext)
        list.name = "Groceries"

        let misspelledTodoName = "Millllllk"
        let milkTodo = subject.add(name: misspelledTodoName, to: list)

        let allTodos = subject.fetchTodos(in: list)
        XCTAssertEqual(allTodos.count, 1)

        let desiredTodoName = "Milk"
        let updatedTodo = subject.update(name: desiredTodoName, todoEntity: milkTodo)

        let allTodos2 = subject.fetchTodos(in: list)
        XCTAssertEqual(allTodos2.count, 1)
        XCTAssertEqual(allTodos2.first, updatedTodo)
        XCTAssertEqual(allTodos2.first?.name, desiredTodoName)
    }
}
