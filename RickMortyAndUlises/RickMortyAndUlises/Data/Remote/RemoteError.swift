//
//  RemoteError.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 21/6/24.
//

import Foundation

enum RemoteError: Error {
    case invalidURL
    case invalidResponse
    case decoding(String)
    case badRequest
    case notFound
    case error500
    case timeout
    case unknown
}
