//
//  ContentView.swift
//  Pokemon
//
//  Created by Chaitanya Pandit on 22/05/24.
//

import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    @StateObject private var sidebarViewModel = SidebarViewModel()
    @StateObject private var detailViewModel = DetailViewModel()
    @State private var showSidebar = false

    var body: some View {
        Group {
            #if os(macOS)
            macOSView
            #elseif os(iOS)
            iOSView
            #endif
        }
    }
    
    // MARK: - macOS View
    private var macOSView: some View {
        NavigationSplitView {
            Sidebar(model: sidebarViewModel, showSidebar: $showSidebar)
        } detail: {
            NavigationStack(path: $path) {
                DetailView(selection: $sidebarViewModel.selection, showSideBar: $showSidebar, model: detailViewModel)
            }
        }
        .frame(minWidth: 600, minHeight: 450)
    }
    
    // MARK: - iOS View
    private var iOSView: some View {
        NavigationStack(path: $path) {
            ZStack {
                DetailView(selection: $sidebarViewModel.selection, showSideBar: $showSidebar, model: detailViewModel)
                    .toolbar {
                        leadingToolbarItem
                    }
                if showSidebar {
                    sidebarOverlay
                }
            }
            .gesture(dragGesture)
        }
    }


    private var leadingToolbarItem: some ToolbarContent {
        #if os(macOS)
        ToolbarItem(placement: .automatic) {
            Button(action: toggleSidebar) {
                Image(systemName: "line.horizontal.3")
            }
        }
        #elseif os(iOS)
        ToolbarItem(placement: .topBarLeading) {
            Button(action: toggleSidebar) {
                Image(systemName: "line.horizontal.3")
            }
        }
        #endif
            
    }
    
    private var sidebarOverlay: some View {
        HStack {
            Sidebar(model: sidebarViewModel, showSidebar: $showSidebar)
                .frame(width: 250)
                .background(Color.white)
                .transition(.move(edge: .leading))
                .zIndex(10)
            Color.gray.opacity(0.3)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture { toggleSidebar() }
        }
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onEnded { value in
                if value.translation.width < -100 {
                    withAnimation {
                        showSidebar = false
                    }
                }
            }
    }
    
    private func toggleSidebar() {
        withAnimation {
            showSidebar.toggle()
        }
    }
}
