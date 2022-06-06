//
//  CoreDataStackTests.swift
//  CheckdTests
//
//  Created by Josh R on 6/5/22.
//

import XCTest

@testable import Checkd

class CoreDataStackTests: XCTestCase {
    var subject: CoreDataStack!

    override func setUp() {
        super.setUp()

        subject = CoreDataStack(inMemory: true)
    }

    override func tearDown() {
        super.tearDown()
        subject = nil
    }

    /// Ensures the core data store is in memory.
    func testInMemory() {
        XCTAssertTrue(subject.inMemory)
    }

    /// Ensures the core data model name is correct.
    func testModelName() {
        let expectedModelName = "Checkd"
        XCTAssertEqual(subject.modelName, expectedModelName)
        XCTAssertEqual(subject.container.name, subject.modelName)
    }
}
