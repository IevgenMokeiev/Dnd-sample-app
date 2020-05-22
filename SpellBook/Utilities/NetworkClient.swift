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
    func performRequest<T: Decodable>(to url: URL, expectedType: T.Type) -> AnyPublisher<T, NetworkClientError>
}

class NetworkClientImpl: NetworkClient {

    private var protocolClasses: [AnyClass]?

    init(protocolClasses: [AnyClass]? = nil) {
        self.protocolClasses = protocolClasses
    }

    func performRequest<T: Decodable>(to url: URL, expectedType: T.Type) -> AnyPublisher<T, NetworkClientError> {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = protocolClasses

        return URLSession(configuration: configuration).dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw NetworkClientError.invalidResponseStatusCode
                }
                return data
            }
            .decode(type: expectedType.self , decoder: JSONDecoder())
            .mapError { error in
                switch error {
                case is DecodingError:
                    return .decodingFailed
                case is URLError:
                    return .sessionFailed(error)
                default:
                    return .other(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
