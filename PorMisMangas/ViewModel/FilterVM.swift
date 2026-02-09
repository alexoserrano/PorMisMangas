//
//  FilterVM.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 17/02/26.
//

import SwiftUI

@Observable @MainActor
final class FilterVM {
    var filters = MangaFilters()
    var isShowingFilters = false

    func toggleGenre(_ genre: Manga.GenreEnum) {
        if filters.selectedGenres.contains(genre) {
            filters.selectedGenres.remove(genre)
        } else {
            filters.selectedGenres.insert(genre)
        }
    }
    
    func isGenreSelected(_ genre: Manga.GenreEnum) -> Bool {
        filters.selectedGenres.contains(genre)
    }
    
    func toggleTheme(_ theme: Manga.ThemeEnum) {
        if filters.selectedThemes.contains(theme) {
            filters.selectedThemes.remove(theme)
        } else {
            filters.selectedThemes.insert(theme)
        }
    }
    
    func isThemeSelected(_ theme: Manga.ThemeEnum) -> Bool {
        filters.selectedThemes.contains(theme)
    }
    
    func toggleDemographic(_ demographic: Manga.DemographicEnum) {
        if filters.selectedDemographics.contains(demographic) {
            filters.selectedDemographics.remove(demographic)
        } else {
            filters.selectedDemographics.insert(demographic)
        }
    }
    
    func isDemographicSelected(_ demographic: Manga.DemographicEnum) -> Bool {
        filters.selectedDemographics.contains(demographic)
    }
    
    func setSearchText(_ text: String) {
        filters.searchText = text
    }
    
    func resetFilters() {
        filters.reset()
    }
    
    func buildSearchCriteria() -> CustomSearch {
        CustomSearch(
            searchTitle: filters.searchText.isEmpty ? nil : filters.searchText,
            searchAuthorFirstName: nil,
            searchAuthorLastName: nil,
            searchGenres: filters.selectedGenres.isEmpty ? nil : filters.selectedGenres.map { $0.rawValue },
            searchThemes: filters.selectedThemes.isEmpty ? nil : filters.selectedThemes.map { $0.rawValue },
            searchDemographics: filters.selectedDemographics.isEmpty ? nil : filters.selectedDemographics.map { $0.rawValue },
            searchContains: !filters.searchText.isEmpty
        )
    }
}
