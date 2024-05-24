//
//  Utils.swift
//  Pokemon
//
//  Created by Chaitanya Pandit on 22/05/24.
//

import Foundation

extension URL {
    static let baseURL: URL = URL(string: "https://pokeapi.co/api/v2")!
    
    public var params: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            return nil
        }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}

extension Encodable {
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw APIError.badEncoding
        }
        
        return dictionary
    }
}

extension URLRequest {
    static func get(path: String, params: Encodable? = nil) throws -> URLRequest {
        guard var urlcomps = URLComponents(string: URL.baseURL.appendingPathComponent(path).absoluteString) else {
            throw APIError.badRequest
        }
        
        if let params = params {
            let paramsDict = try params.toDictionary()
            urlcomps.queryItems = paramsDict.map({ (key, val) in
                URLQueryItem(name: key, value: String(describing: val))
            })
        }
        
        guard let url = urlcomps.url else {
            throw APIError.badRequest
        }
        
        return URLRequest(url: url)
    }
}
