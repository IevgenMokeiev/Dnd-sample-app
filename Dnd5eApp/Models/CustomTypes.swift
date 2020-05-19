//
//  CustomTypes.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 18.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Combine

enum Sort {
    case name
    case level
}

typealias SpellDetailConstructor = (_ path: String) -> SpellDetailView
typealias SpellListPublisherConstructor = (_ searchTerm: String, _ sort: Sort) -> AnyPublisher<[SpellDTO], Error>
typealias SpellListPublisher = AnyPublisher<[SpellDTO], Error>
typealias SpellDetailPublisher = AnyPublisher<SpellDTO, Error>
