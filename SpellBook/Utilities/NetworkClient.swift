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
  func performRequest<T: Decodable>(to url: URL, expectedType: T.Type) async throws -> T
}

class NetworkClientImpl: NetworkClient {

  private let protocolClasses: [AnyClass]?

  init(protocolClasses: [AnyClass]? = nil) {
    self.protocolClasses = protocolClasses
  }

  func performRequest<T: Decodable>(to url: URL, expectedType: T.Type) async throws -> T {
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = protocolClasses

    let (data, response) = try await URLSession(configuration: configuration).data(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
            throw NetworkClientError.invalidResponseStatusCode
          }

    return try JSONDecoder().decode(expectedType.self, from: data)
  }
}
