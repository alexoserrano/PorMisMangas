//
//  SwiftDataModels.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 25/02/26.
//

import SwiftData
import Foundation

@Model
final class ProfileModel {
    @Attribute(.unique) var id: UUID
    var userName: String
    var favoriteMangaID: Int?
    var createdAt: Date
    var updatedAt: Date
    
    @Relationship(deleteRule: .cascade) var favoriteMangas: [FavoriteMangaModel]
    @Relationship(deleteRule: .cascade) var ownedVolumes: [MangaCollectionModel]
    
    init(userName: String = "", favoriteMangaID: Int? = nil) {
        self.id = UUID()
        self.userName = userName
        self.favoriteMangaID = favoriteMangaID
        self.createdAt = Date()
        self.updatedAt = Date()
        self.favoriteMangas = []
        self.ownedVolumes = []
    }
}

@Model
final class FavoriteMangaModel {
    @Attribute(.unique) var mangaID: Int
    var title: String
    var titleEnglish: String?
    var titleJapanese: String?
    var mainPictureURL: String?
    var score: Double
    var volumes: Int?
    var addedAt: Date
    
    init(from manga: Manga) {
        self.mangaID = manga.id
        self.title = manga.title
        self.titleEnglish = manga.titleEnglish
        self.titleJapanese = manga.titleJapanese
        self.mainPictureURL = manga.mainPicture?.absoluteString
        self.score = manga.score
        self.volumes = manga.volumes
        self.addedAt = Date()
    }
    
    func toManga() -> Manga {
        Manga(
            id: mangaID,
            title: title,
            titleEnglish: titleEnglish,
            titleJapanese: titleJapanese,
            url: nil,
            mainPicture: mainPictureURL != nil ? URL(string: mainPictureURL!) : nil,
            sypnosis: nil,
            score: score,
            status: .unknown,
            startDate: "",
            endDate: nil,
            volumes: volumes,
            chapters: nil,
            background: nil,
            authors: [],
            genres: [],
            themes: [],
            demographics: []
        )
    }
}

@Model
final class MangaCollectionModel {
    @Attribute(.unique) var mangaID: Int
    var volumesOwned: Int
    var currentlyReading: Int
    var totalVolumes: Int
    var updatedAt: Date
    
    init(mangaID: Int, volumesOwned: Int, currentlyReading: Int, totalVolumes: Int) {
        self.mangaID = mangaID
        self.volumesOwned = volumesOwned
        self.currentlyReading = currentlyReading
        self.totalVolumes = totalVolumes
        self.updatedAt = Date()
    }
    
    @MainActor func toMangaCollection() -> MangaCollection {
        MangaCollection(
            volumesOwned: volumesOwned,
            currentlyReading: currentlyReading,
            totalVolumes: totalVolumes
        )
    }
}
