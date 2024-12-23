//
//  Spell.swift
//  SpellBook
//
//  Created by Eugene Mokeiev on 23.12.2024.
//  Copyright © 2024 Ievgen. All rights reserved.
//

import SwiftData

@available(iOS 17, *)
@Model
final class Spell: Equatable {
    var castingTime: String
    var classes: String
    var components: String
    var isConcentration: Bool
    var spellDescription: String
    var duration: String
    var higherLevel: String
    var isFavorite: Bool
    var level: Int
    var material: String
    var name: String
    var page: String
    var path: String
    var range: String
    var ritual: String
    var school: String
    var subclasses: String
    
    init(
        castingTime: String,
        classes: String,
        components: String,
        isConcentration: Bool,
        spellDescription: String,
        duration: String,
        higherLevel: String,
        isFavorite: Bool,
        level: Int,
        material: String,
        name: String,
        page: String,
        path: String,
        range: String,
        ritual: String,
        school: String,
        subclasses: String
    ) {
        self.castingTime = castingTime
        self.classes = classes
        self.components = components
        self.isConcentration = isConcentration
        self.spellDescription = spellDescription
        self.duration = duration
        self.higherLevel = higherLevel
        self.isFavorite = isFavorite
        self.level = level
        self.material = material
        self.name = name
        self.page = page
        self.path = path
        self.range = range
        self.ritual = ritual
        self.school = school
        self.subclasses = subclasses
    }
    
    convenience init(with spellDTO: SpellDTO){
        self.init(
            castingTime: spellDTO.castingTime ?? "",
            classes: spellDTO.classes ?? "",
            components: "",
            isConcentration: spellDTO.isConcentration ?? false,
            spellDescription: spellDTO.description ?? "",
            duration: "",
            higherLevel: "",
            isFavorite: spellDTO.isFavorite,
            level: spellDTO.level ?? 0,
            material: "",
            name: spellDTO.name,
            page: "",
            path: spellDTO.path,
            range: "",
            ritual: "",
            school: "",
            subclasses: ""
        )
    }
    
    func populate(with dto: SpellDTO) {
        name = dto.name
        path = dto.path
        level = dto.level ?? 0
        castingTime = dto.castingTime ?? ""
        isConcentration = dto.isConcentration ?? false
        classes = dto.classes ?? ""
        spellDescription = dto.description ?? ""
        isFavorite = dto.isFavorite
    }
    
    func convertToDTO() -> SpellDTO {
        return SpellDTO(
            name: self.name,
            path: self.path,
            level: self.level,
            castingTime: self.castingTime,
            isConcentration: self.isConcentration,
            classes: self.classes,
            description: self.spellDescription,
            isFavorite: self.isFavorite
        )
    }
}
