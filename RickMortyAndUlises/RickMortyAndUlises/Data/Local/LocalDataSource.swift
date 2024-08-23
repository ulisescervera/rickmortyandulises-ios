//
//  CharacterLocalDataSource.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 13/8/24.
//

import Foundation
import SwiftData

protocol LocalDataSource {
    // Characters
    func save(characters: [CharacterEntity]) async -> Result<Void, LocalError>
    func fetch(character: Int) async -> Result<CharacterEntity, LocalError>
    func fetch(characters: [Int]) async -> Result<[CharacterEntity], LocalError>
    
    // Episodes
    func save(episodes: [EpisodeEntity]) async -> Result<Void, LocalError>
    func fetch(episode: Int) async -> Result<EpisodeEntity, LocalError>
    func fetch(episodes: [Int]) async -> Result<[EpisodeEntity], LocalError>
}
