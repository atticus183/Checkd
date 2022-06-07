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
    /// - Parameter list: The list to delete.
    func deleteList(list: ListEntity) {
        listRepository.delete(listEntity: list, in: &lists)
    }

    /// A method to fetch all lists from the repository.
    func fetchLists() {
        lists = listRepository.fetchLists()
    }

    /// A method to reorder a list.
    /// - Parameters:
    ///   - indexSet: The indexSet passed from the view's onMove action.
    ///   - destination: The destination index of the list.
    func moveList(from indexSet: IndexSet, to destination: Int) {
        listRepository.moveList(from: indexSet, to: destination, lists: &lists)
    }
}
