//
//  MangaDetailView.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 16/02/26.
//

import SwiftUI

struct MangaDetailView: View {
    
    //@State private var collectionVM = CollectionVM()
    @Environment(MangasVM.self) private var vm
    @Environment(CollectionVM.self) private var collectionVM
    let manga: Manga
    let isFavorite: Bool 
    
    var body: some View {
        ScrollView {
            if let banner = manga.mainPicture {
                AsyncImage(url: banner) { phase in
                    switch phase {
                        
                    case .empty:
                        Rectangle()
                            .fill(.gray.opacity(0.3))
                            .frame(height: 200)
                            .overlay {
                                ProgressView()
                            }
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .frame(height: 400)
                            .clipped()
                        
                    case .failure:
                        Rectangle()
                            .fill(.gray.opacity(0.3))
                            .frame(height: 200)
                            .overlay {
                                Image(systemName: "book")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                            }
                        
                    @unknown default:
                        EmptyView()
                        
                    }
                }
            }
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    if let englishTitle = manga.titleEnglish {
                        Text(englishTitle)
                            .foregroundStyle(.gray)
                    }
                    HStack {
                        Text(manga.title)
                            .font(.title2)
                        if isFavorite {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(.red)
                        }
                    }
                    if let japaneseTitle = manga.titleJapanese {
                        Text(japaneseTitle)
                    }
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text(manga.formattedScore)
                            .font(.title2)
                            .bold()
                    }
                    .frame(height: 50)
                    if let volumes = manga.volumes {
                        Text("Volumes: \(volumes)")
                    } else {
                        Text("Pending")
                    }
                    HStack(spacing: 5) {
                        Text(manga.formattedStartDate)
                        Text("•")
                        Text(manga.formattedEndDate ?? "Unknown")
                    }
                    .foregroundStyle(.gray)
                    Divider()
                        .padding(.vertical, 8)
                    //Spacer()
                    HStack {
                        Text("Authors")
                        Spacer()
                        Text(manga.authors.map { "\($0.firstName) \($0.lastName)" }
                            .joined(separator: ", "))
                    }
                    .bold()
                    Spacer()
                    Divider()
                        .padding(.vertical, 8)
                    HStack {
                        Text("Genres")
                        Spacer()
                        Text(manga.genres.map { "\($0.genre)" }.joined(separator: ", "))
                    }
                    .bold()
                    Spacer()
                    Divider()
                        .padding(.vertical, 8)
                    HStack {
                        Text("Demographics")
                        Spacer()
                        Text(manga.demographics.map { "\($0.demographic)" }.joined(separator: ", "))
                    }
                    .bold()
                    Spacer()
                    Divider()
                        .padding(.vertical, 8)
                    Text("Sypnosis")
                        .bold()
                    if let sinopsis = manga.sypnosis {
                        Text(sinopsis)
                            //.frame(height: 300, alignment: .leading)
                    }
                    Spacer()
                    Divider()
                    Spacer()
                    Button {
                        collectionVM.saveFavorite(manga)
                    } label: {
                        Label (
                            collectionVM.isFavorite(manga.id) ? "Remove" : "Favorite",
                            systemImage: collectionVM.isFavorite(manga.id) ? "heart.slash.fill" : "heart.fill"
                        )
                    }
                    .tint(collectionVM.isFavorite(manga.id) ? .gray : .red)
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .padding()
            }
        }
    }
}


#Preview {
    MangaDetailView(manga: mangaTest, isFavorite: true)
        .environment(MangasVM())
        .environment(CollectionVM())
}
