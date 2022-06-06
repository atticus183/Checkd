//
//  CreateListViewViewModel.swift
//  Checkd
//
//  Created by Josh R on 6/4/22.
//

import Combine
import SwiftUI

/// The view model for a `CreateListView`.
final class CreateListViewViewModel: ObservableObject {
    @Published var desiredListName: String = ""

    /// The `Coordinator` for the view model.
    weak var coordinator: AppCoordinator?

    /// A `Boolean` indicating a list was sent to make edits.
    var isListBeingEdited: Bool { listBeingEdited != nil }

    /// A `ListEntity` sent to make edits.
    var listBeingEdited: ListEntity?

    /// The `Repository` for the view model.
    private(set) var listRepository: ListRepository

    init(listRepository: ListRepository = DefaultListRepository(), list: ListEntity? = nil) {
        self.listRepository = listRepository
        self.listBeingEdited = list

        desiredListName = listBeingEdited?.name ?? ""
    }

    /// A method to add a list via the repository `add` method.
    func saveList() {
        guard !desiredListName.isEmpty else { return }
        if let listBeingEdited = listBeingEdited {
            listRepository.update(name: desiredListName, listEntity: listBeingEdited)
        } else {
            listRepository.add(name: desiredListName.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        coordinator?.dismiss()
    }
}
