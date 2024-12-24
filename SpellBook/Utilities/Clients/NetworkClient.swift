//
//  NetworkClient.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

public enum NetworkClientError: Error {
    case invalidResponseStatusCode
    case invalidURL
}

protocol NetworkClientProtocol: Sendable {
    func performRequest<T: Decodable>(to url: URL, expectedType: T.Type) async throws -> T
}

final class NetworkClient: NetworkClientProtocol {
    private let protocolClasses: [AnyClass]?

    init(protocolClasses: [AnyClass]? = nil) {
        self.protocolClasses = protocolClasses
    }

    func performRequest<T: Decodable>(to url: URL, expectedType: T.Type) async throws -> T {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = protocolClasses
        
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession(configuration: configuration).data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw NetworkClientError.invalidResponseStatusCode
        }
        return try JSONDecoder().decode(expectedType.self, from: data)
    }
}
