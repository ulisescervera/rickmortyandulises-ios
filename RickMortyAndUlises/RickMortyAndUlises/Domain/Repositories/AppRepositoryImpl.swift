//
//  AppRepositoryImpl.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 21/6/24.
//

import Foundation

@MainActor
final class AppRepositoryImpl: AppRepository {
    
    static let shared: AppRepository = AppRepositoryImpl(service: RemoteService())
    
    private let service: RemoteService
    private let localDataSource: LocalDataSource
    
    init(
        service: RemoteService,
        localDataSource: LocalDataSource = LocalDataSourceImpl.shared
    ) {
        self.service = service
        self.localDataSource = localDataSource
    }
    
    func getCharacter(_ id: Int) async -> Result<CharacterModel, RemoteError> {
        let response: Result<CharacterDTO, RemoteError> = await service.get(endpoint: .getCharacter(id: id), type: CharacterDTO.self)
        return response.map { $0.toModel() }
    }
    
    func getCharacters(_ page: Int = 1) async -> Result<Page<CharacterModel>, RemoteError> {
        let response: Result<PageResponseDto<CharacterDTO>, RemoteError> = await service.get(endpoint: .getCharacterList(page: page))
        
        return response.map { res in
            let next: Int? = if let str = res.info.next, let page = URL(string: str)?.getParameterValue("page") { Int(page) } else { nil }
            let previous: Int? = if let str = res.info.prev, let page = URL(string: str)?.getParameterValue("page") { Int(page) } else { nil }
            return Page(totalPages: res.info.pages, currentPage: page, nextPage: next, previousPage: previous, data: res.results.map { $0.toModel() })
        }
    }
    
    func getCharacters(by ids: [Int]) async -> Result<[CharacterModel], RemoteError> {
        // Fetchs local database
        let localResponse = await localDataSource.fetch(characters: ids)
        let localCharacters: [CharacterModel] = if case .success(let localCharacters) = localResponse {
            localCharacters.compactMap { $0.toModel() }
        } else { [] }
        
        let foundCharacterIds = Set(localCharacters.map { $0.id })
        let missingCharactersIds = Set(ids).subtracting(foundCharacterIds)
        
        if missingCharactersIds.isEmpty {
            // All characters found in local database
            let sorted = ids.map { id in localCharacters.first(where: { $0.id == id })! }
            return .success(sorted)
        } else {
            // One or more characters not found in local DB, so request remote service for the characters not found in local DB
            let remoteResponse: Result<[CharacterDTO], RemoteError> = await service.get(endpoint: .getCharacters(ids: Array(missingCharactersIds)), type: [CharacterDTO].self)
            switch remoteResponse {
                case .success(let remoteCharacters):
                    // Make sure all missing characters are fetched by the remote service
                    guard Set(remoteCharacters.map { $0.id }) == missingCharactersIds else {
                        return .failure(RemoteError.notFound)
                    }
                    
                    // Save the remote characters to local DB. The next time any of them will be required, it should be in local DB
                    Task {
                        let _ = await localDataSource.save(characters: remoteCharacters.map { $0.toEntity() })
                    }
                    
                    // Sort the final character array as IDs are
                    let allCharacters = localCharacters + remoteCharacters.map { $0.toModel() }
                    let sorted = ids.map { id in allCharacters.first(where: { $0.id == id })! }
                    return .success(sorted)
                    
                case .failure(let error):
                    return .failure(error)
            }
        }
    }
    
    func getEpisode(_ id: Int) async -> Result<EpisodeModel, RemoteError> {
        let response: Result<EpisodeDTO, RemoteError> = await service.get(endpoint: .getEpisode(id: id), type: EpisodeDTO.self)
        return response.map { $0.toModel() }
    }
    
    func getEpisodes(by ids: [Int]) async -> Result<[EpisodeModel], RemoteError> {
        let localResponse = await localDataSource.fetch(episodes: ids)
        let localEpisodes: [EpisodeModel] = if case .success(let localEpisodes) = localResponse {
            localEpisodes.map { $0.toModel() }
        } else { [] }
        
        let foundEpisodesIds = Set(localEpisodes.map { $0.id })
        let missingEpisodeIds = Set(ids).subtracting(foundEpisodesIds)
        
        if missingEpisodeIds.isEmpty {
            // All episodes found in local database
            let sorted = ids.map { id in localEpisodes.first(where: { $0.id == id })! }
            return .success(sorted)
        } else {
            let remoteResponse: Result<[EpisodeDTO], RemoteError> = await service.get(endpoint: .getEpisodes(ids: ids), type: [EpisodeDTO].self)
            switch remoteResponse {
                case .success(let remoteEpisodes):
                    // Make sure all missing episodes are fetched by the remote service
                    guard Set(remoteEpisodes.map { $0.id }) == missingEpisodeIds else {
                        return .failure(RemoteError.notFound)
                    }
                    
                    // Save the remote episodes to local DB. The next time any of them will be required, it should be in local DB
                    Task {
                        let _ = await localDataSource.save(episodes: remoteEpisodes.map { $0.toEntity() })
                    }
                    
                    // Sort the final character array as IDs are
                    let allEpisodes = localEpisodes + remoteEpisodes.map { $0.toModel() }
                    let sorted = ids.map { id in allEpisodes.first(where: { $0.id == id })! }
                    return .success(sorted)
                    
                case .failure(let error):
                    return .failure(error)
            }
        }
    }
    
    func getLocations(_ page: Int) async -> Result<Page<LocationModel>, RemoteError> {
        let response = await service.get(endpoint: .getLocations(page: page), type: PageResponseDto<LocationDTO>.self)
        return response.map { res in
            let next: Int? = if let str = res.info.next, let page = URL(string: str)?.getParameterValue("page") { Int(page) } else { nil }
            let previous: Int? = if let str = res.info.prev, let page = URL(string: str)?.getParameterValue("page") { Int(page) } else { nil }
            return Page(totalPages: res.info.pages, currentPage: page, nextPage: next, previousPage: previous, data: res.results.map { $0.toModel() })
        }
    }
}
