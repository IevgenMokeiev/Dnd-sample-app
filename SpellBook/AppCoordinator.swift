//
//  AppCoordinator.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

@MainActor
class AppCoordinator {
    let viewFactory: ViewFactory

    init() {
        guard let databaseClient = try? DatabaseClient() else {
            fatalError()
        }
        let databaseService = DatabaseService(databaseClient: databaseClient)
        let networkService = NetworkService(networkClient: NetworkClient())
        let refinementsService = RefinementsService()
        let interactor = Interactor(databaseService: databaseService, networkService: networkService, refinementsService: refinementsService)
        viewFactory = ViewFactory(interactor: interactor)
    }
}
