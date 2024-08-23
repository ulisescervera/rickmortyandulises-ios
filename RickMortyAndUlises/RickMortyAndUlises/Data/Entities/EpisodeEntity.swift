//
//  EpisodeEntity.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 13/8/24.
//

import Foundation
import SwiftData

@Model
class EpisodeEntity: Identifiable, Hashable {
    let id: Int
    let name: String
    let airDate: Date
    let episode: String
    let created: Date
    let characterIds: [Int]
    
    init(id: Int, name: String, airDate: Date, episode: String, created: Date, characterIds: [Int]) {
        self.id = id
        self.name = name
        self.airDate = airDate
        self.episode = episode
        self.characterIds = characterIds
        self.created = created
    }
}
