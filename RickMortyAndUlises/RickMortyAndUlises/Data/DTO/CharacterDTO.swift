//
//  CharacterDTO.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 21/6/24.
//

import Foundation

struct CharacterDTO: Decodable {
    let id: Int
    let name: String
    let status: String // 'Alive', 'Dead' or 'unknown'
    let species: String
    let type: String
    let gender: String // 'Female', 'Male', 'Genderless' or 'unknown'
    let image: String
    let created: Date
    let episode: [String]
}
