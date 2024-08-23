//
//  Character+Extensions.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 14/8/24.
//

import Foundation

extension CharacterStatus {
    var title: String {
        return switch self {
            case .alive: String(localized: "alive")
            case .dead: String(localized: "dead")
            case .unknown: String(localized: "unknown")
        }
    }
}

extension CharacterGender {
    var title: String {
        return switch self {
            case .male: String(localized: "male")
            case .female: String(localized: "female")
            case .genderless: String(localized: "genderless")
            case .unknown: String(localized: "unknown")
        }
    }
}
