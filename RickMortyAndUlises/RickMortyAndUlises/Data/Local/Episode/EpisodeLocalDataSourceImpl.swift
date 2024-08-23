//
//  EpisodeLocalDataSourceImpl.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 13/8/24.
//

import Foundation
import SwiftData

@MainActor
final class EpisodeLocalDataSourceImpl: EpisodeLocalDataSource {
    
    static let shared: EpisodeLocalDataSource = EpisodeLocalDataSourceImpl()
    
    private let episodeContainer: ModelContainer
    
    init() {
        self.episodeContainer = try! ModelContainer(for: EpisodeEntity.self)
    }
    
    
    
}
