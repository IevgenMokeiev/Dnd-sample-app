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
    func downloadSpellList(_ completionHandler: @escaping (_ result: [[String: Any]]?, _ error: NetworkServiceError?) -> Void)
    func downloadSpell(with path: String, _ completionHandler: @escaping (_ result: [String: Any]?, _ error: NetworkServiceError?) -> Void)
}

class NetworkServiceImpl: NetworkService {

    internal var urlSessionProtocolClasses: [AnyClass]?
    
    func downloadSpellList(_ completionHandler: @escaping (_ result: [[String: Any]]?, _ error: NetworkServiceError?) -> Void){
        self.downloadContent(with: URL(string: Endpoints.spellList.rawValue)) { (resultDict, error) in
            guard let array = resultDict?["results"] as? [[String: Any]] else { completionHandler(nil, .invalidResponseData); return }
            completionHandler(array, error)
        }
    }
    
    func downloadSpell(with path: String, _ completionHandler: @escaping (_ result: [String: Any]?, _ error: NetworkServiceError?) -> Void) {
        let url = URL(string: Endpoints.spellDetails.rawValue + path)
            self.downloadContent(with: url) { (resultDict, error) in
            completionHandler(resultDict, error)
        }
    }
    
    func downloadContent(with url: URL?, completionHandler: @escaping (_ result: [String: Any]?, _ error: NetworkServiceError?) -> Void) {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = self.urlSessionProtocolClasses
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        guard let spellsUrl = url else { completionHandler(nil, .incorrectURL); return }
        
        session.dataTask(with: spellsUrl) { (data, response, error) in
            guard let jsonData = data else { completionHandler(nil, .invalidResponseData); return }
            do {
                let dictionary = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
                completionHandler(dictionary, nil)
            } catch {
                completionHandler(nil, .invalidResponseData)
            }
        }.resume()
    }
}
