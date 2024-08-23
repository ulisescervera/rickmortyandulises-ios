//
//  RemoteEndpoint.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 21/6/24.
//

import Foundation

enum RemoteEndpoint {
    case getCharacterList(page: Int)
    case getCharacters(ids: [Int])
    case getCharacter(id: Int)
    
    case getEpisode(id: Int)
    case getEpisodes(ids: [Int])
    
    case getLocations(page: Int)
    
    private var baseUrl: String {
        // TODO: take base url from config
        return "https://rickandmortyapi.com/api"
    }
    
    func toString() -> String {
        let endpoint = switch self {
        case .getCharacterList(let page):
            String(format: "/character?page=%d", page)
            
        case .getCharacters(let ids):
            String(format: "/character/%@", ids.map { String($0) }.joined(separator: ","))
            
        case .getCharacter(let id):
            String(format: "/character/%d", id)
            
        case .getEpisode(let id):
            String(format: "/episode/%d", id)
            
        case .getEpisodes(let ids):
            String(format: "/episode/%@", ids.map { String($0) }.joined(separator: ","))
            
        case .getLocations(let page):
            String(format: "/location?page=%d", page)
        }
        
        return baseUrl + endpoint
    }
}
