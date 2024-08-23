//
//  RemoteService.swift
//  RickMortyAndUlises
//
//  Created by Ulises Cervera Páez on 21/6/24.
//

import Foundation

final class RemoteService {
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()
    
    func get<T: Decodable>(endpoint: RemoteEndpoint, type: T.Type = T.self) async -> Result<T, RemoteError> {
        return await request(endpoint: endpoint, type: type)
    }
    
    private func request<T: Decodable>(endpoint: RemoteEndpoint, type: T.Type, timeoutRetries: Int = 1) async -> Result<T, RemoteError> {
        let formattedUrl = endpoint.toString()
        guard let url = URL(string: formattedUrl) else { return .failure(.invalidURL) }
        
        let request = URLRequest(url: url)
        
        do {
            Util.print(">>> \(formattedUrl)")
            
            let (data, res) = try await URLSession.shared.data(for: request)
            guard let response = res as? HTTPURLResponse else { return .failure(.invalidResponse) }
            
            print(response: response, data: data)
            
            switch response.statusCode {
                case 200..<300:
                    do {
                        let parsed = try decoder.decode(T.self, from: data)
                        return .success(parsed)
                    } catch let error {
                        return .failure(.decoding(String(describing: error)))
                    }
                    
                case 400..<500:
                    if response.statusCode == 404 {
                        return .failure(.notFound)
                    }
                    return .failure(.badRequest)
                    
                case 500...Int.max:
                    return .failure(.error500)
                    
                default:
                    return .failure(.unknown)
            }
        } catch let error {
            Util.print("<<< ERROR \(formattedUrl)")
            
            if let urlError = error as? URLError, urlError.code == .timedOut {
                if timeoutRetries > 0 {
                    return await self.request(endpoint: endpoint, type: type, timeoutRetries: timeoutRetries - 1)
                } else {
                    return .failure(.timeout)
                }
            }
            
            return .failure(.unknown)
        }
    }
    
    private func print(response: HTTPURLResponse, data: Data) {
        let url = response.url?.absoluteString ?? ""
        var body = ""
        
        if let anyJSON = try? JSONSerialization.jsonObject(with: data),
           let anyData = try? JSONSerialization.data(withJSONObject: anyJSON, options: .prettyPrinted),
           let str = String(data: anyData, encoding: .utf8) {
            body = str
        }
        
        Util.print("<<< (\(response.statusCode)) \(url)\nBODY: \(body)")
    }
}
