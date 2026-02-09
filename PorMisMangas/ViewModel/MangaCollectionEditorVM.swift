//
//  MangaCollectionEditorVM.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 17/02/26.
//

import Foundation

@Observable
class MangaCollectionEditorVM {
    
    private let profileVM: ProfileVM
    let manga: Manga
    var selectedVolumesOwned: Int = 0
    var selectedCurrentlyReading: Int = 0
    
    var maxVolumes: Int {
        manga.volumes ?? 999
    }
    
    init(profileVM: ProfileVM, manga: Manga) {
        self.profileVM = profileVM
        self.manga = manga
    }
    
    func loadCollection() {
        selectedVolumesOwned = profileVM.getVolumesOwned(for: manga.id)
        selectedCurrentlyReading = profileVM.getCurrentlyReading(for: manga.id)
    }
    
    func saveCollection() {
        profileVM.setVolumesOwned(selectedVolumesOwned, for: manga)
        profileVM.setCurrentlyReading(selectedCurrentlyReading, for: manga.id)
    }
}
