//
//  Mapper.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 21/6/24.
//

import Foundation

extension CharacterDTO {
    
    func toModel() -> CharacterModel {
        return CharacterModel(
            id: id,
            name: name,
            status: CharacterStatus(rawValue: status) ?? .unknown,
            species: species,
            type: type,
            gender: CharacterGender(rawValue: gender) ?? .unknown,
            image: image,
            created: created,
            episodeIds: episode.compactMap {
                guard let id = URL(string: $0)?.lastPathComponent else { return nil }
                return Int(id)
            }
        )
    }
    
    func toEntity() -> CharacterEntity {
        return CharacterEntity(
            id: id,
            name: name,
            status: status,
            species: species,
            type: type,
            gender: gender,
            image: image,
            created: created,
            episodeIds: episode.compactMap {
                guard let id = URL(string: $0)?.lastPathComponent else { return nil }
                return Int(id)
            }
        )
    }
}

extension EpisodeDTO {
    
    func toModel() -> EpisodeModel {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return EpisodeModel(
            id: id,
            name: name,
            airDate: formatter.date(from: air_date)!,
            episode: episode,
            created: created,
            characterIds: characters.compactMap {
                guard let id = URL(string: $0)?.lastPathComponent else { return nil }
                return Int(id)
            }
        )
    }
    
    func toEntity() -> EpisodeEntity {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return EpisodeEntity(
            id: id,
            name: name,
            airDate: formatter.date(from: air_date)!,
            episode: episode,
            created: created,
            characterIds: characters.compactMap {
                guard let id = URL(string: $0)?.lastPathComponent else { return nil }
                return Int(id)
            }
        )
    }
}

extension CharacterEntity {
    
    func toModel() -> CharacterModel? {
        guard let status = CharacterStatus(rawValue: status),
              let gender =  CharacterGender(rawValue: gender)
        else { return nil }
        
        return CharacterModel(
            id: id,
            name: name,
            status: status,
            species: species,
            type: type,
            gender: gender,
            image: image,
            created: created,
            episodeIds: episodeIds
        )
    }
}

extension EpisodeEntity {
    
    func toModel() -> EpisodeModel {
        return EpisodeModel(id: id, name: name, airDate: airDate, episode: episode, created: created, characterIds: characterIds)
    }
}

extension LocationDTO {
    
    func toModel() -> LocationModel {
        let ids: [Int] = self.residents.compactMap {
            guard let id = URL(string: $0)?.lastPathComponent else { return nil }
            return Int(id)
        }
        return LocationModel(id: id, name: name, type: type, dimension: dimension, residentsIds: ids, created: created)
    }
}
