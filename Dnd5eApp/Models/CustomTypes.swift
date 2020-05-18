//
//  CustomTypes.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 18.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Combine

typealias SpellDetailConstructor = (String) -> SpellDetailView
typealias SpellListPublisherConstructor = (String) -> AnyPublisher<[SpellDTO], Error>
typealias SpellListPublisher = AnyPublisher<[SpellDTO], Error>
typealias SpellDetailPublisher = AnyPublisher<SpellDTO, Error>
