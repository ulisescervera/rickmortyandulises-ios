//
//  LocationModel.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 14/8/24.
//

import Foundation

struct LocationModel: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let type: String
    let dimension: String // The dimension in which the location is located.
    let residentsIds: [Int] // List of character who have been last seen in the location.
    let created: Date
}

extension LocationModel {
    
    static var mock: LocationModel {
        return LocationModel(id: 1, name: "Any mock ocation", type: "Planet", dimension: "V dimension", residentsIds: [], created: Date())
    }
}
