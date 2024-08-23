//
//  Page.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 28/6/24.
//

import Foundation

struct Page<Model> {
    let totalPages: Int
    let currentPage: Int
    let nextPage: Int?
    let previousPage: Int?
    let data: [Model]
}
