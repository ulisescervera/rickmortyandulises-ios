//
//  RickMortyAndUlisesApp.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 21/6/24.
//

import SwiftUI
import SwiftData

@MainActor
@main
struct RickMortyAndUlisesApp: App {
    
    @StateObject private var navigationViewModel = NavigationViewModel()
    @StateObject private var characterViewModel = CharacterViewModel()
    @StateObject private var locationViewModel = LocationViewModel()

    var body: some Scene {
        WindowGroup {
            MainTabScreen()
        }
        .environmentObject(navigationViewModel)
        .environmentObject(characterViewModel)
        .environmentObject(locationViewModel)
    }
}
