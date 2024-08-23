//
//  MainViewModel.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 21/6/24.
//

import Foundation
import SwiftUI

@MainActor
final class NavigationViewModel: ObservableObject {
    
    @Published var selectedTab:     MainTab = .characters
    
    @Published var characterPath:   [AppRoute] = []
    @Published var locationPath:    [AppRoute] = []
    
    func navigateCharacterPath(destination: AppRoute) {
        if let index = characterPath.firstIndex(of: destination) {
            characterPath = Array(characterPath[0...index])
        } else {
            characterPath.append(destination)
        }
    }
    
    func navigateLocationPath(destination: AppRoute) {
        if let index = locationPath.firstIndex(of: destination) {
            locationPath = Array(characterPath[0...index])
        } else {
            locationPath.append(destination)
        }
    }
}
