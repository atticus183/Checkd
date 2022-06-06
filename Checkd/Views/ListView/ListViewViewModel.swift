//
//  ListViewViewModel.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import Combine
import SwiftUI

/// The view model for a `ListView`.
final class ListViewViewModel: ObservableObject {
    @Published var lists: [ListEntity] = []

    private var cancellables: Set<AnyCancellable> = []

    /// The `Coordinator` for the view model.
    weak var coordinator: AppCoordinator?

    /// The `Repository` for the view model.
    private(set) var listRepository: ListRepository

    init(listRepository: ListRepository = DefaultListRepository()) {
        self.listRepository = listRepository

        listRepository.repositoryHasChanges
            .sink(receiveCompletion: { _ in }) { [weak self] hasChanges in
            self?.fetchLists()
        }.store(in: &cancellables)
    }

    /// A method to delete a `ListEntity`.
    func deleteList(at indexSet: IndexSet) {
        for index in indexSet {
            let list = lists[index]
            listRepository.delete(listEntity: list)
        }
    }

    /// A method to fetch all lists from the repository.
    func fetchLists() {
        lists = listRepository.fetchLists()
    }

    /// A method to reorder a list.
    func moveList(from indexSet: IndexSet, to destIndex: Int) {
        guard let fromIndex = indexSet.last, lists.count > destIndex else { return }
        let listBeingMoved = lists[fromIndex]
        listRepository.move(list: listBeingMoved, to: destIndex, lists: lists)
    }
}