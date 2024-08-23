//
//  CharacterDetailViewModel.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 12/8/24.
//

import Foundation
import Combine

@MainActor
final class CharacterDetailViewModel: ObservableObject {
    
    @Published private(set) var character: CharacterModel
    
    @Published private(set) var episodes: UIState<[EpisodeModel]> = .idle
    @Published private(set) var relatedCharacters: UIState<[CharacterModel]> = .idle
    
    private let repository: AppRepository
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(character: CharacterModel, repository: AppRepository = AppRepositoryImpl.shared) {
        self.character = character
        self.repository = repository
    }
    
    func fetchEpisodesAndRelatedCharacters() async {
        let ids = character.episodeIds
        guard ids.count > 0 else {
            self.episodes = .success([])
            return
        }
        
        let currentCharacterId = character.id
        
        self.episodes = .loading
        
        let result: Result<[EpisodeModel], RemoteError> = if ids.count == 1, let id = ids.first {
            await repository.getEpisode(id).map { [$0] }
        } else {
            await repository.getEpisodes(by: ids)
        }
        
        switch result {
            case .success(let episodes):
                self.episodes = .success(episodes)
                let ids = self.getSortedRelatedCharacters(in: episodes, to: currentCharacterId)
                await fetchRelatedCharacters(ids: ids)
                
            case .failure(let error):
                self.episodes = .error(error)
        }
    }
    
    func fetchRelatedCharacters(ids: [Int]) async {
        guard ids.count > 0 else {
            self.relatedCharacters = .success([])
            return
        }
        
        self.relatedCharacters = .loading
        
        let result: Result<[CharacterModel], RemoteError> = if ids.count == 1, let id = ids.first {
            await repository.getCharacter(id).map { [$0] }
        } else {
            await repository.getCharacters(by: ids)
        }
            
        switch result {
            case .success(let characters):
                relatedCharacters = .success(characters)
                
            case .failure(let error):
                relatedCharacters = .error(error)
        }
    }
    
    private func getSortedRelatedCharacters(in episodes: [EpisodeModel], to me: Int) -> [Int] {
        let allCharacters = episodes.flatMap { $0.characterIds }
        var occurrences = [Int: Int]()
        
        for id in allCharacters {
            if id == me { continue }
            occurrences[id] = (occurrences[id] ?? 0) + 1
        }
        
        return occurrences.map { (id: $0.key, occurrences: $0.value) }.sorted { pair1, pair2 in
            return if pair1.occurrences == pair2.occurrences {
                pair1.id < pair2.id
            } else {
                pair1.occurrences > pair2.occurrences
            }
        }.map {
            $0.id
        }
    }
}
