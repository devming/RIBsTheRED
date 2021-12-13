//
//  SuperAppURLProtocol.swift
//  MiniSuperApp
//
//  Created by devming on 2021/12/13.
//

import Foundation

typealias Path = String
typealias MockResponse = (statusCode: Int, data: Data?)

/// Test를 위한 Mock URLProtocol
final class SuperAppURLProtocol: URLProtocol {
    static var successMock: [Path: MockResponse] = [:]
    static var failureErrors: [Path: Error] = [:]
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let path = request.url?.path {
            if let mockResponse = Self.successMock[path] {
                client?.urlProtocol(
                    self,
                    didReceive: HTTPURLResponse(
                        url: request.url!,
                        statusCode: mockResponse.statusCode,
                        httpVersion: nil,
                        headerFields: nil
                    )!,
                    cacheStoragePolicy: .notAllowed
                )
                mockResponse.data.map { client?.urlProtocol(self, didLoad: $0) }
            } else if let error = SuperAppURLProtocol.failureErrors[path] {
                client?.urlProtocol(self, didFailWithError: error)
            } else {
                client?.urlProtocol(self, didFailWithError: MockSessionError.notSupported)
            }
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    // stopLoading은 override하지 않으면 크래시남
    override func stopLoading() { }
}

enum MockSessionError: Error {
    case notSupported
}
