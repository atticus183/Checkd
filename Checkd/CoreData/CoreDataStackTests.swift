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

    func testInMemory() {
        XCTAssertTrue(subject.inMemory)
    }

    func testModelName() {
        XCTAssertEqual(subject.modelName, "Checkd")
        XCTAssertEqual(subject.container.name, subject.modelName)
    }
}
