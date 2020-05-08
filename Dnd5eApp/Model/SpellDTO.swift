//
//  SpellDTO.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 08.05.2020.
//  Copyright © 2020 Ievgen. All rights reserved.
//

import Foundation

struct SpellDTO: Equatable, Identifiable {
    typealias ID = String
    var id: String { return name ?? "" }

    let name: String?
    let level: Int?
    let description: String?
    let castingTime: String?
    let concentration: Bool?
    let path: String?
}
