//
//  MainTabView.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 17/02/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Mangas", systemImage: "book.fill") {
                ListMangasView()
            }
            
            Tab("Collection", systemImage: "heart.fill") {
                CollectionView()
            }
            
            Tab("Profile", systemImage: "person.fill") {
                ProfileView()
            }
        }
    }
}

#Preview {
    MainTabView()
        .environment(MangasVM())
        .environment(CollectionVM())
        .environment(FilterVM())
        .environment(ProfileVM())
}
