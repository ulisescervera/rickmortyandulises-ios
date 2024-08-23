//
//  LocationViewModel.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 14/8/24.
//

import Foundation
import Combine

final class LocationViewModel: ObservableObject {
    
    @Published private      var pages: [UIState<Page<LocationModel>>] = []
    @Published private(set) var locations: [LocationModel] = []
    @Published private(set) var isLoadingAPage: Bool = false
    
    private let repository: AppRepository
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(repository: AppRepository = AppRepositoryImpl.shared) {
        self.repository = repository
        
        $pages.sink { [weak self] pages in
            self?.isLoadingAPage = pages.last?.isLoading ?? false
            self?.locations = pages.flatMap { $0.data?.data ?? [] }
        }
        .store(in: &cancellables)
        
        fetchLocationsNextPage()
    }
    
    func fetchLocationsNextPage() {
        let page: Int? = if case .success(let page) = pages.last {
            page.nextPage
        } else if pages.isEmpty { 0 } else { nil }
        
        guard let page else { return }
        
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            pages.append(.loading)
            let result = await repository.getLocations(page)
            
            self.pages[pages.count - 1] = switch result {
                case .success(let data):
                        .success(data)
                case .failure(let error):
                        .error(error)
            }
        }

    }
}
