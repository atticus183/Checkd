//
//  CreateListViewViewModel.swift
//  Checkd
//
//  Created by Josh R on 6/4/22.
//

import Combine
import SwiftUI

@MainActor
final class CreateListViewViewModel: ObservableObject {
    @Published var desiredListName: String = ""

    private let listRepository: ListRepository

    init(listRepository: ListRepository = DefaultListRepository()) {
        self.listRepository = listRepository
    }

    func addList() {
        listRepository.add(name: desiredListName)
    }
}
