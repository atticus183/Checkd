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

    /// Ensures the parent coordinator is nil.
    /// The top level `Coordinator` should not have a parent.
    func testParentCoordinator() {
        XCTAssertNil(subject.parentCoordinator)
    }

    /// Ensures the `AppCoordinator`s root view controller is of a type `UISplitViewController`.
    func testRootViewController() {
        XCTAssertTrue(subject.rootViewController is UISplitViewController)
    }

    /// Ensures the window is set during initialization.
    func testWindow() {
        XCTAssertNotNil(subject.window)
    }

    /// Ensures the window's root view controller is the AppCoordinator's root view controller.
    func testWindow_RootViewController() {
        subject.start()
        XCTAssertIdentical(subject.window.rootViewController, subject.rootViewController)
    }
}
