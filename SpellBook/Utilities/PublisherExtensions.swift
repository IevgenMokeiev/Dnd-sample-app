//
//  PublisherExtensions.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 02.04.2022.
//  Copyright © 2022 Ievgen. All rights reserved.
//

import Foundation
import Combine

extension Publisher {

  func fallback(_ otherPublisher: AnyPublisher<Self.Output, Self.Failure>) -> AnyPublisher<Self.Output, Self.Failure> {
    return self.catch { _ in
      return otherPublisher
    }.eraseToAnyPublisher()
  }
}

