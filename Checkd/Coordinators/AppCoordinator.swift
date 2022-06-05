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

    var rootViewController: UIViewController {
        splitViewController
    }

    lazy var splitViewController: UISplitViewController = {
        let split = UISplitViewController(style: .doubleColumn)
        split.preferredDisplayMode = .oneBesideSecondary
        split.delegate = self
        return split
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
        let listViewModel = ListViewViewModel()
        listViewModel.coordinator = self
        let listView = ListView(viewModel: listViewModel)
        listView.viewModel.coordinator = self
        let listHostingController = UIHostingController(rootView: listView)
        listHostingController.title = "Lists"

        let todoViewModel = TodoListViewViewModel(list: nil)
        todoViewModel.coordinator = self
        let todoView = TodoListView(viewModel: todoViewModel)
        let todoHostingController = UIHostingController(rootView: todoView)

        splitViewController.setViewController(listHostingController, for: .primary)
        splitViewController.setViewController(todoHostingController, for: .secondary)

        if let nav = splitViewController.viewControllers.first as? UINavigationController {
            nav.navigationBar.prefersLargeTitles = true
            nav.navigationItem.largeTitleDisplayMode = .automatic
        }

        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()
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
        guard let todoListVc = splitViewController.viewController(for: .secondary) as? UIHostingController<TodoListView> else { return }
        todoListVc.rootView.viewModel.list = list
        todoListVc.title = list.name ?? "Todo"
        splitViewController.showDetailViewController(todoListVc, sender: self)
    }
}

// MARK: UISplitViewControllerDelegate

extension AppCoordinator : UISplitViewControllerDelegate {
    //This method shows the master detail FIRST when on iPhone
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
