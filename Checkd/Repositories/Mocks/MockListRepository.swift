//
//  MockListRepository.swift
//  CheckdTests
//
//  Created by Josh R on 6/5/22.
//

@testable import Checkd
import Foundation

final class MockListRepository: DefaultListRepository {
    override init(coreDataStack: CoreDataStack = .init(inMemory: true)) {
        super.init(coreDataStack: coreDataStack)
    }
}
