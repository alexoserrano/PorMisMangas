//
//  MangaSearchFilterView.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 17/02/26.
//

import SwiftUI

struct MangaSearchFilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(FilterVM.self) private var filterVM
    
    var onApply: () -> Void
    
    var body: some View {
        @Bindable var filterVM = filterVM
        
        NavigationStack {
            Form {
                Section("Search By Title") {
                    TextField("Title Contains", text: $filterVM.filters.searchText)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 8) {
                            ForEach(Manga.GenreEnum.allCases.filter { $0 != .unknown }, id: \.self) { genre in
                                GenreChip(
                                    genre: genre,
                                    isSelected: filterVM.isGenreSelected(genre)
                                ) {
                                    filterVM.toggleGenre(genre)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                } header: {
                    Text("Genres")
                } footer: {
                    if !filterVM.filters.selectedGenres.isEmpty {
                        Text("\(filterVM.filters.selectedGenres.count) selected")
                    }
                }

                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 8) {
                            ForEach(Manga.ThemeEnum.allCases.filter { $0 != .unknown }, id: \.self) { theme in
                                ThemeChip(
                                    theme: theme,
                                    isSelected: filterVM.isThemeSelected(theme)
                                ) {
                                    filterVM.toggleTheme(theme)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                } header: {
                    Text("Themes")
                } footer: {
                    if !filterVM.filters.selectedThemes.isEmpty {
                        Text("\(filterVM.filters.selectedThemes.count) selected")
                    }
                }
                
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 8) {
                            ForEach(Manga.DemographicEnum.allCases.filter { $0 != .unknown }, id: \.self) { demographic in
                                DemographicChip(
                                    demographic: demographic,
                                    isSelected: filterVM.isDemographicSelected(demographic)
                                ) {
                                    filterVM.toggleDemographic(demographic)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                } header: {
                    Text("Demographics")
                } footer: {
                    if !filterVM.filters.selectedDemographics.isEmpty {
                        Text("\(filterVM.filters.selectedDemographics.count) selected")
                    }
                }
            }
            .navigationTitle("Search & Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        onApply()
                        dismiss()
                    }
                    .bold()
                }
                
                ToolbarItem(placement: .bottomBar) {
                    if filterVM.filters.hasActiveFilters {
                        Button("Reset All", role: .destructive) {
                            filterVM.resetFilters()
                        }
                    }
                }
            }
        }
    }
}

struct GenreChip: View {
    let genre: Manga.GenreEnum
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(genre.rawValue)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
                )
                .foregroundStyle(isSelected ? .white : .primary)
        }
    }
}

struct ThemeChip: View {
    let theme: Manga.ThemeEnum
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(theme.rawValue)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
                )
                .foregroundStyle(isSelected ? .white : .primary)
        }
    }
}

struct DemographicChip: View {
    let demographic: Manga.DemographicEnum
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(demographic.rawValue)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
                )
                .foregroundStyle(isSelected ? .white : .primary)
        }
    }
}

#Preview {
    MangaSearchFilterView { }
    .environment(FilterVM())
}
