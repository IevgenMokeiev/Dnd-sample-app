//
//  NetworkService.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 4/18/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

struct Response: Codable {
    public let results: [SpellDTO]
}

private enum Endpoints: String {
    case spellList = "http://dnd5eapi.co/api/spells"
    case spellDetails = "http://dnd5eapi.co"
}

public enum NetworkServiceError: Error {
    case incorrectURL
    case downloadFailed
    case invalidResponseStatusCode
    case invalidResponseData
}

protocol NetworkService {
//    func downloadSpellList() -> AnyPublisher<[SpellDTO], Error>
//    func downloadSpell() -> AnyPublisher<SpellDTO, Error>
    func downloadSpellList(_ completionHandler: @escaping (Result<[SpellDTO], NetworkServiceError>) -> Void)
    func downloadSpell(with path: String, _ completionHandler: @escaping (Result<SpellDTO, NetworkServiceError>) -> Void)
}

class NetworkServiceImpl: NetworkService {
    internal var urlSessionProtocolClasses: [AnyClass]?

    private var cancellable: AnyCancellable?
    
    func downloadSpellList(_ completionHandler: @escaping (Result<[SpellDTO], NetworkServiceError>) -> Void) {

        guard let url = URL(string: Endpoints.spellList.rawValue) else {
            completionHandler(.failure(.incorrectURL)); return
        }

        self.cancellable = downloadContent(with: url, decodingType: Response.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    completionHandler(.failure(.invalidResponseData))
                }
            }, receiveValue: { response in
                let spells = response.results
                completionHandler(.success(spells))
            })
    }
    
    func downloadSpell(with path: String, _ completionHandler: @escaping (Result<SpellDTO, NetworkServiceError>) -> Void) {

        guard let url = URL(string: Endpoints.spellDetails.rawValue + path) else {
            completionHandler(.failure(.incorrectURL)); return
        }

        self.cancellable = downloadContent(with: url, decodingType: SpellDTO.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    completionHandler(.failure(.invalidResponseData))
                }
            }, receiveValue: { spell in
                completionHandler(.success(spell))
            })
    }
    
    func downloadContent<T: Decodable>(with url: URL, decodingType: T.Type) -> AnyPublisher<T, Error> {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = self.urlSessionProtocolClasses

        return URLSession(configuration: configuration).dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .map { $0.data }
            .decode(type: decodingType.self , decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
