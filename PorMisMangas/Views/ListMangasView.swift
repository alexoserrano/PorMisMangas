//
//  ListMangasView.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 31/01/26.
//

import SwiftUI

struct ListMangasView: View {
    
    @Environment(MangasVM.self) private var vm
    @Environment(CollectionVM.self) private var collectionVM
    @Environment(FilterVM.self) private var filterVM
    let adaptativeItem: [GridItem] = [GridItem(.adaptive(minimum: 75))]
    
    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Loading ...")
                } else if let errorMessage = vm.errorMessage {
                    ContentUnavailableView("Error",
                                           systemImage: "exclamationmark.triangle",
                                           description: Text(errorMessage))
                } else if !vm.mangas.isEmpty {
                    VStack {
                        Divider()
                        
                        /* Funcionalidad apagada del ActiveBar
                        if filterVM.filters.hasActiveFilters {
                            ActiveFiltersBar(filterVM: filterVM) {
                                Task {
                                    await vm.applyFiltersFromUI(filterVM.filters)
                                }
                            }
                        }
                        */
                         
                        //ScrollView {
                        //Dejé de utilizar LazyVGrid porque las imagenes se perdian a cambiar de Tab
                        Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 10) {
                            let columns = 4
                            let rows = min(4, Int(ceil(Double(vm.mangas.count) / Double(columns))))
                            
                            ForEach(0..<rows, id: \.self) { row in
                                GridRow {
                                    ForEach(0..<columns, id: \.self) { col in
                                        let index = row * columns + col
                                        if index < min(16, vm.mangas.count) {
                                            NavigationLink(value: vm.mangas[index]) {
                                                MangaCard(
                                                    manga: vm.mangas[index],
                                                    isFavorite: collectionVM.isFavorite(vm.mangas[index].id)
                                                )
                                            }
                                            .buttonStyle(.plain)
                                            .frame(maxWidth: .infinity)
                                        } else {
                                            Color.clear
                                                .frame(maxWidth: .infinity, minHeight: 125)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        //}
                        
                        Divider()
                        HStack(spacing: 10) {
                            Button {
                                Task {
                                    await vm.loadPreviousPage()
                                }
                            } label: {
                                Image(systemName: "chevron.left")
                                    .imageScale(.large)
                            }
                            .disabled(vm.paginationState.currentPage == 1 || vm.isLoading)
                            .buttonStyle(.bordered)
                            Spacer()
                            if vm.paginationState.isLoading {
                                ProgressView()
                            } else {
                                VStack {
                                    Text("Page \(vm.paginationState.currentPage) of \(vm.paginationState.totalPages)")
                                        .font(.headline)
                                    
                                    Text("Showing \(vm.paginationState.startItem)-\(vm.paginationState.endItem) of \(vm.paginationState.totalItems) mangas")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                            Button {
                                Task {
                                    await vm.loadNextPage()
                                }
                            } label: {
                                Image(systemName: "chevron.right")
                                    .imageScale(.large)
                            }
                            .disabled(!vm.paginationState.hasMorePages || vm.isLoading)
                            .buttonStyle(.bordered)
                        }
                        .padding(.horizontal)
                    }
                } else {
                    ContentUnavailableView("No mangas",
                                           systemImage: "book",
                                           description: Text("No mangas loaded.\nTry again"))
                }
            }
            //.safeAreaPadding()
            .navigationTitle("Mangas")
            .navigationDestination(for: Manga.self) { manga in
                MangaDetailView(manga: manga, isFavorite: collectionVM.isFavorite(manga.id))
            }
            //.toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        filterVM.isShowingFilters = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .overlay(alignment: .topTrailing) {
                                if filterVM.filters.activeFilterCount > 0 {
                                    Text("\(filterVM.filters.activeFilterCount)")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundStyle(.white)
                                        .frame(minWidth: 15, minHeight: 15)
                                        .background(Circle().fill(.red))
                                        .offset(x: 2, y: -2)
                                }
                            }
                    }
                }
            }
            .sheet(isPresented: Binding(
                get: { filterVM.isShowingFilters },
                set: { filterVM.isShowingFilters = $0 }
            )) {
                MangaSearchFilterView {
                    Task {
                        await vm.applyFiltersFromUI(filterVM.filters)
                    }
                }
                .environment(filterVM)
            }
        }
        .task(priority: .high) {
            if vm.mangas.isEmpty && vm.activeFilters == nil {
                await vm.getMangas()
            }
        }
    }
}

/* Decidí ocultar esta funcionalidad para mejorarla en apariencia en una siguiente versión
struct ActiveFiltersBar: View { //Para pintar los filtros activos en una barra superior en un stack horizontal
    let filterVM: FilterVM
    let onUpdate: () -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(filterVM.filters.selectedGenres), id: \.self) { genre in
                    FilterChip(text: genre.rawValue) {
                        filterVM.toggleGenre(genre)
                        onUpdate()
                    }
                }
                
                ForEach(Array(filterVM.filters.selectedThemes), id: \.self) { theme in
                    FilterChip(text: theme.rawValue) {
                        filterVM.toggleTheme(theme)
                        onUpdate()
                    }
                }
                
                ForEach(Array(filterVM.filters.selectedDemographics), id: \.self) { demo in
                    FilterChip(text: demo.rawValue) {
                        filterVM.toggleDemographic(demo)
                        onUpdate()
                    }
                }
                
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color.gray.opacity(0.1))
    }
}

struct FilterChip: View {
    let text: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(text)
                .font(.caption)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(Color.blue))
        .foregroundStyle(.white)
    }
}
*/

#Preview {
    ListMangasView()
        .environment(MangasVM())
        .environment(CollectionVM())
        .environment(FilterVM())
}
