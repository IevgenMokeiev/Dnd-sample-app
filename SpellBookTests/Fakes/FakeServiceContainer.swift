//
//  FakeServiceContainer.swift
//  SpellBookTests
//
//  Created by Yevhen Mokeiev on 25.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

@testable import SpellBook

struct FakeServiceContainer: ServiceContainer {
  let spellProviderService: SpellProviderService
  let refinementsService: RefinementsService
  
  init() {
    self.spellProviderService = FakeSpellProviderService()
    self.refinementsService = FakeRefinementsService()
  }
}
