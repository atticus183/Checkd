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

    /// The `Repository` for the view model.
    private(set) var listRepository: ListRepository

    init(listRepository: ListRepository = DefaultListRepository()) {
        self.listRepository = listRepository
    }

    /// A method to add a list via the repository `add` method.
    func addList() {
        guard !desiredListName.isEmpty else { return }
        listRepository.add(name: desiredListName.trimmingCharacters(in: .whitespacesAndNewlines))
        coordinator?.dismiss()
    }
}
