//
//  NetworkService.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 4/18/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

typealias NetworkSpellPublisher = AnyPublisher<[SpellDTO], NetworkClientError>
typealias NetworkSpellDetailPublisher = AnyPublisher<SpellDTO, NetworkClientError>

struct Response: Codable {
  public let results: [SpellDTO]
}

private enum Endpoints: String {
  case spellList = "http://dnd5eapi.co/api/spells"
  case spellDetails = "http://dnd5eapi.co"
}

/// Service responsible for network communication
protocol NetworkService {
  func spellListPublisher() -> NetworkSpellPublisher
  func spellDetailPublisher(for path: String) -> NetworkSpellDetailPublisher
}

class NetworkServiceImpl: NetworkService {

  let networkClient: NetworkClient

  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }

  func spellListPublisher() -> NetworkSpellPublisher {
    guard let url = URL(string: Endpoints.spellList.rawValue) else {
      return Fail(error: .invalidURL).eraseToAnyPublisher()
    }

    return Future<[SpellDTO], NetworkClientError> { promise in
      Task {
        do {
          let response = try await self.networkClient.performRequest(to: url, expectedType: Response.self)
          promise(.success(response.results))
        } catch {
          let mappedError = { () -> NetworkClientError in
            switch error {
            case is DecodingError:
              return .decodingFailed
            case is URLError:
              return .sessionFailed(error)
            default:
              return .other(error)
            }
          }()
          promise(.failure(mappedError))
        }
      }
    }.eraseToAnyPublisher()
  }

  func spellDetailPublisher(for path: String) -> NetworkSpellDetailPublisher {
    guard let url = URL(string: Endpoints.spellDetails.rawValue + path) else {
      return Fail(error: .invalidURL).eraseToAnyPublisher()
    }

    return Future<SpellDTO, NetworkClientError> { promise in
      Task {
        do {
          let response = try await self.networkClient.performRequest(to: url, expectedType: SpellDTO.self)
          promise(.success(response))
        } catch {
          let mappedError = { () -> NetworkClientError in
            switch error {
            case is DecodingError:
              return .decodingFailed
            case is URLError:
              return .sessionFailed(error)
            default:
              return .other(error)
            }
          }()
          promise(.failure(mappedError))
        }
      }
    }.eraseToAnyPublisher()
  }
}
