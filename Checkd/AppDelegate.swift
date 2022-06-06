//
//  AppDelegate.swift
//  Checkd
//
//  Created by Josh R on 6/4/22.
//

import SwiftUI

@main
class AppDelegate: NSObject, UIApplicationDelegate {

    /// The top level `Coordinator` of the app.
    var appCoordinator: AppCoordinator?

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let appCoordinator = AppCoordinator(window: window)
        self.appCoordinator = appCoordinator
        appCoordinator.start()

        return true
    }
}
