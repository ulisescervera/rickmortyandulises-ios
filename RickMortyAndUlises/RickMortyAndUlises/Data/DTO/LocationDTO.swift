//
//  LocationDTO.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 14/8/24.
//

import Foundation

struct LocationDTO: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String // The dimension in which the location is located.
    let residents: [String] // List of character who have been last seen in the location.
    let created: Date
}
