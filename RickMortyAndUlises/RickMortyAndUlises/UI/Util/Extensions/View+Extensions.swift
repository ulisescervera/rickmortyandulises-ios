//
//  View+Extensions.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 12/8/24.
//

import Foundation
import SwiftUI

extension View {
    
    static var hMargin: CGFloat {
        return 16
    }
    
    func onLoad(perform action: @escaping () -> Void) -> some View {
        self.modifier(ViewDidLoadModifier(action))
    }
    
    func defaultHMargin() -> some View {
        self.padding(.horizontal, Self.hMargin)
    }
    
    /// Applies `Redactable` ViewModifier
    /// - Parameter cornerRadius: whether applies default corner radius for shimmering views. It must be `true` for `Text` when it's converted to `some View`
    func redactable(cornerRadius: Bool = false) -> some View {
        modifier(Redactable()).cornerRadius(cornerRadius ? Self.shimmerCornerRadius : 0)
    }
    
    func cardShadow() -> some View {
        self.shadow(color: .gray.opacity(0.2), radius: 6)
    }
}

private struct ViewDidLoadModifier: ViewModifier {

    @State private var didLoad = false
    private let action: (() -> Void)?

    init(_ action: (() -> Void)? = nil) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
}

private struct Redactable: ViewModifier {
    @Environment(\.redactionReasons) private var reasons

    @ViewBuilder
    func body(content: Content) -> some View {
        if reasons.contains(.placeholder) {
            content.background(Color.shimmerColor)
        } else {
            content
        }
    }
}
