//
//  CharacterDetailScreen.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 1/7/24.
//

import Foundation
import SwiftUI

struct CharacterDetailScreen: View {
    
    @StateObject private var viewModel: CharacterDetailViewModel
    
    @EnvironmentObject private var navigationViewModel: NavigationViewModel
    
    @State private var taskId: UUID = .init()
    
    init(viewModel: CharacterDetailViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    private var character: CharacterModel {
        viewModel.character
    }
    
    static let characterSpacing: CGFloat = 8
    
    private let hMargin: CGFloat = 16
    
    var body: some View {
        GeometryReader { geo in
            let imageWidth = max(geo.size.width - 2 * hMargin, 0)
            let imageHeight = imageWidth * 9 / 16
           
            ScrollView {
                VStack(alignment: .leading, spacing: .zero) {
                    AsyncImage(url: URL(string: character.image)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: imageWidth, height: imageHeight)
                                .clipShape(RoundedRectangle(cornerRadius: .cardCornerRadius))
                        } else if case .failure(_) = phase {
                            Self.shimmerColor
                                .frame(width: imageWidth, height: imageHeight)
                                .clipShape(RoundedRectangle(cornerRadius: .cardCornerRadius))
                                
                        } else {
                            Self.shimmerColor
                                .frame(width: imageWidth, height: imageHeight)
                                .clipShape(RoundedRectangle(cornerRadius: .cardCornerRadius))
                                .shimmering()
                        }
                        
                    }
                    .defaultHMargin()
                    
                    Spacer().frame(height: 8)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(character.name)
                            .font(.title)
                            .lineLimit(2)
                        
                        Text("\(String(localized: "status")): \(character.status.title.lowercased())")
                            .font(.body)
                            .lineLimit(1)
                        
                        Text("\(String(localized: "gender")): \(character.gender.title.lowercased())")
                            .font(.body)
                            .lineLimit(1)
                    }
                    .defaultHMargin()
                    
                    Spacer().frame(height: 16)
                    
                    let imageSize = max((geo.size.width - 2 * Self.hMargin - 2 * Self.characterSpacing) / 3, 0).rounded()
                    switch viewModel.relatedCharacters {
                        case .idle, .loading:
                            RelatedCharactersList(characters: [CharacterModel.mock], imageSize: imageSize, isLoading: true)
                            
                        case .success(let data):
                            RelatedCharactersList(characters: data, imageSize: imageSize, isLoading: false)
                            
                        case .error(_):
                            // TODO: error or placeholer view
                            EmptyView()
                    }
                    
                    Spacer().frame(height: 16)
                    
                    EpisodeListView()
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .background(UIColor.secondarySystemBackground.toColor())
        .toolbar(.hidden, for: .tabBar)
        .navigationBarTitleDisplayMode(.inline)
        .task(id: taskId) { @MainActor in
            switch viewModel.episodes {
                case .idle, .error(_):
                    await viewModel.fetchEpisodesAndRelatedCharacters()
                default: break
            }
        }
    }
    
    @ViewBuilder
    private func RelatedCharactersList(characters: [CharacterModel], imageSize: CGFloat, isLoading: Bool) -> some View {
        Text("related_characters")
            .font(.headline)
            .defaultHMargin()
        
        Spacer().frame(height: 8)
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: Self.characterSpacing) {
                ForEach(characters) { character in
                    Button {
                        navigationViewModel.navigateCharacterPath(destination: .characterDetail(character))
                    } label: {
                        RelatedCharacterCellView(character, imageSize: imageSize)
                    }
                    .disabled(isLoading)
                }
            }
            .redacted(reason: isLoading ? .placeholder : [])
            .shimmering(isLoading)
            .defaultHMargin()
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func RelatedCharacterCellView(_ character: CharacterModel, imageSize: CGFloat) -> some View {
        VStack(spacing: 4) {
            AsyncImage(url: URL(string: character.image)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize, height: imageSize)
                    
            } placeholder: {
                Color.gray.opacity(0.5)
                    .frame(width: imageSize, height: imageSize)
            }
            
            Text(character.name)
                .font(.body)
                .minimumScaleFactor(0.75)
                .lineLimit(1)
        }
        .frame(width: imageSize)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
    
    @ViewBuilder
    private func EpisodeListView() -> some View {
        Text("episodes")
            .font(.headline)
            .defaultHMargin()
        
        Spacer().frame(height: 8)
        
        if let episodes = viewModel.episodes.data {
            VStack(alignment: .leading, spacing: 2) {
                ForEach(episodes) { episode in
                    Text(episode.name)
                        .font(.body)
                        .minimumScaleFactor(0.75)
                        .lineLimit(1)
                }
            }
            .defaultHMargin()
        }
    }
}
