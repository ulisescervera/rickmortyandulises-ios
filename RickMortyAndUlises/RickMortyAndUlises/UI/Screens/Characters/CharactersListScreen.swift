//
//  CharactersListScreen.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 21/6/24.
//

import Foundation
import SwiftUI

struct CharactersListScreen: View {
    
    @EnvironmentObject private var viewModel: CharacterViewModel
    @EnvironmentObject private var navigationViewModel: NavigationViewModel
    
    private let numberOfColumns: CGFloat = 2
    private let hMargin: CGFloat = 16
    private let itemSpacing: CGFloat = 16
    
    var body: some View {
        GeometryReader { geo in
            let cellWidth = max(geo.size.width - 2 * hMargin - (numberOfColumns - 1) * itemSpacing, 0) / numberOfColumns
            let columns = [GridItem(.flexible()), GridItem(.flexible())]
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: itemSpacing) {
                    ForEach(viewModel.characters) { character in
                        let isLast = character.id == viewModel.characters.last?.id
                        
                        Button {
                            navigationViewModel.navigateCharacterPath(destination: .characterDetail(character))
                        } label: {
                            CharacterCellView(width: cellWidth, character: character)
                        }
                        .onAppear {
                            if isLast && !viewModel.isLoadingAPage {
                                viewModel.fetchCharactersNextPage()
                            }
                        }
                    }
                    
                    if viewModel.isLoadingAPage {
                        CharacterCellView(width: cellWidth, character: .mock)
                            .redacted(reason: .placeholder)
                            .shimmering()
                    }
                }
                .padding(hMargin)
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .refreshable {
                viewModel.reloadCharacters()
            }
        }
        .navigationTitle("characters_title")
    }
}

private struct CharacterCellView: View {
    
    let width: CGFloat
    let character: CharacterModel
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: character.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
            } placeholder: {
                Color.gray.opacity(0.5)
                    .shimmering()
            }
            .frame(width: width, height: width)
            
            Text(character.name)
                .lineLimit(1)
                .foregroundStyle(.blue)
                .padding(.horizontal, 12)
        }
        .padding(.bottom, 8)
        .background(.white)
        .cornerRadius(.cardCornerRadius)
        .cardShadow()
    }
}
