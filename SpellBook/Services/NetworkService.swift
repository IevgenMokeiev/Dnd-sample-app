//
//  NetworkService.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 4/18/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//


import Foundation

struct Response: Codable {
    public let results: [SpellDTO]
}

private enum Endpoints: String {
    case spellList = "http://dnd5eapi.co/api/spells"
    case spellDetails = "http://dnd5eapi.co"
}

protocol NetworkServiceProtocol: Sendable {
    func getSpellList() async throws -> [SpellDTO]
    func getSpellDetails(for path: String) async throws -> SpellDTO
}

final class NetworkService: NetworkServiceProtocol {
    let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getSpellList() async throws -> [SpellDTO] {
        guard let url = URL(string: Endpoints.spellList.rawValue) else {
            throw CustomError.network(.invalidURL)
        }
        let response = try await networkClient.performRequest(to: url, expectedType: Response.self)
        return response.results
    }

    func getSpellDetails(for path: String) async throws -> SpellDTO {
        guard let url = URL(string: Endpoints.spellDetails.rawValue + path) else {
            throw CustomError.network(.invalidURL)
        }
        return try await networkClient.performRequest(to: url, expectedType: SpellDTO.self)
    }
}
