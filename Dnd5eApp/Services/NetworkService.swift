//
//  NetworkService.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 4/18/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

typealias NetworkSpellPublisher = AnyPublisher<[SpellDTO], NetworkServiceError>
typealias NetworkSpellDetailPublisher = AnyPublisher<SpellDTO, NetworkServiceError>

struct Response: Codable {
    public let results: [SpellDTO]
}

private enum Endpoints: String {
    case spellList = "http://dnd5eapi.co/api/spells"
    case spellDetails = "http://dnd5eapi.co"
}

public enum NetworkServiceError: Error {
    case invalidURL
    case decodingFailed
    case invalidResponseStatusCode
    case sessionFailed(Error)
    case other(Error)
}

/// Service responsible for network communication
protocol NetworkService {
    func spellListPublisher() -> NetworkSpellPublisher
    func spellDetailPublisher(for path: String) -> NetworkSpellDetailPublisher
}

class NetworkServiceImpl: NetworkService {
    internal var urlSessionProtocolClasses: [AnyClass]?
    
    func spellListPublisher() -> NetworkSpellPublisher {
        guard let url = URL(string: Endpoints.spellList.rawValue) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        return contentPublisher(for: url, decodingType: Response.self)
            .map { $0.results }
            .eraseToAnyPublisher()
    }
    
    func spellDetailPublisher(for path: String) -> NetworkSpellDetailPublisher {
        guard let url = URL(string: Endpoints.spellDetails.rawValue + path) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        return contentPublisher(for: url, decodingType: SpellDTO.self)
    }
    
    func contentPublisher<T: Decodable>(for url: URL, decodingType: T.Type) -> AnyPublisher<T, NetworkServiceError> {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = urlSessionProtocolClasses

        return URLSession(configuration: configuration).dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw NetworkServiceError.invalidResponseStatusCode
                }
                return data
            }
            .decode(type: decodingType.self , decoder: JSONDecoder())
            .mapError({ error in
                switch error {
                case is Swift.DecodingError:
                    return .decodingFailed
                case is URLError:
                    return .sessionFailed(error)
                default:
                    return .other(error)
                }
            })
            .eraseToAnyPublisher()
    }
}
