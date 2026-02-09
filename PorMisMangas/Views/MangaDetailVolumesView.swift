//
//  MangaDetailVolumesView.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 16/02/26.
//

import SwiftUI

struct MangaDetailVolumesView: View {
    
    @Environment(MangasVM.self) private var vm
    @Environment(CollectionVM.self) private var collectionVM
    @Environment(ProfileVM.self) private var profileVM
    let manga: Manga
    let isFavorite: Bool
    @State private var editorVM: MangaCollectionEditorVM?
    
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
            if let editor = editorVM {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 3) {
                        if let englishTitle = manga.titleEnglish {
                            Text(englishTitle)
                                .foregroundStyle(.gray)
                                .font(.subheadline)
                        }
                        
                        HStack {
                            Text(manga.title)
                                .font(.title2)
                                .bold()
                            if isFavorite {
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                        
                        if let japaneseTitle = manga.titleJapanese {
                            Text(japaneseTitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        if let volumes = manga.volumes {
                            Text("Total Volumes: \(volumes)")
                                .font(.headline)
                                .foregroundStyle(.blue)
                        } else {
                            Text("Total Volumes Unknown")
                                .font(.headline)
                        }
                    }
                    
                    Divider()
                    GroupBox {
                        @Bindable var editor = editor
                        
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Volumes I Own:")
                                    .font(.headline)
                                HStack {
                                    Picker("Volumes Owned", selection: $editor.selectedVolumesOwned) {
                                        ForEach(0...editor.maxVolumes, id: \.self) { volume in
                                            Text("\(volume)").tag(volume)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    .frame(height: 120)
                                    .clipped()
                                    
                                    Text("/ \(editor.maxVolumes)")
                                        .font(.title2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            if editor.selectedVolumesOwned > 0 {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Currently Reading Volume:")
                                        .font(.headline)
                                    HStack {
                                        Picker("Currently Reading", selection: $editor.selectedCurrentlyReading) {
                                            ForEach(0...editor.selectedVolumesOwned, id: \.self) { volume in
                                                if volume == 0 {
                                                    Text("Not reading").tag(volume)
                                                } else {
                                                    Text("Volume \(volume)").tag(volume)
                                                }
                                            }
                                        }
                                        .pickerStyle(.wheel)
                                        .frame(height: 120)
                                        .clipped()
                                    }
                                }
                            }
                            
                            Button {
                                editor.saveCollection()
                            } label: {
                                Label("Save", systemImage: "checkmark.circle.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(editor.selectedVolumesOwned == 0)
                        }
                    } label: {
                        Label("My Collection", systemImage: "books.vertical.fill")
                            .font(.headline)
                    }
                    Divider()
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
            }
        }
        .onAppear {
            if editorVM == nil {
                editorVM = MangaCollectionEditorVM(profileVM: profileVM, manga: manga)
                editorVM?.loadCollection()
            }
        }
    }
}

#Preview {
    MangaDetailVolumesView(manga: mangaTest, isFavorite: true)
        .environment(MangasVM())
        .environment(CollectionVM())
        .environment(ProfileVM())
}
