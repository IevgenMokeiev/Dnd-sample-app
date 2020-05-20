//
//  CustomTypes.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 18.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Combine

/// Custom typealiases which are commonly used in the project
typealias SpellDetailViewConstructor = (_ path: String) -> SpellDetailView
typealias SpellListPublisher = AnyPublisher<[SpellDTO], Error>
typealias SpellDetailPublisher = AnyPublisher<SpellDTO, Error>