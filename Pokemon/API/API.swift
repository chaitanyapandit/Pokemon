//
//  API.swift
//  Pokemon
//
//  Created by Chaitanya Pandit on 22/05/24.
//

import Foundation

protocol Requestable {
    func request() throws -> URLRequest
}

enum APIError: Error {
    case badEncoding
    case badRequest
    case badResponse
    case serverError(code: Int)
}

struct API {
    static func fetch<T: Decodable>(_ requestabe: Requestable) async throws -> T {
        guard let (data, response) =  try await URLSession.shared.data(for: requestabe.request()) as? (Data, HTTPURLResponse) else {
            throw APIError.badResponse
        }
                
        guard (200...399).contains(response.statusCode) else {
            throw APIError.serverError(code: response.statusCode)
        }
        
        let result = try JSONDecoder().decode(T.self, from: data)
        
        return result
    }
}
