//
//  TodoEntity.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import CoreData

extension TodoEntity {
    static func request() -> NSFetchRequest<TodoEntity> {
        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(TodoEntity.dateCreated), ascending: false)
        request.sortDescriptors = [sort]
        return request
    }
}
