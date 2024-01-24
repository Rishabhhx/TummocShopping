//
//  TummocShoppingApp.swift
//  TummocShopping
//
//  Created by Rishabh Sharma(Personal) on 24/01/24.
//

import SwiftUI

@main
struct TummocShoppingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
