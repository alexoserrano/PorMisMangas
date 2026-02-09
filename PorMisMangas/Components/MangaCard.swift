//
//  MangaCard.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 16/02/26.
//

import SwiftUI

struct MangaCard: View {
    
    let manga: Manga
    let isFavorite: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 11)
            .fill(.gray.opacity(0.3).gradient)
            .frame(height: 125)
            .overlay(alignment: .bottom) {
                Text(manga.title)
                    .font(.caption)
                    .bold()
                    .padding(.bottom, 5)
            }
            .overlay {
                ZStack {
                    AsyncImage(url: manga.mainPicture) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                    } placeholder: {
                        Image(systemName: "book")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                    }
                    if isFavorite {
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(.red)
                                    //.padding(8)
                            }
                            Spacer()
                        }
                    }
                }
            }
    }
}

#Preview {
    MangaCard(manga: mangaTest, isFavorite: true)
}
