//
//  TodoEntity.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import CoreData

extension TodoEntity {

    /// A `NSFetchRequest` to retrieve `TodoEntity`s.
    /// - Parameter list: A list to filter the request.
    /// - Returns: A `NSFetchRequest` of type `TodoEntity`.
    static func request(in list: ListEntity?) -> NSFetchRequest<TodoEntity> {
        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        if let list = list {
            let predicate = NSPredicate(format: "list == %@", list)
            request.predicate = predicate
        }
        let sort = NSSortDescriptor(key: #keyPath(TodoEntity.dateCreated), ascending: false)
        request.sortDescriptors = [sort]
        return request
    }
}

extension TodoEntity {

    /// The date created represented as a string in the format MM-DD-YYYY.
    var dateCreatedString: String {
        dateFormatter.string(from: self.dateCreated ?? Date())
    }

    /// The `DateFormatter` for a `TodoEntity`.
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }

    /// Toggles the completion state of a `TodoEntity`.
    func toggleIsDone() {
        self.isCompleted.toggle()
    }
}
