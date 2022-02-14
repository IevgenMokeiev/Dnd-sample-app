//
//  PublisherExtensions.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 14.02.2022.
//  Copyright © 2022 Ievgen. All rights reserved.
//

import Combine

extension Publisher {
  func asyncMap<T>(
    _ transform: @escaping (Output) async throws -> T
  ) -> Publishers.FlatMap<Future<T, Error>, Publishers.SetFailureType<Self, Error>> {
    flatMap { value in
      Future { promise in
        Task {
          do {
            let output = try await transform(value)
            promise(.success(output))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
  }
}
