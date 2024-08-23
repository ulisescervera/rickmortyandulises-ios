//
//  EpisodeDTO.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 12/8/24.
//

import Foundation

struct EpisodeDTO: Codable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let created: Date
}
