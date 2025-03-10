//
//  ContentView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/5/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedGenerator: String? = "Welcome" // Default selection

    var body: some View {
        NavigationSplitView {
            SidebarView(selectedGenerator: $selectedGenerator) // Sidebar Menu
        } detail: {
            switch selectedGenerator {
            case "Welcome":
                WelcomeView()
            case "Local Business":
                LocalBusinessGeneratorView()
            case "FAQ":
                FAQGeneratorView()
            case "Website":
                WebsiteGeneratorView()
            case "Person":
                PersonGeneratorView()
            default:
                Text("Select a generator from the sidebar")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    ContentView()
}
