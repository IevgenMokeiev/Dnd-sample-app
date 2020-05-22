//
//  NetworkClient.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

public enum NetworkClientError: Error {
    case invalidURL
    case decodingFailed
    case invalidResponseStatusCode
    case sessionFailed(Error)
    case other(Error)
}

protocol NetworkClient {
    func endpointPublisher<T: Decodable>(for url: URL, decodingType: T.Type) -> AnyPublisher<T, NetworkServiceError>
}

class NetworkClientImpl: NetworkClient {

    internal var urlSessionProtocolClasses: [AnyClass]?

    func endpointPublisher<T: Decodable>(for url: URL, decodingType: T.Type) -> AnyPublisher<T, NetworkServiceError> {
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
                case is DecodingError:
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
