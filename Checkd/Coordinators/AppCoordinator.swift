//
//  AppCoordinator.swift
//  Checkd
//
//  Created by Josh R on 6/4/22.
//

import SwiftUI

/// The top-level coordinator of the application.
final class AppCoordinator: Coordinator {
    /// This `Coordinator` is the root of the application.
    /// A parent coordinator should always be marked with `weak`.
    weak var parentCoordinator: Coordinator? = nil

    let rootViewController: UINavigationController = {
        let nav = UINavigationController()
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }()

    /// The `UIWindow` passed from `AppDelegate`.
    private(set) var window: UIWindow!

    /// Initializes a concrete `Coordinator`.
    /// - Parameter window: The window of the application.
    init(window: UIWindow?) {
        self.window = window
    }

    /// The coordinator method that starts the application.
    func start() {
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        let viewModel = ListViewViewModel()
        viewModel.coordinator = self
        let view = ListView(viewModel: viewModel)
        view.viewModel.coordinator = self
        let hostingController = UIHostingController(rootView: view)
        hostingController.title = "Lists"
        rootViewController.setViewControllers([hostingController], animated: true)
    }

    /// A coordinator method to navigate to a `CreateListView`.
    func goToCreateListView() {
        let viewModel = CreateListViewViewModel()
        viewModel.coordinator = self
        let view = CreateListView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        rootViewController.present(hostingController, animated: true)
    }

    /// A coordinator method to navigate to a `TodoListView`.
    func goToTodoListView(list: ListEntity) {
        let viewModel = TodoListViewViewModel(list: list)
        viewModel.coordinator = self
        let view = TodoListView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        hostingController.title = list.name ?? "Todo"
        rootViewController.pushViewController(hostingController, animated: true)
    }

}
