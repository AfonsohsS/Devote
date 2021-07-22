//
//  DevoteApp.swift
//  Devote
//
//  Created by Afonso Sabino on 04/07/21.
//

import SwiftUI

@main
struct DevoteApp: App {
    
    // MARK: - PROPERTIES
    
    let persistenceController = PersistenceController.shared
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
//    @Environment(\.colorScheme) var colorScheme

    // MARK: - BODY
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
