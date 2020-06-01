//
//  AddSpellViewModel.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 01.06.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

class AddSpellViewModel: ObservableObject {

    @Published var name: String = ""
    @Published var level: String = ""
    @Published var castingTime: String = ""
    @Published var concentration: String = ""
    @Published var description: String = ""
    var classes: String = ""
    var higherLevel: String = ""

    var spellDTO: SpellDTO {
        return SpellDTO(name: name, path: "api/spells/" + name, level: Int(level), castingTime: castingTime, concentration: concentration == "true" ? true : false, classes: classes, description: description, higherLevel: higherLevel, isFavorite: false)
    }

    var buttonEnabled: AnyPublisher<Bool, Never> {
        let firstPipeline = $name.zip($level, $castingTime, $concentration)
        return $description.zip(firstPipeline) { description, output in
            guard !description.isEmpty else { return false }
            guard !output.0.isEmpty else { return false }
            guard Int(output.1) != nil else { return false }
            guard !output.2.isEmpty else { return false }
            return true
        }.eraseToAnyPublisher()
    }
}
