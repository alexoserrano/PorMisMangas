//
//  Profile.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 15/02/26.
//

import Foundation

struct Profile: Hashable, Codable {
        var userName: String
        var favoriteMangaID: Int?
        var ownedVolumes: [Int: MangaCollection] = [:] //Diccionario para guardar los volumenes del perfil
   
    init(userName: String = "", favoriteMangaID: Int? = nil, ownedVolumes: [Int: MangaCollection] = [:]) {
        self.userName = userName
        self.favoriteMangaID = favoriteMangaID
        self.ownedVolumes = ownedVolumes
    }
}

struct MangaCollection: Hashable, Codable {
    var volumesOwned: Int
    var currentlyReading: Int
    var totalVolumes: Int
    
    init(volumesOwned: Int = 0, currentlyReading: Int = 0, totalVolumes: Int) {
        self.volumesOwned = volumesOwned
        self.currentlyReading = currentlyReading
        self.totalVolumes = totalVolumes
    }
}
