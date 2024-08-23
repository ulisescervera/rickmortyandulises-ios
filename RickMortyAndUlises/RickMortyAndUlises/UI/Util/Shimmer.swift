//
//  Shimmer.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 14/8/24.
//

import SwiftUI

extension View {
    
    static var shimmerColor: Color {
        .shimmerColor
    }
    
    static var shimmerCornerRadius: CGFloat {
        return 8
    }
    
    @ViewBuilder
    func shimmering(_ isActive: Bool = true) -> some View {
        if isActive {
            self.modifier(ShimmerEffect(config: .init(tint: Self.shimmerColor, hightlight: .white.opacity(1))))
        } else {
            self
        }
    }
    
    @ViewBuilder
    func rshimmering() -> some View {
        self.cornerRadius(Self.shimmerCornerRadius).shimmering()
    }
}

private struct ShimmerConfig {
    let tint: Color
    let hightlight: Color
    let speed: Double = 1.5
    let blur: Double = 3
    let animationDelay: Double = 0.25
}

private struct ShimmerEffect: ViewModifier {
    let config: ShimmerConfig
    
    @State private var moveTo: CGFloat = -0.7
    
    func body(content: Content) -> some View {
        let colors: [Color] = [
            .white.opacity(0),
            config.hightlight,
            .white.opacity(0),
        ]
        
        content
            .hidden()
            .overlay {
                Rectangle()
                    .fill(config.tint)
                    .mask(content)
                    .overlay {
                        GeometryReader { geo in
                            let size = geo.size
                            let extraOffset = size.height / 2.5
                            let shimmerWidth = size.width * 0.4
                            let angle: Double = 20
                            let hypotenuse = size.height / cos(angle * Double.pi / 180)
                            let shimmerHeight = hypotenuse + 2 * tan(angle * Double.pi / 180) * (shimmerWidth / 2)
                            
                            Rectangle()
                                .fill(config.hightlight)
                                .mask {
                                    Rectangle()
                                        .fill(.linearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
                                        .frame(width: shimmerWidth, height: shimmerHeight)
                                        .blur(radius: config.blur)
                                        .rotationEffect(.init(degrees: angle), anchor: .center)
                                        .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
                                        .offset(x: size.width * moveTo)
                                }
                        }
                        .mask(content)
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            moveTo = 0.7
                        }
                    }
                    .animation(.linear(duration: config.speed).delay(config.animationDelay).repeatForever(autoreverses: false), value: moveTo)
            }
    }
}
