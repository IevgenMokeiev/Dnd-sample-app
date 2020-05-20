//
//  AppCoordinator.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

/// Entry point for app's data layer and view factory
/// Uses dependency injection to instantiate all services in a single place
class AppCoordinator {
    let viewFactory: ViewFactory

    init() {
        let translationServiceImpl = TranslationServiceImpl()
        let coreDataStackImpl = CoreDataStackImpl()
        let databaseServiceImpl = DatabaseServiceImpl(coreDataStack: coreDataStackImpl, translationService: translationServiceImpl)
        let networkServiceImpl = NetworkServiceImpl()
        let refinementsServiceImpl = RefinementsServiceImpl()
        let dataLayer = DataLayerImpl(databaseService: databaseServiceImpl, networkService: networkServiceImpl, refinementsService: refinementsServiceImpl)
        self.viewFactory = ViewFactoryImpl(dataLayer: dataLayer)
    }
}
