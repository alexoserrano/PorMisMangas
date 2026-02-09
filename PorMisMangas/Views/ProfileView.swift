//
//  ProfileView.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 17/02/26.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(MangasVM.self) private var vm
    @Environment(CollectionVM.self) private var collectionVM
    @Environment(ProfileVM.self) private var profileVM
    @State private var showSavedAlert = false
    private var totalVolumesOwned: Int {
        profileVM.profile.ownedVolumes.values.reduce(0) { $0 + $1.volumesOwned }
    }
     
    var body: some View {
        
        @Bindable var profileVM = profileVM
        
        NavigationStack {
            Form {
                Section("Personal Information") {
                    TextField("User Name", text: $profileVM.profile.userName, prompt: Text("Your Name"))
                        .autocorrectionDisabled()
                }
                
                Section("Statistics") {
                    LabeledContent {
                        Text("\(collectionVM.favoritesCount())")
                    } label: {
                        Label("My Collection", systemImage: "heart.fill")
                            .foregroundStyle(.red)
                    }
                    
                    LabeledContent {
                        Text("\(vm.paginationState.totalItems)")
                    } label: {
                        Label("Mangas Total", systemImage: "book.fill")
                            .foregroundStyle(.blue)
                    }
                    
                    LabeledContent {
                        Text("\(totalVolumesOwned)")
                    } label: {
                        Label("Total Volumes Owned", systemImage: "books.vertical.fill")
                            .foregroundStyle(.green)
                    }
                }
                
                Section {
                    Button {
                        showSavedAlert = true
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                }
                
            }
            .navigationTitle("Profile")
            .alert("Profile Saved", isPresented: $showSavedAlert) {
                Button("Ok", role: .cancel) { }
            } message: {
                Text("Profile Succesfully Saved")
            }
            .task {
                // Solo cargar si no hay datos todavía
                if vm.mangas.isEmpty {
                    await vm.getMangas()
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environment(ProfileVM())
        .environment(MangasVM())
        .environment(CollectionVM())
}
