//
//  Repository.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import Combine

protocol Repository: AnyObject {
    /// The core data stack for the application.
    var coreDataStack: CoreDataStack { get }

    /// A `PassthroughSubject` that emits a value when the repository has changes.
    var repositoryHasChanges: PassthroughSubject<Bool, Error> { get }
}
