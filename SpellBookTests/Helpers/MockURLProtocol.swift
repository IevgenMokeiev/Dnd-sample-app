//
//  MockURLProtocol.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

actor ResponsesMap {
    private(set) var responses: [URL: (data: Data?, response: URLResponse?, error: Error?)] = [:]
    
    func setResponse(response: (data: Data?, response: URLResponse?, error: Error?), for url: URL) {
        responses[url] = response
    }
}

final class MockURLProtocol: URLProtocol {
    static var responsesMap = ResponsesMap()
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        Task {
            guard let url = request.url,
                  let mockResponse = await MockURLProtocol.responsesMap.responses[url] else {
                return
            }
            if let error = mockResponse.error {
                client?.urlProtocol(self, didFailWithError: error)
            } else {
                if let response = mockResponse.response {
                    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                }
                if let data = mockResponse.data {
                    client?.urlProtocol(self, didLoad: data)
                }
                client?.urlProtocolDidFinishLoading(self)
            }
        }
    }
    
    override func stopLoading() {
        // No action needed
    }
}
