//
//  CreateListViewViewModelTests.swift
//  CheckdTests
//
//  Created by Josh R on 6/5/22.
//

import XCTest

@testable import Checkd

class CreateListViewViewModelTests: XCTestCase {
    var mockRepository: MockListRepository!
    var subject: CreateListViewViewModel!

    override func setUp() {
        super.setUp()

        mockRepository = MockListRepository()
        subject = CreateListViewViewModel(listRepository: mockRepository)
    }

    override func tearDown() {
        super.tearDown()
        subject = nil
    }

    /// Ensures the view model adds the list via the repository `add` method.
    func testAddList() {
        subject.desiredListName = "Shopping"
        subject.saveList()

        let lists = mockRepository.fetchLists()

        XCTAssertEqual(lists.count, 1)
    }

    /// Ensures the `CoreDataStack` is in memory.
    func testCoreDataStack() {
        XCTAssertTrue(subject.listRepository.coreDataStack.inMemory)
    }
}
