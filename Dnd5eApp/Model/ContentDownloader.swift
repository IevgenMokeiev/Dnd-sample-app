//
//  ContentDownloader.swift
//  Dnd5eApp
//
//  Created by Ievgen on 4/18/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//

import Foundation

enum DownloadingError: Int {
    case incorrectURL
    case downloadFailed
    case invalidResponseStatusCode
    case invalidResponseData
}

class ContentDownloader {
    
    internal var urlSessionProtocolClasses: [AnyClass]?
    static let spellsURLString = "http://dnd5eapi.co/api/spells"
    
    public func downloadContent(with completionHandler: (_ result: [String: Any], _ error: Error) -> Void) {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = self.urlSessionProtocolClasses
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        guard let spellsUrl  = URL(string: type(of: self).spellsURLString) else { return }
        
        session.dataTask(with: spellsUrl) { (data, response, error) in
            guard let jsonData = data else { return }
            let dictionary = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
        }.resume()
    }
}
