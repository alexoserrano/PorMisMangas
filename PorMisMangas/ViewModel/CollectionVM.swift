//
//  CollectionVM.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 17/02/26.
//

import Foundation

@Observable
final class CollectionVM {
    
    var favoriteMangas: [Int: Manga] = [:] {
        didSet {
            saveFavorites()
        }
    }
    
    private var dataManager: DataManager?

    func configure(with dataManager: DataManager) {
        self.dataManager = dataManager
        loadFavorites()
    }
    
    private func loadFavorites() {
        guard let dataManager = dataManager else { return }
        
        let savedMangas = dataManager.loadFavorites()
        favoriteMangas = Dictionary(uniqueKeysWithValues: savedMangas.map { ($0.id, $0) })
        print("Cargué \(savedMangas.count) Favoritos de SwiftData")
    }
    
    private func saveFavorites() {
        guard let dataManager = dataManager else { return }
        let mangas = Array(favoriteMangas.values)
        dataManager.saveFavorites(mangas)
        print("Guardé \(mangas.count) Favoritos en SwiftData")
    }
    
    func saveFavorite(_ manga: Manga) {
        if favoriteMangas[manga.id] != nil {
            favoriteMangas.removeValue(forKey: manga.id)
        } else {
            favoriteMangas[manga.id] = manga
        }
    }
    
    func isFavorite(_ mangaID: Int) -> Bool {
        favoriteMangas[mangaID] != nil
    }
    
    func favoritesCount() -> Int {
        favoriteMangas.count
    }
    
    func getFavorites() -> [Manga] {
        Array(favoriteMangas.values).sorted { $0.title < $1.title }
    }
}
