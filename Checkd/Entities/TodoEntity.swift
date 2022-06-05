//
//  TodoEntity.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import CoreData

extension TodoEntity {
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
    var dateCreatedString: String {
        dateFormatter.string(from: self.dateCreated ?? Date())
    }

    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }

    func toggleIsDone() {
        self.isCompleted.toggle()
    }
}
