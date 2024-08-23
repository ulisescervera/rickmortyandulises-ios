//
//  MainScreen.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 21/6/24.
//

import SwiftUI
import SwiftData

struct MainTabScreen: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject private var navigationViewModel: NavigationViewModel

    var body: some View {
        TabView(selection: $navigationViewModel.selectedTab) {
            ForEach(MainTab.allCases) { tab in
                let isSelected = navigationViewModel.selectedTab == tab
                
                switch tab {
                    case .characters:
                        NavigationStack(path: $navigationViewModel.characterPath) {
                            CharactersListScreen()
                                .withDestinations()
                        }
                        .tabItem {
                            Image(systemName: "person.2.circle")
                            Text("tab_title_characters")
                                .fontWeight(isSelected ? .bold : .regular)
                        }
                        
                    case .locations:
                        NavigationStack(path: $navigationViewModel.locationPath) {
                            LocationsListScreen()
                                .withDestinations()
                        }
                        .tabItem {
                            Image(systemName: "sun.min.fill")
                            Text("tab_title_locations")
                                .fontWeight(isSelected ? .bold : .regular)
                        }
                }
            }
        }
    }
}

@MainActor
private extension View {
    
    @ViewBuilder
    func withDestinations() -> some View {
        self.navigationDestination(for: AppRoute.self) { route in
            route.getView()
        }
    }
}

#Preview {
    MainTabScreen()
}
