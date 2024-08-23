//
//  UIColorExtension.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 1/7/24.
//

import Foundation
import SwiftUI

extension UIColor {
    
    func toColor() -> Color {
        Color(uiColor: self)
    }
}
