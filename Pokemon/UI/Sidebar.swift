//
//  Sidebar.swift
//  Pokemon
//
//  Created by Chaitanya Pandit on 22/05/24.
//

import SwiftUI

struct Sidebar: View {
    @ObservedObject var model: SidebarViewModel
    @Binding var showSidebar: Bool

    var body: some View {
        VStack {
            header
            content
        }
        .background(backgroundColor)
    }
    
    private var header: some View {
        Text("Pokemons")
            .font(.system(size: 20, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
    }

    @ViewBuilder
    private var content: some View {
        if model.pokemons.isEmpty && model.loading {
            loadingView
        } else {
            pokemonListView
        }
    }

    private var loadingView: some View {
        VStack {
            Spacer()
            loader
            Spacer()
        }
    }

    private var pokemonListView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 10) {
                ForEach(model.pokemons, id: \.name) { pokemon in
                    pokemonButton(for: pokemon)
                }
                
                if let _ = model.nextOffset {
                    ProgressView()
                        .scaleEffect(0.5)
                        .padding()
                        .onAppear {
                            model.loadNext()
                        }
                } else {
                    Spacer().frame(height: 50)
                }
            }
            .padding(.vertical)
        }
    }

    private func pokemonButton(for pokemon: Pokemon) -> some View {
        Button(action: {
            model.selection = pokemon
            showSidebar = false
        }) {
            pokemonRow(pokemon)
                .padding()
                .background(gradientBackground)
                .cornerRadius(15)
                .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
        }
        #if os(macOS)
        .buttonStyle(PlainButtonStyle())
        #endif
    }

    private var loader: some View {
        VStack(spacing: 10) {
            ProgressView()
                .scaleEffect(0.5)
            Text("Loading...")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 10)
    }

    private func pokemonRow(_ pokemon: Pokemon) -> some View {
        HStack {
            Text(pokemon.name.capitalized)
                .font(.headline)
                .foregroundColor(.primary)
                .textCase(.uppercase)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var gradientBackground: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var backgroundColor: Color {
        #if os(macOS)
        return Color(NSColor.textBackgroundColor)
        #else
        return Color(UIColor.systemBackground)
        #endif
    }
}
