//
//  CortexApp.swift
//  Cortex
//
//  Created by Nomura Rentaro on 2021/12/28.
//

import SwiftUI

@main
struct CortexApp: App {
    let persistenceController = PersistenceController.shared    // create instance

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)   //register NSManagedObjectContext to Env variable
        }
    }
}
