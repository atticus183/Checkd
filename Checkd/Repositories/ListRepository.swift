//
//  ListRepository.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import Foundation

protocol ListRepository: Repository {
    @discardableResult func add(name: String) -> ListEntity
    func delete(listEntity: ListEntity)
    @discardableResult func update(name: String, listEntity: ListEntity) -> ListEntity
}

final class DefaultListRepository: ListRepository {
    private(set) var coreDataStack: CoreDataStack = .shared

    func add(name: String) -> ListEntity {
        let list = ListEntity(context: coreDataStack.viewContext)
        list.id = UUID()
        list.name = name
        return list
    }

    func delete(listEntity: ListEntity) {
        coreDataStack.viewContext.delete(listEntity)
    }

    func search(with searchText: String) {
        return
    }

    func update(name: String, listEntity: ListEntity) -> ListEntity {
        listEntity.name = name
        return listEntity
    }

}
