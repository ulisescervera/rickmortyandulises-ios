//
//  CharacterEntity.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 13/8/24.
//

import Foundation
import SwiftData

@Model
final class CharacterEntity: Identifiable, Hashable, Equatable {
    let id: Int
    let name: String
    let status: String // 'Alive', 'Dead' or 'unknown'
    let species: String
    let type: String
    let gender: String // 'Female', 'Male', 'Genderless' or 'unknown'
    let image: String
    let created: Date
    let episodeIds: [Int]
    
    init(id: Int, name: String, status: String, species: String, type: String, gender: String, image: String, created: Date, episodeIds: [Int]) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.image = image
        self.created = created
        self.episodeIds = episodeIds
    }
}
