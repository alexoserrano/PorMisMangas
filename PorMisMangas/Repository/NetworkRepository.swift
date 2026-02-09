//
//  NetworkRepository.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 10/02/26.
//

import Foundation

protocol NetworkRepository: Sendable, NetworkInteractor {
    func getMangas(page: Int, per: Int) async throws(NetworkError) -> Mangas
    func searchMangaById(id: Int) async throws(NetworkError) -> Manga
    func searchMangasCustom(criteria: CustomSearch, page: Int, per: Int) async throws(NetworkError) -> Mangas
    //Implementar mas funciones si se quieren utilizar mas endpoints
}

struct Network: NetworkRepository {
    func getMangas(page: Int, per: Int) async throws(NetworkError) -> Mangas {
        let url = URL.getMangas(page: page, per: per)
        let mangasDTO = try await getJSON(.get(url: url), type: MangasDTO.self)
        return mangasDTO.toMangas
    }
    
    func searchMangaById(id: Int) async throws(NetworkError) -> Manga {
        try await getJSON(.get(url: .searchMangaById(id: id)), type: MangaDTO.self).toManga
    }
    
    func searchMangasCustom(criteria: CustomSearch, page: Int, per: Int) async throws(NetworkError) -> Mangas {
        let url = URL.postSearchMangas(page: page, per: per)
        let request = URLRequest.post(url: url, body: criteria)
        let mangasDTO = try await getJSON(request, type: MangasDTO.self)
        return mangasDTO.toMangas
    }
}

