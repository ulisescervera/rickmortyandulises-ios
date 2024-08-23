//
//  EpisodeModel.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 12/8/24.
//

import Foundation

struct EpisodeModel: Identifiable, Hashable {
    let id: Int
    let name: String
    let airDate: Date
    let episode: String
    let created: Date
    let characterIds: [Int]
}
