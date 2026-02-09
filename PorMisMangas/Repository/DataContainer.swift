//
//  DataContainer.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 26/02/26.
//

import SwiftData
import Foundation

@MainActor
final class DataContainer: Observable {
    
    let modelContainer: ModelContainer
    private let dataManager: DataManager
    let mangasVM: MangasVM
    let collectionVM: CollectionVM
    let profileVM: ProfileVM
    let filterVM: FilterVM
    
    init() {
        do {
            modelContainer = try ModelContainer(
                for: ProfileModel.self,
                    FavoriteMangaModel.self,
                    MangaCollectionModel.self
            )
            print("ModelContainer initialized")
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
        dataManager = DataManager(modelContext: modelContainer.mainContext)
        mangasVM = MangasVM()
        collectionVM = CollectionVM()
        profileVM = ProfileVM()
        filterVM = FilterVM()
        
        configureViewModels()
    }
    
    private func configureViewModels() {
        print("Configuring ViewModels with SwiftData...")
        profileVM.configure(with: dataManager)
        print("ProfileVM configured")
        collectionVM.configure(with: dataManager)
        print("CollectionVM configured")
        print("All ViewModels configured successfully")
    }
}
