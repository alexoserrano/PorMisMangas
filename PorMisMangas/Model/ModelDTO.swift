//
//  ModelDTO.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 08/02/26.
//

import Foundation

struct MangasDTO: Codable {
    let items: [MangaDTO]
    let metadata: MetadataDTO
}

struct MangaDTO: Codable {
    let id: Int
    let title: String
    let titleEnglish: String?
    let titleJapanese: String?
    let url: String //Se declara como String y se convertirá a URL por el tipo de formato que se recibe con "" y con \
    let mainPicture: String? //De la misma forma todas las URL por venir formateadas del JSON se declararán como String en el DTO
    let sypnosis: String?
    let score: Double
    let status: String
    let startDate: String?
    let endDate: String?
    let volumes: Int?
    let chapters: Int?
    let background: String?
    let authors: [AuthorDTO]
    let genres: [GenreDTO]
    let themes: [ThemeDTO]
    let demographics: [DemographicDTO]
    
    struct AuthorDTO: Codable {
        let id: UUID
        let firstName: String
        let lastName: String
        let role: String
    }
    
    struct GenreDTO: Codable {
        let id: UUID
        let genre: String
    }
    
    struct ThemeDTO: Codable {
        let id: UUID
        let theme: String
    }
    
    struct DemographicDTO: Codable {
        let id: UUID
        let demographic: String
    }
}

struct MetadataDTO: Codable {
    let per: Int
    let page: Int
    let total: Int
}

struct CustomSearch: Codable {
    var searchTitle: String?
    var searchAuthorFirstName: String?
    var searchAuthorLastName: String?
    var searchGenres: [String]?
    var searchThemes: [String]?
    var searchDemographics: [String]?
    var searchContains: Bool
}

extension MangaDTO {
    var toManga: Manga {
        Manga(
            id: id,
            title: title,
            titleEnglish: titleEnglish,
            titleJapanese: titleJapanese,
            url: url.cleanedURL, //Cambio a URL limpia
            mainPicture: mainPicture?.cleanedURL,
            sypnosis: sypnosis,
            score: score,
            status: Manga.Status(rawValue: status) ?? .unknown,
            startDate: startDate ?? "",
            endDate: endDate ?? "",
            volumes: volumes,
            chapters: chapters,
            background: background,
            authors: authors.map { Manga.Author(id: $0.id, firstName: $0.firstName, lastName: $0.lastName, role: Manga.Role(rawValue: $0.role) ?? .unknown) },
            genres: genres.map { Manga.Genre(id: $0.id, genre: Manga.GenreEnum(rawValue: $0.genre) ?? .unknown) },
            themes: themes.map { Manga.Theme(id: $0.id, theme: Manga.ThemeEnum(rawValue: $0.theme) ?? .unknown) },
            demographics: demographics.map { Manga.Demographic(id: $0.id, demographic: Manga.DemographicEnum(rawValue: $0.demographic) ?? .unknown) }
        )
    }
}

extension MangasDTO {
    var toMangas: Mangas {
        Mangas(
            items: items.map { $0.toManga },
            metadata: Metadata(per: metadata.per, page: metadata.page, total: metadata.total)
        )
    }
}

extension String {  //Para limpiar los atributos del JSON que traen URL con "\"
    var cleanedURL: URL? {
        let cleaned = self.trimmingCharacters(in: CharacterSet(charactersIn: "\\\""))
        return URL(string: cleaned) //Aqui se manejan los casos en donde venga el atributo vacío y por lo tanto devolverá nil
    }
}
