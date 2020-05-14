//
//  NetworkService.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 4/18/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

struct Response: Codable {
    public let results: [SpellDTO]
}

private enum Endpoints: String {
    case spellList = "http://dnd5eapi.co/api/spells"
    case spellDetails = "http://dnd5eapi.co"
}

public enum NetworkServiceError: Error {
    case invalidURL
    case downloadFailed
    case invalidResponseStatusCode
    case invalidResponseData
}

protocol NetworkService {
    func spellListPublisher() -> AnyPublisher<[SpellDTO], NetworkServiceError>
    func spellDetailPublisher(for path: String) -> AnyPublisher<SpellDTO, NetworkServiceError>
}

class NetworkServiceImpl: NetworkService {
    internal var urlSessionProtocolClasses: [AnyClass]?
    
    func spellListPublisher() -> AnyPublisher<[SpellDTO], NetworkServiceError> {
        guard let url = URL(string: Endpoints.spellList.rawValue) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        return contentPublisher(for: url, decodingType: Response.self)
            .map { $0.results }
            .eraseToAnyPublisher()
    }
    
    func spellDetailPublisher(for path: String) -> AnyPublisher<SpellDTO, NetworkServiceError> {
        guard let url = URL(string: Endpoints.spellDetails.rawValue + path) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        return contentPublisher(for: url, decodingType: SpellDTO.self)
    }
    
    func contentPublisher<T: Decodable>(for url: URL, decodingType: T.Type) -> AnyPublisher<T, NetworkServiceError> {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = urlSessionProtocolClasses

        return URLSession(configuration: configuration).dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .map { $0.data }
            .decode(type: decodingType.self , decoder: JSONDecoder())
            .mapError { _ in NetworkServiceError.invalidResponseData }
            .eraseToAnyPublisher()
    }
}
