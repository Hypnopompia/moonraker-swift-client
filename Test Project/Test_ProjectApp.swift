//
//  Test_ProjectApp.swift
//  Test Project
//
//  Created by TJ Hunter on 1/24/23.
//

import SwiftUI

@main
struct Test_ProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
