//
//  SpellDTO.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 08.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

struct SpellDTO: Equatable, Identifiable {
    typealias ID = String
    var id: String { return name }

    let name: String
    let path: String
    let level: Int?
    let description: String?
    let castingTime: String?
    let concentration: Bool?
}

extension SpellDTO: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case path = "url"
        case level
        case description = "desc"
        case castingTime = "casting_time"
        case concentration
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try values.decode(String.self, forKey: .name)
        path = try values.decode(String.self, forKey: .path)
        level = try values.decodeIfPresent(Int.self, forKey: .level)
        castingTime = try values.decodeIfPresent(String.self, forKey: .castingTime)
        concentration = try values.decodeIfPresent(Bool.self, forKey: .concentration)
        let array = try values.decodeIfPresent([String].self, forKey: .description)
        description = array?.first
    }
}
