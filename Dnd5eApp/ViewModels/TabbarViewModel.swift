//
//  TabbarViewModel.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 20.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

class TabbarViewModel {
    let spellListConstructor: SpellListViewConstructor

    init(spellListConstructor: @escaping SpellListViewConstructor) {
        self.spellListConstructor = spellListConstructor
    }
}
