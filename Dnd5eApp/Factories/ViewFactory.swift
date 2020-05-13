//
//  ViewFactory.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import SwiftUI

protocol ViewFactory {
    func provideSpellListView() -> SpellListView
    func provideSpellDetailView(spell: SpellDTO) -> SpellDetailView
}

class ViewFactoryImpl: ViewFactory {

    let dataLayer: DataLayer

    init(dataLayer: DataLayer) {
        self.dataLayer = dataLayer
    }

    func provideSpellListView() -> SpellListView {
        return SpellListView(dataLayer: dataLayer, viewFactory: self)
    }

    func provideSpellDetailView(spell: SpellDTO) -> SpellDetailView {
        return SpellDetailView(dataLayer: dataLayer, spell: spell)
    }
}
