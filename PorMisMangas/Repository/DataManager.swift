//
//  DataManager.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 25/02/26.
//

import SwiftData
import Foundation

@Observable
final class DataManager {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func saveProfile(_ profile: Profile) {  //Profile
        let descriptor = FetchDescriptor<ProfileModel>()
        
        do {
            let profiles = try modelContext.fetch(descriptor)
            
            if let existingProfile = profiles.first {
                // Actualizar perfil existente
                existingProfile.userName = profile.userName
                existingProfile.favoriteMangaID = profile.favoriteMangaID
                existingProfile.updatedAt = Date()
            } else {
                // Crear nuevo perfil
                let newProfile = ProfileModel(
                    userName: profile.userName,
                    favoriteMangaID: profile.favoriteMangaID
                )
                modelContext.insert(newProfile)
            }
            
            try modelContext.save()
        } catch {
            print("Error al guardar el perfil: \(error)")
        }
    }
    
    func loadProfile() -> Profile? {
        let descriptor = FetchDescriptor<ProfileModel>()
        
        do {
            let profiles = try modelContext.fetch(descriptor)
            guard let profileModel = profiles.first else { return nil }
            
            // Cargar ownedVolumes desde SwiftData
            let volumesDescriptor = FetchDescriptor<MangaCollectionModel>()
            let volumes = try modelContext.fetch(volumesDescriptor)
            
            let ownedVolumes = Dictionary(uniqueKeysWithValues:
                volumes.map { ($0.mangaID, $0.toMangaCollection()) }
            )
            
            return Profile(
                userName: profileModel.userName,
                favoriteMangaID: profileModel.favoriteMangaID,
                ownedVolumes: ownedVolumes
            )
        } catch {
            print("Error al cargar el perfil: \(error)")
            return nil
        }
    }
    
    func saveFavorites(_ mangas: [Manga]) { //Collection
        do {
            // Eliminar favoritos antiguos
            let descriptor = FetchDescriptor<FavoriteMangaModel>()
            let existingFavorites = try modelContext.fetch(descriptor)
            existingFavorites.forEach { modelContext.delete($0) }
            
            // Insertar nuevos favoritos
            mangas.forEach { manga in
                let favoriteModel = FavoriteMangaModel(from: manga)
                modelContext.insert(favoriteModel)
            }
            
            try modelContext.save()
        } catch {
            print("Error al guardar favoritos: \(error)")
        }
    }
    
    func loadFavorites() -> [Manga] {
        let descriptor = FetchDescriptor<FavoriteMangaModel>(
            sortBy: [SortDescriptor(\.addedAt, order: .reverse)]
        )
        
        do {
            let favorites = try modelContext.fetch(descriptor)
            return favorites.map { $0.toManga() }
        } catch {
            print("Error al cargar favoritos: \(error)")
            return []
        }
    }
    
    func saveMangaCollection(_ mangaID: Int, collection: MangaCollection) { //Manga y Collection
        let descriptor = FetchDescriptor<MangaCollectionModel>(
            predicate: #Predicate { $0.mangaID == mangaID }
        )
        
        do {
            let existing = try modelContext.fetch(descriptor)
            
            if let existingCollection = existing.first {
                existingCollection.volumesOwned = collection.volumesOwned
                existingCollection.currentlyReading = collection.currentlyReading
                existingCollection.totalVolumes = collection.totalVolumes
                existingCollection.updatedAt = Date()
            } else {
                let newCollection = MangaCollectionModel(
                    mangaID: mangaID,
                    volumesOwned: collection.volumesOwned,
                    currentlyReading: collection.currentlyReading,
                    totalVolumes: collection.totalVolumes
                )
                modelContext.insert(newCollection)
            }
            
            try modelContext.save()
        } catch {
            print("Error al guardar colección de mangas: \(error)")
        }
    }
    
    func loadAllCollections() -> [Int: MangaCollection] {
        let descriptor = FetchDescriptor<MangaCollectionModel>()
        
        do {
            let collections = try modelContext.fetch(descriptor)
            return Dictionary(uniqueKeysWithValues:
                collections.map { ($0.mangaID, $0.toMangaCollection()) }
            )
        } catch {
            print("Error al cargar colección de mangas: \(error)")
            return [:]
        }
    }
    
    func deleteMangaCollection(_ mangaID: Int) {
        let descriptor = FetchDescriptor<MangaCollectionModel>(
            predicate: #Predicate { $0.mangaID == mangaID }
        )
        
        do {
            let collections = try modelContext.fetch(descriptor)
            collections.forEach { modelContext.delete($0) }
            try modelContext.save()
        } catch {
            print("Error borrando colección: \(error)")
        }
    }
}
