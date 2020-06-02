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
    @Published var description: String = ""
    @Published var classes: String = ""
    var concentration: Bool = false
    var higherLevel: String = ""

    var spellDTO: SpellDTO {
        return SpellDTO(name: name, path: "api/spells/" + name, level: Int(level), castingTime: castingTime, concentration: concentration, classes: classes, description: description, higherLevel: higherLevel, isFavorite: false)
    }

    var buttonEnabled: AnyPublisher<Bool, Never> {
        let firstPipeline = $name.zip($level, $castingTime)
        let secondPipeline = $description.zip($classes)
        return firstPipeline.zip(secondPipeline) { firstOutput, secondOutput in
            let (name, level, castingTime) = firstOutput
            let (description, classes) = secondOutput

            guard !name.isEmpty else { return false }
            guard Int(level) != nil else { return false }
            guard !castingTime.isEmpty else { return false }
            guard !description.isEmpty else { return false }
            guard !classes.isEmpty else { return false }
            return true
        }.eraseToAnyPublisher()
    }
}
