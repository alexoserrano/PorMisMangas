//
//  ProfileVM.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 17/02/26.
//

import SwiftUI

@Observable
final class ProfileVM {
    var profile: Profile {
        didSet {
            saveProfile()  // Guardar automáticamente cuando cambie
        }
    }
    
    private var dataManager: DataManager?
    
    init(profile: Profile = Profile()) {
        self.profile = profile
    }
    
    func configure(with dataManager: DataManager) {
        self.dataManager = dataManager
        loadProfile()
    }
    
    private func loadProfile() {
        guard let dataManager = dataManager else { return }
        
        if let savedProfile = dataManager.loadProfile() {
            self.profile = savedProfile
            print("Perfil cargado desde SwiftData")
        } else {
            print("No hay perfiles guardados, usar default")
        }
    }
    
    private func saveProfile() {
        guard let dataManager = dataManager else { return }
        dataManager.saveProfile(profile)
        print("Perfil Salvado")
    }
    
    func getFavoriteManga(from mangas: [Manga]) -> Manga? {
        guard let mangaID = profile.favoriteMangaID else { return nil }
        return mangas.first(where: { $0.id == mangaID })
    }
    
    func selectFavoriteManga(_ manga: Manga) {
        profile.favoriteMangaID = manga.id
    }
    
    func deselectFavoriteManga() {
        profile.favoriteMangaID = nil
    }
    
    func getCollection(for mangaID: Int) -> MangaCollection? {
        profile.ownedVolumes[mangaID]
    }
    
    func setVolumesOwned(_ count: Int, for manga: Manga) {
        if var collection = profile.ownedVolumes[manga.id] {
            collection.volumesOwned = min(count, collection.totalVolumes)
            if collection.currentlyReading > collection.volumesOwned {
                collection.currentlyReading = collection.volumesOwned
            }
            profile.ownedVolumes[manga.id] = collection
        } else {
            let totalVolumes = manga.volumes ?? 999 // Si no tiene volumes, usar 999 como máximo
            profile.ownedVolumes[manga.id] = MangaCollection(
                volumesOwned: min(count, totalVolumes),
                currentlyReading: 0,
                totalVolumes: totalVolumes
            )
        }
        
        if let collection = profile.ownedVolumes[manga.id] {
            dataManager?.saveMangaCollection(manga.id, collection: collection)
        }
    }
    
    func setCurrentlyReading(_ volume: Int, for mangaID: Int) {
        if var collection = profile.ownedVolumes[mangaID] {
            collection.currentlyReading = min(volume, collection.volumesOwned)
            profile.ownedVolumes[mangaID] = collection
            dataManager?.saveMangaCollection(mangaID, collection: collection)
        }
    }
    
    func getVolumesOwned(for mangaID: Int) -> Int {
        profile.ownedVolumes[mangaID]?.volumesOwned ?? 0
    }
    
    func getCurrentlyReading(for mangaID: Int) -> Int {
        profile.ownedVolumes[mangaID]?.currentlyReading ?? 0
    }
    
    func hasInCollection(_ mangaID: Int) -> Bool {
        profile.ownedVolumes[mangaID] != nil
    }
    
    func removeFromCollection(_ mangaID: Int) {
        profile.ownedVolumes.removeValue(forKey: mangaID)
        dataManager?.deleteMangaCollection(mangaID)
    }
    
}
