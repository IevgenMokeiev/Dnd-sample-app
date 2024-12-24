//
//  MockNetworkService.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

@testable import SpellBook

final class MockNetworkService: NetworkServiceProtocol {
    let mockSpellList: [SpellDTO]
    let mockSpellDetails: SpellDTO
    
    init(mockSpellList: [SpellDTO], mockSpellDetails: SpellDTO) {
        self.mockSpellList = mockSpellList
        self.mockSpellDetails = mockSpellDetails
    }
    
    func getSpellList() async throws -> [SpellDTO] {
        mockSpellList
    }
    
    func getSpellDetails(for path: String) async throws -> SpellDTO {
        mockSpellDetails
    }
}
