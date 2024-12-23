//
//  SpellDTO.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 08.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

struct SpellDTO: Equatable, Sendable, Identifiable {
    typealias ID = String
    var id: String { return name }

    let name: String
    let path: String
    let level: Int?
    let castingTime: String?
    let isConcentration: Bool?
    let classes: String?
    let description: String?
    let isFavorite: Bool

    func toggleFavorite(value: Bool) -> SpellDTO {
        return SpellDTO(name: name, path: path, level: level, castingTime: castingTime, isConcentration: isConcentration, classes: classes, description: description, isFavorite: value)
    }
}

extension SpellDTO: Codable {
    struct ClassObject: Codable {
        let name: String
        let url: String

        enum CodingKeys: String, CodingKey {
            case name
            case url
        }
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case path = "url"
        case level
        case castingTime = "casting_time"
        case isConcentration = "concentration"
        case classes
        case description = "desc"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try values.decode(String.self, forKey: .name)
        path = try values.decode(String.self, forKey: .path)
        level = try values.decodeIfPresent(Int.self, forKey: .level)
        castingTime = try values.decodeIfPresent(String.self, forKey: .castingTime)
        isConcentration = try values.decodeIfPresent(Bool.self, forKey: .isConcentration)
        let descriptionArray = try values.decodeIfPresent([String].self, forKey: .description)
        description = descriptionArray?.joined(separator: "\n\n")

        let classesArray = try values.decodeIfPresent([ClassObject].self, forKey: .classes)
        let namesArray = classesArray?.map { $0.name }
        classes = namesArray?.joined(separator: ", ")
        isFavorite = false
    }
    
    var isPopulated: Bool {
        guard let description else { return false }
        return !description.isEmpty
    }
}
