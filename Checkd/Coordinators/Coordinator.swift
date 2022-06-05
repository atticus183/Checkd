//
//  Coordinator.swift
//  Checkd
//
//  Created by Josh R on 6/4/22.
//

import UIKit

protocol Coordinator: AnyObject {
    /// The parent coordinator of this conforming `Coordinator`.
    var parentCoordinator: Coordinator? { get set }

    /// The root view controller of a `Coordinator`.
    var rootViewController: UINavigationController { get }

    /// A method to dismiss the presented view controller.
    func dismiss()

    /// A method to navigate back to the previous screen in the same hierarchy.
    func navigateBack()
}

extension Coordinator {
    func dismiss() {
        rootViewController.presentedViewController?.dismiss(animated: true)
    }

    func navigateBack() {
        rootViewController.popViewController(animated: true)
    }
}
