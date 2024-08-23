//
//  URLExtension.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 28/6/24.
//

import Foundation

extension URL {
    
    func getParameterValue(_ name: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == name })?.value
    }
}
