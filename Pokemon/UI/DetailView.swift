//
//  DetailView.swift
//  Pokemon
//
//  Created by Chaitanya Pandit on 22/05/24.
//

import SwiftUI

struct DetailView: View {
    @Binding var selection: Pokemon?
    @Binding var showSideBar: Bool
    @ObservedObject var model: DetailViewModel
    @State private var contentHeight: CGFloat = 300

    var body: some View {
        content
            .onChange(of: selection) { _, newValue in
                if let newPokemon = newValue {
                    model.loadDetails(pokemon: newPokemon)
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 3)
            .background(backgroundGradient)
            .cornerRadius(4)
            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
            .onTapGesture {
                if model.details == nil {
                    withAnimation {
                        showSideBar.toggle()
                    }
                }
            }
    }
    
    @ViewBuilder
    private var content: some View {
        if model.loading {
            loader
        } else if let details = model.details {
            detailsView(details)
        } else {
            Text("Please Select")
        }
    }
    
    private var loader: some View {
        VStack(spacing: 10) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading...")
                .frame(maxWidth: 300, alignment: .center)
                .font(.headline)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 50)
    }

    private func detailsView(_ details: PokemonDetailsResponse) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            pokemonImage(details)
            detailsProperties(details)
        }
        .padding()
    }
    
    private func pokemonImage(_ details: PokemonDetailsResponse) -> some View {
        AsyncImage(url: URL(string: String(format: "https://assets.pokemon.com/assets/cms2/img/pokedex/detail/%03d.png", details.id))) { image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
        .frame(width: 150, height: 150)
        .background(Color.white.opacity(0.5))
        .cornerRadius(75)
        .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
    }
    
    private func detailsProperties(_ details: PokemonDetailsResponse) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            property(name: "Name", value: details.name)
            property(name: "ID", value: String(details.id))
            property(name: "Base Experience", value: String(details.base_experience))
            abilitiesView(abilities: details.abilities.map { $0.ability.name })
        }
        .padding(.horizontal)
    }
    
    private func property(name: String, value: String) -> some View {
        HStack(spacing: 10) {
            Text(name)
                .bold()
                .font(.headline)
                .textCase(.uppercase)
                .foregroundColor(.white)
            Text(value)
                .font(.body)
                .textCase(.uppercase)
                .foregroundColor(.white)
                .padding(.leading, 5)
        }
        .padding(5)
        .background(Color.blue.opacity(0.5))
        .cornerRadius(10)
    }
    
    private func abilitiesView(abilities: [String]) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 5) {
                Text("Abilities")
                    .bold()
                    .font(.headline)
                    .textCase(.uppercase)
                    .foregroundColor(.white)
                ForEach(abilities, id: \.self) { ability in
                    Text(ability)
                        .font(.body)
                        .textCase(.uppercase)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.orange.opacity(0.7))
                        .cornerRadius(5)
                        .padding(.vertical, 2)
                    Text(ability)
                        .font(.body)
                        .textCase(.uppercase)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.orange.opacity(0.7))
                        .cornerRadius(5)
                        .padding(.vertical, 2)
                    Text(ability)
                        .font(.body)
                        .textCase(.uppercase)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.orange.opacity(0.7))
                        .cornerRadius(5)
                        .padding(.vertical, 2)
                    Text(ability)
                        .font(.body)
                        .textCase(.uppercase)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.orange.opacity(0.7))
                        .cornerRadius(5)
                        .padding(.vertical, 2)
                    Text(ability)
                        .font(.body)
                        .textCase(.uppercase)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.orange.opacity(0.7))
                        .cornerRadius(5)
                        .padding(.vertical, 2)
                    Text(ability)
                        .font(.body)
                        .textCase(.uppercase)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.orange.opacity(0.7))
                        .cornerRadius(5)
                        .padding(.vertical, 2)
                }
            }
            .background(GeometryReader { proxy in
                Color.clear.preference(key: ViewHeightKey.self, value: proxy.size.height)
            })
        }
        .frame(maxWidth: 250, minHeight: 250, maxHeight: contentHeight)
        .onPreferenceChange(ViewHeightKey.self) { height in
            withAnimation {
                contentHeight = height
            }
        }
    }

    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.purple.opacity(0.9), Color.blue.opacity(0.5)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct ViewHeightKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
