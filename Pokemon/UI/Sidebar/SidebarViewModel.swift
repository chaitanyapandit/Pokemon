//
//  PokemonModel.swift
//  Pokemon
//
//  Created by Chaitanya Pandit on 22/05/24.
//

import Foundation

@MainActor
public class SidebarViewModel: ObservableObject {
    @Published public var pokemons: [Pokemon] = []
    @Published public var nextOffset: Int? = 0
    @Published public var nextLimit: Int? = 500
    @Published public var loading: Bool = false
    @Published public var selection: Pokemon? = nil

    public init() {
        loadNext()
    }
    
    public func loadNext() {
        Task {
            let request = PokemonsRequest(limit: nextLimit, offset: nextOffset)
            do {
                self.loading = true
                let response: PokemonsResponse = try await API.fetch(request)
                await MainActor.run {[weak self] in
                    guard let self = self else {
                        return
                    }
                    
                    if self.nextOffset == 0 {
                        self.pokemons = response.results
                    } else {
                        self.pokemons.append(contentsOf: response.results)
                    }
                    self.nextOffset = response.nextOffset
                    self.nextLimit = response.nextLimit
                    self.loading = false
                }
            }  catch let error {
                self.loading = false
                print("ERROR: \(error)")
            }
        }
    }
}
