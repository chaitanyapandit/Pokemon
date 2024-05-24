//
//  DetailViewModel.swift
//  Pokemon
//
//  Created by Chaitanya Pandit on 22/05/24.
//

import Foundation

@MainActor
public class DetailViewModel: ObservableObject {
    @Published public var details: PokemonDetailsResponse? = nil
    @Published public var loading: Bool = false

    func loadDetails(pokemon: Pokemon) {
        loading = true
        let request = PokemonDetailsRequest(id: pokemon.id)
        Task {
            do {
                let response: PokemonDetailsResponse = try await API.fetch(request)
                await MainActor.run {[weak self] in
                    guard let self = self else {
                        return
                    }
                   
                    self.details = response
                    self.loading = false
                }
            } catch let error {
                self.loading = false
                print("Error: \(error)")
            }
        }
    }
}
