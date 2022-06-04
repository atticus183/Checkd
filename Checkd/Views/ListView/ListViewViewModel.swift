//
//  ListViewViewModel.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import Combine
import SwiftUI

@MainActor
final class ListViewViewModel: ObservableObject {
    @Published var lists: [ListEntity] = []

    private var cancellables: Set<AnyCancellable> = []

    let listRepository: ListRepository

    init(listRepository: ListRepository = DefaultListRepository()) {
        self.listRepository = listRepository

        fetchLists()

        listRepository.repositoryHasChanges
            .sink(receiveCompletion: { _ in }) { [weak self] hasChanges in
            self?.fetchLists()
        }.store(in: &cancellables)
    }

    func addList(name: String) {
        listRepository.add(name: name)
    }

    func deleteList(at indexSet: IndexSet) {
        for index in indexSet {
            let list = lists[index]
            listRepository.delete(listEntity: list)
        }
    }

    func fetchLists() {
        lists = listRepository.fetchLists()
    }

    func moveList(from indexSet: IndexSet, to destIndex: Int) {
        guard let fromIndex = indexSet.last, lists.count > destIndex else { return }
        let listBeingMoved = lists[fromIndex]
        listRepository.move(list: listBeingMoved, to: destIndex, lists: lists)
    }
}
