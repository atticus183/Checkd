//
//  ListRepositoryTests.swift
//  CheckdTests
//
//  Created by Josh R on 6/5/22.
//

import XCTest

@testable import Checkd

class ListRepositoryTests: XCTestCase {
    var mockTodoRepository: MockTodoRepository!
    var subject: MockListRepository!

    override func setUp() {
        super.setUp()

        let coreDataStack = CoreDataStack(inMemory: true)
        mockTodoRepository = MockTodoRepository(coreDataStack: coreDataStack)
        subject = MockListRepository(coreDataStack: coreDataStack)
    }

    override func tearDown() {
        super.tearDown()
        subject = nil
    }

    /// Ensures the repository `add` method successfully adds a list to the database.
    func testAdd() {
        let desiredListName = "Groceries"
        subject.add(name: desiredListName)

        let allLists = subject.fetchLists()
        let databaseList = allLists.first

        XCTAssertEqual(allLists.count, 1)
        XCTAssertEqual(databaseList?.name, desiredListName)
        XCTAssertNotNil(databaseList?.id)
    }

    /// Ensures the `CoreDataStack` is in memory.
    func testCoreDataStack() {
        XCTAssertTrue(subject.coreDataStack.inMemory)
    }

    /// Ensures the repository `delete` method successfully deletes a list from the database.
    func testDelete() {
        let desiredListName = "Groceries"
        subject.add(name: desiredListName)

        let allLists = subject.fetchLists()
        let databaseList = allLists.first

        XCTAssertNotNil(databaseList)

        subject.delete(listEntity: databaseList!)

        let allLists2 = subject.fetchLists()
        XCTAssertEqual(allLists2.count, 0)
    }

    /// Ensures the repository `delete` method successfully deletes a list to the database.
    /// Also ensures the associated todos are also deleted.
    func testDelete_TodosDelete() {
        let desiredListName = "Groceries"
        let list = subject.add(name: desiredListName)

        let todo1 = mockTodoRepository.add(name: "Buy milk", to: list)
        todo1.list = list
        let todo2 = mockTodoRepository.add(name: "Buy bread", to: list)
        todo2.list = list

        XCTAssertEqual(list.todoCount, 2)

        let allLists = subject.fetchLists()
        let databaseList = allLists.first

        XCTAssertNotNil(databaseList)

        subject.delete(listEntity: databaseList!)

        let allLists2 = subject.fetchLists()
        XCTAssertEqual(allLists2.count, 0)

        //Ensure todos associated with the deleted list also delete.
        let allTodos = mockTodoRepository.fetchAllTodos()
        XCTAssertEqual(allTodos.count, 0)
    }

    /// Ensures the repository `update` method successfully updates the list in the database.
    func testUpdate() {
        let misspelledListName = "Grocerrrrries"
        subject.add(name: misspelledListName)

        let allLists = subject.fetchLists()
        let databaseList = allLists.first

        XCTAssertNotNil(databaseList)
        XCTAssertEqual(databaseList?.name, misspelledListName)

        let desiredListName = "Groceries"
        let updatedList = subject.update(name: desiredListName, listEntity: databaseList!)

        let allLists2 = subject.fetchLists()
        XCTAssertEqual(allLists2.count, 1)
        XCTAssertEqual(allLists2.first, updatedList)
    }
}
