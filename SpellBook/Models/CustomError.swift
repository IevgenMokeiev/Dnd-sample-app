//
//  CustomError.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 01.04.2022.
//  Copyright © 2022 Ievgen. All rights reserved.
//

import Foundation

enum CustomError: Error {

  case network(NetworkClientError)
  case database(DatabaseClientError)
  case other(Error)
}

extension Error {
  var transformToCustom: CustomError {
    switch self {
    case is NetworkClientError:
      return .network(self as! NetworkClientError)
    case is DatabaseClientError:
      return .database(self as! DatabaseClientError)
    default:
      return .other(self)
    }
  }
}
