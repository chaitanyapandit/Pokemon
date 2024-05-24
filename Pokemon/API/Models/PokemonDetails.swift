//
//  PokemonDetails.swift
//  Pokemon
//
//  Created by Chaitanya Pandit on 22/05/24.
//

import Foundation

public struct PokemonDetailsRequest: Encodable, Requestable {
    let id: Int
        
    func request() throws -> URLRequest {
        return try URLRequest.get(path: "pokemon/\(id)")
    }
}

public struct PokemonDetailsResponse: Decodable, Identifiable {
    let abilities: [AbilityWrapper]
    let base_experience: Int
    public let id: Int
    let name: String
}

public struct AbilityWrapper: Decodable, Equatable, Identifiable {
    let ability: Ability
    let is_hidden: Bool
    let slot: Int
    
    public var id: String {
        return ability.name
    }
}

public struct Ability: Decodable, Equatable {
    let name: String
    let url: String
}
