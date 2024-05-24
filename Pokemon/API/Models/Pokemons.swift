//
//  Pokemons.swift
//  Pokemon
//
//  Created by Chaitanya Pandit on 22/05/24.
//

import Foundation

public struct PokemonsRequest: Encodable, Requestable {
    let limit: Int?
    let offset: Int?
        
    func request() throws -> URLRequest {
        return try URLRequest.get(path: "pokemon", params: self)
    }
}

public struct PokemonsResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
    
    var nextOffset: Int? {
        guard let next = next,
              let offsetString = URL(string: next)?.params?["offset"] else {
            return nil
        }
        
        return Int(offsetString)
    }
    
    var nextLimit: Int? {
        guard let next = next,
              let offsetString = URL(string: next)?.params?["limit"] else {
            return nil
        }
        
        return Int(offsetString)
    }
}

public struct Pokemon: Decodable, Equatable {
    let name: String
    let url: String
    
    var id: Int {
        guard let identifier = URL(string: url)?.lastPathComponent,
        let id = Int(identifier) else {
            return 0
        }
        
        return id
    }
}
