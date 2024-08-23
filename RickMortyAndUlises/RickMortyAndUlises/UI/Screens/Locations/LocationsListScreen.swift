//
//  LocationsListScreen.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 21/6/24.
//

import Foundation
import SwiftUI

struct LocationsListScreen: View {
    
    @EnvironmentObject private var viewModel: LocationViewModel
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.locations) { location in
                        let isLast = location.id == viewModel.locations.last?.id
                        
                        LocationView(location: location)
                            .onAppear {
                                if isLast && !viewModel.isLoadingAPage {
                                    viewModel.fetchLocationsNextPage()
                                }
                            }
                    }
                    
                    if viewModel.isLoadingAPage {
                        LocationView(location: .mock)
                            .redacted(reason: .placeholder)
                            .shimmering()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle("locations")
    }
}

private struct LocationView: View {
    
    let location: LocationModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            VStack(alignment: .leading, spacing: 2) {
                Text(location.name)
                    .font(.title2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                
                Divider().padding(.top, 2).padding(.bottom, 4)
                
                Text(location.type)
                    .font(.body)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                
                Text(location.dimension)
                    .font(.body)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .padding(.horizontal, 8)
            
//            ResidentsSectionView()
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(.cardCornerRadius)
        .cardShadow()
        .defaultHMargin()
    }
    
    @ViewBuilder
    private func ResidentsSectionView() -> some View {
        Text("residents")
            .font(.headline)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
            .padding(.horizontal, 8)
        
        if location.residentsIds.count > 0 {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(location.residentsIds, id: \.self) { id in
                        Text("\(id)")
                            .font(.body)
                            .padding()
                    }
                }
                .padding(.horizontal, 8)
            }
        }
    }
}
