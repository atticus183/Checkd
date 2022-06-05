//
//  Coordinator.swift
//  Checkd
//
//  Created by Josh R on 6/4/22.
//

import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }

    var rootViewController: UINavigationController { get }

    func navigateBack()
}

extension Coordinator {
    func navigateBack() {
        rootViewController.popViewController(animated: true)
    }
}
