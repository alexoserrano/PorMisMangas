//
//  MangasVM.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 14/02/26.
//

import SwiftUI

enum ViewState {
    case loading
    case loaded
    case empty
}

@Observable @MainActor
final class MangasVM {
    let repository: NetworkRepository
    var mangas: [Manga] = []
    var metadata: Metadata?
    var isLoading = false
    var errorMessage: String?
    var paginationState = PaginationState()
    var state: ViewState = .loading
    var activeFilters: MangaFilters?
    
    init(repository: NetworkRepository = Network()) {
        self.repository = repository
    }
    
    func getMangas() async {
        isLoading = true
        errorMessage = nil
        paginationState.isLoading = true
        state = .loading
        do {
            let result = try await repository.getMangas(
                page: paginationState.currentPage,
                per: paginationState.itemsPerPage
            )
            self.mangas = result.items
            self.metadata = result.metadata
            paginationState.updateWith(metadata: result.metadata)
            state = mangas.isEmpty ? .empty : .loaded
        } catch {
            self.errorMessage = error.errorDescription
            print("Network Error: \(error.errorDescription ?? "Error Desconocido")")
            state = .empty
        }
        isLoading = false
        paginationState.isLoading = false
    }
    
    func searchMangasCustom(
        title: String? = nil,
        authorFirstName: String? = nil,
        authorLastName: String? = nil,
        genres: [String]? = nil,
        themes: [String]? = nil,
        demographics: [String]? = nil,
        contains: Bool = true   //Con el parámetro fijo a true se realizarán las búsquedas como contains
    ) async {
        isLoading = true
        errorMessage = nil
        do {
            let criteria = CustomSearch(
                searchTitle: title,
                searchAuthorFirstName: authorFirstName,
                searchAuthorLastName: authorLastName,
                searchGenres: genres,
                searchThemes: themes,
                searchDemographics: demographics,
                searchContains: contains
            )
            let result = try await repository.searchMangasCustom(criteria: criteria,
                                                                 page: paginationState.currentPage,
                                                                 per: paginationState.itemsPerPage)
            self.mangas = result.items
            self.metadata = result.metadata
        } catch {
            self.errorMessage = error.errorDescription
            print("Network Error: \(error.errorDescription ?? "Error Desconocido")")
        }
        isLoading = false
    }
    
    func loadNextPage() async {
        guard paginationState.hasMorePages else { return }
        paginationState.nextPage()
        if let filters = activeFilters {
            await applyFilters(filters)
        } else {
            await getMangas()
        }
    }

    func loadPreviousPage() async {
        guard paginationState.currentPage > 1 else { return }
        paginationState.previousPage()
        if let filters = activeFilters {
            await applyFilters(filters)
        } else {
            await getMangas()
        }
    }

    func loadPage(_ page: Int) async {
        paginationState.goToPage(page)
        await getMangas()
    }
    
    func applyFiltersFromUI(_ filters: MangaFilters) async {
        paginationState.currentPage = 1
        await applyFilters(filters)
    }
    
    func applyFilters(_ filters: MangaFilters) async {
        if filters.hasActiveFilters {
            activeFilters = filters
        } else {
            activeFilters = nil
        }
        isLoading = true
        errorMessage = nil
        state = .loading
        
        do {
            guard filters.hasActiveFilters else {
                await getMangas()
                return
            }
            
            let criteria = CustomSearch(
                searchTitle: filters.searchText.isEmpty ? nil : filters.searchText,
                searchAuthorFirstName: nil,
                searchAuthorLastName: nil,
                searchGenres: filters.selectedGenres.isEmpty ? nil : filters.selectedGenres.map { $0.rawValue },
                searchThemes: filters.selectedThemes.isEmpty ? nil : filters.selectedThemes.map { $0.rawValue },
                searchDemographics: filters.selectedDemographics.isEmpty ? nil : filters.selectedDemographics.map { $0.rawValue },
                searchContains: !filters.searchText.isEmpty
            )
            
            print("\(criteria)")
            
            let result = try await repository.searchMangasCustom(
                criteria: criteria,
                page: paginationState.currentPage,
                per: paginationState.itemsPerPage
            )
            
            let filteredMangas = result.items
            print("Recibidos \(filteredMangas.count) mangas")
            //Reservar este espacio para código de status y score
            
            self.mangas = filteredMangas
            self.metadata = result.metadata
            paginationState.updateWith(metadata: result.metadata)
            state = mangas.isEmpty ? .empty : .loaded
            
            
        } catch {
            self.errorMessage = error.errorDescription
            print("Network Error: \(error.errorDescription ?? "Error Desconocido")")
            state = .empty
        }
        
        isLoading = false
        paginationState.isLoading = false
    }
}
