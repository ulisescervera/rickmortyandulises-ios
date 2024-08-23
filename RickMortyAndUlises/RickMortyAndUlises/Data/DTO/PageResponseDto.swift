//
//  PageResponseDto.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 21/6/24.
//

import Foundation

struct PageResponseDto<T: Decodable>: Decodable {
    let info: PageInfoDto
    let results: [T]
}

struct PageInfoDto: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
