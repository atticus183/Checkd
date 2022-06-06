//
//  ListViewViewModelTests.swift
//  CheckdTests
//
//  Created by Josh R on 6/5/22.
//

import XCTest

@testable import Checkd

class ListViewViewModelTests: XCTestCase {
    var mockRepository: MockListRepository!
    var subject: ListViewViewModel!

    override func setUp() {
        super.setUp()

        mockRepository = MockListRepository()
        subject = ListViewViewModel(listRepository: mockRepository)
    }

    override func tearDown() {
        super.tearDown()
        subject = nil
    }

    func testCoreDataStack() {
        XCTAssertTrue(subject.listRepository.coreDataStack.inMemory)
    }

    func testDeleteList() {
        let shoppingList = mockRepository.add(name: "Shopping")
        let lists = mockRepository.fetchLists()
        XCTAssertEqual(lists.count, 1)

        let index = lists.firstIndex(where: { $0 === shoppingList })!
        let indexSet = IndexSet(integer: index)
        subject.deleteList(at: indexSet)

        let lists2 = mockRepository.fetchLists()
        XCTAssertEqual(lists2.count, 0)
    }

    func testFetchLists() {
        let emptyLists = mockRepository.fetchLists()
        XCTAssertEqual(emptyLists.count, 0)

        mockRepository.add(name: "Shopping")
        subject.fetchLists()
        XCTAssertEqual(subject.lists.count, 1)
    }

    func testMoveList() {
        let list1 = mockRepository.add(name: "Shopping")
        list1.sortIndex = 0
        let list2 = mockRepository.add(name: "Kids")
        list2.sortIndex = 1
        let list3 = mockRepository.add(name: "Bills")
        list3.sortIndex = 2
        let list4 = mockRepository.add(name: "Today")
        list4.sortIndex = 3
        let list5 = mockRepository.add(name: "Car")
        list5.sortIndex = 4

        subject.fetchLists()
        XCTAssertEqual(subject.lists.count, 5)

        let index = subject.lists.firstIndex(where: { $0 === list5 })!
        let origIndexSet = IndexSet(integer: index)
        subject.moveList(from: origIndexSet, to: 0)

        subject.fetchLists()
        let movedList = subject.lists.first(where: { $0.name == "Car" })
        XCTAssertEqual(movedList?.sortIndex, 0)

        //Ensure initial first item is now second
        let movedList2 = subject.lists.first(where: { $0.name == "Shopping" })
        XCTAssertEqual(movedList2?.sortIndex, 1)
    }
}
