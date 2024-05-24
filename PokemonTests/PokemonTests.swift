//
//  PokemonTests.swift
//  PokemonTests
//
//  Created by Chaitanya Pandit on 24/05/24.
//

import XCTest

final class PokemonTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        URLProtocol.registerClass(MockURLProtocol.self)
    }

    override func tearDown() {
        URLProtocol.unregisterClass(MockURLProtocol.self)
        super.tearDown()
    }
    
    func testFetchPokemonsSuccess() async throws {
        let mockData = """
        {
            "count": 1118,
            "next": "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
            "previous": null,
            "results": [
                {"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"},
                {"name": "ivysaur", "url": "https://pokeapi.co/api/v2/pokemon/2/"}
            ]
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, mockData)
        }
        
        let request = PokemonsRequest(limit: 20, offset: 0)
        let response: PokemonsResponse = try await API.fetch(request)
        
        XCTAssertEqual(response.count, 1118)
        XCTAssertEqual(response.results.count, 2)
        XCTAssertEqual(response.results[0].name, "bulbasaur")
        XCTAssertEqual(response.results[0].id, 1)
        XCTAssertEqual(response.results[1].name, "ivysaur")
        XCTAssertEqual(response.results[1].id, 2)
    }
}

import XCTest

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Request handler is unavailable.")
            return
        }
        
        let (response, data) = handler(request)
        
        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        // Required method to conform to URLProtocol, can be left empty
    }
}
