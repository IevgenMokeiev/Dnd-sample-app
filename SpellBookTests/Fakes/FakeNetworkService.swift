//
//  FakeNetworkService.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

@testable import SpellBook

class FakeNetworkService: NetworkService {
  
  static var spellListHandler: (() -> Result<[SpellDTO], CustomError>)?
  static var spellDetailHandler: (() -> Result<SpellDTO, CustomError>)?
  
  var spellListPublisher: SpellListPublisher {
    guard let handler = Self.spellListHandler else {
      fatalError("Handler is unavailable.")
    }
    return Result.Publisher(handler()).eraseToAnyPublisher()
  }
  
  func spellDetailPublisher(for path: String) -> SpellDetailPublisher {
    guard let handler = Self.spellDetailHandler else {
      fatalError("Handler is unavailable.")
    }
    return Result.Publisher(handler()).eraseToAnyPublisher()
  }
}
