//
//  CollectionView.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 17/02/26.
//

import SwiftUI

struct CollectionView: View {
    
    @Environment(CollectionVM.self) private var collectionVM
    
    private var mangas: [Manga] {
        collectionVM.getFavorites()
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if !mangas.isEmpty {
                    favoritesList
                } else {
                    emptyState
                }
            }
            .navigationTitle("My Collection")
            .navigationDestination(for: Manga.self) { manga in
                MangaDetailVolumesView(manga: manga, isFavorite: collectionVM.isFavorite(manga.id))
            }
        }
    }
    
    private var emptyState: some View {
        ContentUnavailableView(
            "There are no mangas in your collection",
            systemImage: "heart.slash.fill",
            description: Text("Select your favorites mangas first")
        )
    }
    
    private var favoritesList: some View {
        List(mangas) { manga in
            MangaRow(manga: manga, isFavorite: true)
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        collectionVM.saveFavorite(manga)
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                }
        }
    }
}

#Preview {
    CollectionView()
        .environment(CollectionVM())
}
