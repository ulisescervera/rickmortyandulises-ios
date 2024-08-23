//
//  MainTab.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 21/6/24.
//

import Foundation

enum MainTab: Identifiable, CaseIterable {
    case characters
    case locations
    
    var id: Self {
        self
    }
}
