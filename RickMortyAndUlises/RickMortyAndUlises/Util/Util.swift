//
//  Util.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 1/7/24.
//

import Foundation

final class Util {
    
    static let shared: Util = Util()
    
    private lazy var debugDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
    
    static func print(_ message: String) {
        let timestamp = Util.shared.debugDateFormatter.string(from: Date())
        Swift.print("DEBUG \(timestamp) \(message)")
    }
}
