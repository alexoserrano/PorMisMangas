//
//  PorMisMangasApp.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 08/02/26.
//

import SwiftUI
import SwiftData

@main
struct PorMisMangasApp: App {
    
    @State private var dataContainer = DataContainer()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(dataContainer.mangasVM)
                .environment(dataContainer.collectionVM)
                .environment(dataContainer.profileVM)
                .environment(dataContainer.filterVM)
        }
        .modelContainer(dataContainer.modelContainer)
    }
}
