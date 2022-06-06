//
//  AppCoordinatorTests.swift
//  CheckdTests
//
//  Created by Josh R on 6/5/22.
//

import XCTest

@testable import Checkd

class AppCoordinatorTests: XCTestCase {
    var subject: AppCoordinator!

    override func setUp() {
        super.setUp()

        let window = UIWindow(frame: .zero)
        subject = AppCoordinator(window: window)
    }

    override func tearDown() {
        super.tearDown()
        subject = nil
    }

    func testParentCoordinator() {
        XCTAssertNil(subject.parentCoordinator)
    }

    func testRootViewController() {
        XCTAssertTrue(subject.rootViewController is UISplitViewController)
    }

    func testWindow() {
        XCTAssertNotNil(subject.window)
    }

    func testWindow_RootViewController() {
        subject.start()
        XCTAssertIdentical(subject.window.rootViewController, subject.rootViewController)
    }
}
