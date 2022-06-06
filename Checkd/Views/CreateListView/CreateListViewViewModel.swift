//
//  CreateListViewViewModel.swift
//  Checkd
//
//  Created by Josh R on 6/4/22.
//

import Combine
import SwiftUI

final class CreateListViewViewModel: ObservableObject {
    @Published var desiredListName: String = ""

    weak var coordinator: AppCoordinator?

    private(set) var listRepository: ListRepository

    init(listRepository: ListRepository = DefaultListRepository()) {
        self.listRepository = listRepository
    }

    func addList() {
        guard !desiredListName.isEmpty else { return }
        listRepository.add(name: desiredListName.trimmingCharacters(in: .whitespacesAndNewlines))
        coordinator?.dismiss()
    }
}
