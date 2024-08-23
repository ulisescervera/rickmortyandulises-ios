//
//  CharacterViewModel.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 21/6/24.
//

import Foundation
import Combine

@MainActor
final class CharacterViewModel: ObservableObject {
    
    @Published private      var pages: [UIState<Page<CharacterModel>>] = []
    @Published private(set) var characters: [CharacterModel] = []
    @Published private(set) var selectedCharacter: UIState<CharacterModel> = .idle
    @Published private(set) var isLoadingAPage: Bool = false
    
    private let repository: AppRepository
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(repository: AppRepository = AppRepositoryImpl.shared) {
        self.repository = repository
        
        $pages.sink { [weak self] pages in
            self?.isLoadingAPage = pages.last?.isLoading ?? false
            self?.characters = pages.flatMap { $0.data?.data ?? [] }
        }
        .store(in: &cancellables)
        
        fetchCharactersNextPage()
    }
    
    func fetchCharacter(by id: Int) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            selectedCharacter = .loading
            let result = await repository.getCharacter(id)
            switch result {
                case .success(let data):
                    selectedCharacter = .success(data)
                case .failure(let error):
                    selectedCharacter = .error(error)
            }
        }
    }
    
    func fetchCharactersNextPage() {
        let page: Int? = if case .success(let page) = pages.last {
            page.nextPage
        } else if pages.isEmpty { 0 } else { nil }
        
        guard let page else { return }
        
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            pages.append(.loading)
            let result = await repository.getCharacters(page)
            
            self.pages[pages.count - 1] = switch result {
                case .success(let data):
                        .success(data)
                case .failure(let error):
                        .error(error)
            }
        }
    }
    
    func reloadCharacters() {
        pages = []
        fetchCharactersNextPage()
    }
}
