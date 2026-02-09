//
//  url.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 10/02/26.
//

import Foundation

let apiList = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com/list")!
let apiSearch = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com/search")!

extension URL {
    static let getMangas = apiList.appending(path: "mangas")
    
    static func getMangas(page: Int, per: Int) -> URL {
        var components = URLComponents(url: getMangas, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per", value: "\(per)")
        ]
        return components.url!
    }
    
    //Evaluar si para la funcionalidad basica requerida se requieren todos los métodos, ya que con el uso del POST /search/manga se puede cumplir con la funcionalidad
    static let getBestMangas = apiList.appending(path: "bestMangas")
    static let getAuthors = apiList.appending(path: "authors")
    static let getDemographics = apiList.appending(path: "demographics")
    static let getGenres = apiList.appending(path: "genres")
    static let getThemes = apiList.appending(path: "themes")
    static let getMangasByGenre = apiList.appending(path: "mangaByGenre")
    static func getMangasByGenre(genre: String) -> URL {
        getMangasByGenre.appending(path: "\(genre)")
    }
    static let getMangasByDemographic = apiList.appending(path: "mangaByDemographic")
    static func getMangasByDemographic(demographic: String) -> URL {
        getMangasByDemographic.appending(path: "\(demographic)")
    }
    static let getMangasByTheme = apiList.appending(path: "mangabyTheme")
    static func getMangasByTheme(theme: String) -> URL {
        getMangasByTheme.appending(path: "\(theme)")
    }
    static let getMangasByAuthor = apiList.appending(path: "mangaByAuthor")
    static func getMangasByAuthor(author: String) -> URL {
        getMangasByAuthor.appending(path: "\(author)")
    }
    static let searchMangasBeginsWith = apiSearch.appending(path: "mangasBeginsWith")
    static func searchMangasBeginsWith(beginsWord: String) -> URL {
        searchMangasBeginsWith.appending(path: "\(beginsWord)")
    }
    static let searchMangasContains = apiSearch.appending(path: "mangasContains")
    static func searchMangasContains(containsWord: String) -> URL {
        searchMangasContains.appending(path: "\(containsWord)")
    }
    static let searchAuthors = apiSearch.appending(path: "author")
    static func searchAuthors(author: String) -> URL {
        searchAuthors.appending(path: "\(author)")
    }
    static let searchMangaById = apiSearch.appending(path: "manga")
    static func searchMangaById(id: Int) -> URL {
        searchMangaById.appending(path: "\(id)")
    }
    static let postSearchMangas = apiSearch.appending(path: "manga")
    
    static func postSearchMangas(page: Int, per: Int) -> URL {
        var components = URLComponents(url: postSearchMangas, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per", value: "\(per)")
        ]
        return components.url!
    }
}

/*
import Playgrounds
 
#Playground {
    print(URL.getMangas.absoluteString)
    print(URL.getBestMangas.absoluteString)
    print(URL.getAuthors.absoluteString)
    print(URL.getDemographics.absoluteString)
    print(URL.getGenres.absoluteString)
    print(URL.getThemes.absoluteString)
    print(URL.getMangasByGenre(genre: "Avant Garde"))
    print(URL.getMangasByDemographic(demographic: "Seinen"))
    print(URL.getMangasByTheme(theme: "Military"))
    print(URL.getMangasByAuthor(author: "38FF9615-C176-4053-B786-9A40D3AE680B"))
    print(URL.searchMangasBeginsWith(beginsWord: "dragon ball"))
    print(URL.searchMangasContains(containsWord: "ball"))
    print(URL.searchAuthors(author: "toriya"))
    print(URL.searchMangaById(id: 42))
}
*/
