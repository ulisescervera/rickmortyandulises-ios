//
//  UIState.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 21/6/24.
//

import Foundation

enum UIState<T> {
    case idle
    case loading
    case success(T)
    case error(RemoteError)
    
    var data: T? {
        switch self {
            case .success(let data): data
            default: nil
        }
    }
    
    var isLoading: Bool {
        switch self {
            case .loading: true
            default: false
        }
    }
    
    func map<M>(_ mapper: @escaping (T) -> M) -> UIState<M> {
        return switch self {
            case .loading: .loading
            case .idle: .idle
            case .error(let error): .error(error)
            case .success(let data): .success(mapper(data))
        }
    }
}
