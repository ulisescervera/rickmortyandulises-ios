//
//  AppRepository.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 21/6/24.
//

import Foundation

protocol AppRepository {
    
    func getCharacter(_ id: Int) async -> Result<CharacterModel, RemoteError>
    
    func getCharacters(_ page: Int) async -> Result<Page<CharacterModel>, RemoteError>
    
    func getCharacters(by ids: [Int]) async -> Result<[CharacterModel], RemoteError>
    
    func getEpisode(_ id: Int) async -> Result<EpisodeModel, RemoteError>
    
    func getEpisodes(by ids: [Int]) async -> Result<[EpisodeModel], RemoteError>
    
    func getLocations(_ page: Int) async -> Result<Page<LocationModel>, RemoteError>
    
}
