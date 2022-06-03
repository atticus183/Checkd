//
//  CheckdApp.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import SwiftUI

@main
struct CheckdApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
