//
//  AppRoute.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 21/6/24.
//

import Foundation
import SwiftUI

@MainActor
enum AppRoute: Hashable {
    case characterList
    case locationList
    case characterDetail(CharacterModel)
}

@MainActor
extension AppRoute {
    
    @ViewBuilder
    func getView() -> some View {
        switch self {
            case .characterList:
                CharactersListScreen()
                
            case .locationList:
                EmptyView()
                
            case .characterDetail(let character):
                CharacterDetailScreen(viewModel: CharacterDetailViewModel(character: character))
        }
    }
}
