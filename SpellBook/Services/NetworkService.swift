//
//  NetworkService.swift
//  SpellBookApp
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

/// Service responsible for network communication
protocol NetworkService {
  var spellListPublisher: SpellListPublisher { get }
  func spellDetailPublisher(for path: String) -> SpellDetailPublisher
}

class NetworkServiceImpl: NetworkService {
  
  let networkClient: NetworkClient
  
  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }
  
  var spellListPublisher: SpellListPublisher {
    guard let url = URL(string: Endpoints.spellList.rawValue) else {
      return Fail(error: .network(.invalidURL))
        .eraseToAnyPublisher()
    }
    
    return networkClient.performRequest(to: url, expectedType: Response.self)
      .map { $0.results }
      .eraseToAnyPublisher()
  }
  
  func spellDetailPublisher(for path: String) -> SpellDetailPublisher {
    guard let url = URL(string: Endpoints.spellDetails.rawValue + path) else {
      return Fail(error: .network(.invalidURL)).eraseToAnyPublisher()
    }
    
    return networkClient.performRequest(to: url, expectedType: SpellDTO.self)
  }
}
