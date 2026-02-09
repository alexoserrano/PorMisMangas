//
//  MangaRow.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 17/02/26.
//

import SwiftUI

struct MangaRow: View {
    let manga: Manga
    let isFavorite: Bool
    
    var body: some View {
        NavigationLink(value: manga) {   //Marcaba error porque debe ponerse Film en Hashable
            rowContent
        }
        .buttonStyle(.plain)
    }
    
    private var rowContent: some View {
        HStack(spacing: 10) {
            AsyncImage(url: manga.mainPicture) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 60, height: 90)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .foregroundStyle(.secondary)
                        .frame(width: 60, height: 90)
                        .background(.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                @unknown default:
                    EmptyView()
                }
            }
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(manga.title)
                        .font(.headline)
                        .bold()
                    if isFavorite {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.red)
                    }
                }
                if let titleJapanese = manga.titleJapanese {
                    Text(titleJapanese)
                }
                HStack(spacing: 2) {
                    Image(systemName: "book")
                    Text(manga.authors.map { "\($0.firstName) \($0.lastName)" }
                        .joined(separator: ", "))
                }
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text(manga.formattedScore)
                }
            }
        }
    }
}

#Preview {
    MangaRow(manga: mangaTest, isFavorite: true)
}
