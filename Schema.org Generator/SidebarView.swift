//
//  SidebarView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/6/25.
//


import SwiftUI

struct SidebarView: View {
    @Binding var selectedGenerator: String?

    var body: some View {
        List(selection: $selectedGenerator) {
            Section(header: Text("Generators")) {
                Label("Website", systemImage: "globe")
                    .tag("Website")
                Label("Local Business", systemImage: "mappin.and.ellipse")
                    .tag("Local Business")
                Label("Person", systemImage: "person.circle")
                    .tag("Person")
                Label("FAQ", systemImage: "questionmark.circle")
                    .tag("FAQ")
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Tools")
    }
}
