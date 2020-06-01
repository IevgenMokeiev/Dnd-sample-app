//
//  AddSpellViewModel.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 01.06.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

class AddSpellViewModel: ObservableObject {
    var name: String = ""
    var level: String = ""
    var castingTime: String = ""
    var concentration: String = ""
    var classes: String = ""
    var description: String = ""
    var higherLevel: String = ""

    var spellDTO: SpellDTO {
        return SpellDTO(name: name, path: "api/spells/" + name, level: Int(level), castingTime: castingTime, concentration: concentration == "true" ? true : false, classes: classes, description: description, higherLevel: higherLevel, isFavorite: false)
    }
}
