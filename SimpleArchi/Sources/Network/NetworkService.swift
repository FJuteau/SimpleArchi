//
//  Service.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 14/05/2023.
//

import Foundation

/// A layer responsible of fetching data from backend
protocol NetworkServiceType {
    func request<T: Decodable>(urlRequest: URLRequest) async -> Result<T, NetworkError>
}

final class NetworkService: NetworkServiceType {
    func request<T: Decodable>(urlRequest: URLRequest) async -> Result<T, NetworkError> {
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    return .success(decodedResponse)
                } catch {
                    print("***** NetworkService: request: error: decode: desc: \(error.localizedDescription)")
                    return .failure(.decode)
                }
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unknown)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
