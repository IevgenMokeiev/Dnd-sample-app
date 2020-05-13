//
//  ParsingService.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 12.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

enum ParsingError: Error {
    case generalError
}

struct Response: Codable {
    public let results: [SpellDTO]
}

protocol ParsingService {
    func parseFrom(spellListData: Data) -> Result<[SpellDTO], ParsingError>
    func parseFrom(spellDetailData: Data) -> Result<SpellDTO, ParsingError>
}

class ParsingServiceImpl: ParsingService {
    
    private let decoder = JSONDecoder()

    func parseFrom(spellListData: Data) -> Result<[SpellDTO], ParsingError> {
        do {
            let spellsData = try decoder.decode(Response.self, from: spellListData)
            let spells = spellsData.results
            return .success(spells)
        } catch {
            return .failure(.generalError)
        }
    }

    func parseFrom(spellDetailData: Data) -> Result<SpellDTO, ParsingError> {
        do {
            let spell = try decoder.decode(SpellDTO.self, from: spellDetailData)
            return .success(spell)
        } catch {
            return .failure(.generalError)
        }
    }
}
