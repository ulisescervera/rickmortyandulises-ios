//
//  CharacterLocalDataSourceImpl.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 13/8/24.
//

import Foundation
import SwiftData

@MainActor
final class LocalDataSourceImpl: LocalDataSource {
    
    static let shared: LocalDataSource = LocalDataSourceImpl()
    
    private let modelContainer: ModelContainer
    
    init() {
        self.modelContainer = try! ModelContainer(for: CharacterEntity.self, EpisodeEntity.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
    }
    
    // MARK: - Characters
    func save(characters: [CharacterEntity]) async -> Result<Void, LocalError> {
        characters.forEach {
            modelContainer.mainContext.insert($0)
        }
        
        do {
            try modelContainer.mainContext.save()
            return .success(())
        } catch let error {
            return .failure(.unknown)
        }
    }
    
    func fetch(character: Int) async -> Result<CharacterEntity, LocalError>{
        do {
            let descriptor = FetchDescriptor<CharacterEntity>(predicate: #Predicate<CharacterEntity> {
                $0.id == character
            })
            
            let result: [CharacterEntity] = try modelContainer.mainContext.fetch(descriptor)
            
            if let found = result.first {
                return .success(found)
            } else {
                return .failure(.notFound)
            }
            
        } catch let error {
            return .failure(.unknown)
        }
    }
    
    func fetch(characters: [Int]) async -> Result<[CharacterEntity], LocalError> {
        do {
            let descriptor = FetchDescriptor<CharacterEntity>(predicate: #Predicate<CharacterEntity> {
                characters.contains($0.id)
            })
            
            let result: [CharacterEntity] = try modelContainer.mainContext.fetch(descriptor)
            return .success(result)
            
        } catch let error {
            return .failure(.unknown)
        }
    }
    
    // MARK: - Episodes
    func save(episodes: [EpisodeEntity]) async -> Result<Void, LocalError> {
        episodes.forEach {
            modelContainer.mainContext.insert($0)
        }
        
        do {
            try modelContainer.mainContext.save()
            return .success(())
        } catch let error {
            return .failure(.unknown)
        }
    }
    
    func fetch(episode: Int) async -> Result<EpisodeEntity, LocalError>{
        do {
            let descriptor = FetchDescriptor<EpisodeEntity>(predicate: #Predicate<EpisodeEntity> {
                $0.id == episode
            })
            
            let result: [EpisodeEntity] = try modelContainer.mainContext.fetch(descriptor)
            
            if let found = result.first {
                return .success(found)
            } else {
                return .failure(.notFound)
            }
            
        } catch let error {
            return .failure(.unknown)
        }
    }
    
    func fetch(episodes: [Int]) async -> Result<[EpisodeEntity], LocalError> {
        do {
            let descriptor = FetchDescriptor<EpisodeEntity>(predicate: #Predicate<EpisodeEntity> {
                episodes.contains($0.id)
            })
            
            let result: [EpisodeEntity] = try modelContainer.mainContext.fetch(descriptor)
            return .success(result)
            
        } catch let error {
            return .failure(.unknown)
        }
    }
}
