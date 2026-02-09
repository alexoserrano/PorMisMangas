//
//  MangaFilters.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 20/02/26.
//

import Foundation

struct MangaFilters: Hashable, Sendable {
    var selectedGenres: Set<Manga.GenreEnum> = []
    var selectedThemes: Set<Manga.ThemeEnum> = []
    var selectedDemographics: Set<Manga.DemographicEnum> = []
    var searchText: String = ""
    
    var hasActiveFilters: Bool {
        !selectedGenres.isEmpty ||
        !selectedThemes.isEmpty ||
        !selectedDemographics.isEmpty ||
        !searchText.isEmpty
    }
    
    mutating func reset() {
        selectedGenres.removeAll()
        selectedThemes.removeAll()
        selectedDemographics.removeAll()
        searchText = ""
    }
    
    var activeFilterCount: Int {
        var count = 0
        if !selectedGenres.isEmpty { count += selectedGenres.count }
        if !selectedThemes.isEmpty { count += selectedThemes.count }
        if !selectedDemographics.isEmpty { count += selectedDemographics.count }
        if !searchText.isEmpty { count += 1 }
        return count
    }
}
