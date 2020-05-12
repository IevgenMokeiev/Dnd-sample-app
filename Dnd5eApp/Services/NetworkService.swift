//
//  NetworkService.swift
//  Dnd5eApp
//
//  Created by Ievgen on 4/18/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//

import Foundation

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
    func downloadSpellList(_ completionHandler: @escaping (Result<[[String: Any]], NetworkServiceError>) -> Void)
    func downloadSpell(with path: String, _ completionHandler: @escaping (Result<[String: Any], NetworkServiceError>) -> Void)
}

class NetworkServiceImpl: NetworkService {

    internal var urlSessionProtocolClasses: [AnyClass]?
    
    func downloadSpellList(_ completionHandler: @escaping (Result<[[String: Any]], NetworkServiceError>) -> Void) {
        
        downloadContent(with: URL(string: Endpoints.spellList.rawValue)) { result in
            switch result {
            case .success(let resultDict):
                if let array = resultDict["results"] as? [[String: Any]] {
                    completionHandler(.success(array))
                } else {
                    completionHandler(.failure(.invalidResponseData))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func downloadSpell(with path: String, _ completionHandler: @escaping (Result<[String: Any], NetworkServiceError>) -> Void) {
        let url = URL(string: Endpoints.spellDetails.rawValue + path)
        downloadContent(with: url) { (result) in
            completionHandler(result)
        }
    }
    
    func downloadContent(with url: URL?, completionHandler: @escaping (Result<[String: Any], NetworkServiceError>) -> Void) {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = self.urlSessionProtocolClasses
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        guard let spellsUrl = url else { completionHandler(.failure(.incorrectURL)); return }
        
        session.dataTask(with: spellsUrl) { (data, response, error) in
            guard let jsonData = data else { completionHandler(.failure(.invalidResponseData)); return }
            do {
                if let dictionary = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                    completionHandler(.success(dictionary))
                } else {
                    completionHandler(.failure(.invalidResponseData))
                }
            } catch {
                completionHandler(.failure(.invalidResponseData))
            }
        }.resume()
    }
}
