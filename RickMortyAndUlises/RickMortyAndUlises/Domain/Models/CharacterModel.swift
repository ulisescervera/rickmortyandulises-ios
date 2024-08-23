//
//  CharacterModel.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 21/6/24.
//

import Foundation

struct CharacterModel: Identifiable, Hashable, Equatable {
    let id: Int
    let name: String
    let status: CharacterStatus // 'Alive', 'Dead' or 'unknown'
    let species: String
    let type: String
    let gender: CharacterGender // 'Female', 'Male', 'Genderless' or 'unknown'
    let image: String
    let created: Date
    let episodeIds: [Int]
}

enum CharacterStatus: String {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

enum CharacterGender: String {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
}

extension CharacterModel {
    static var mock: CharacterModel {
        return CharacterModel(id: -1, name: "Mock character", status: .alive, species: "Mock specie", type: "mock type", gender: .genderless, image: "", created: Date(), episodeIds: [])
    }
}
