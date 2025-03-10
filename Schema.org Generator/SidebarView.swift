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
                Label("Article", systemImage: "richtext.page")
                    .tag("Article")
                Label("Breadcrumb", systemImage: "arrowshape.left.arrowshape.right")
                    .tag("Breadcrumb")
                Label("FAQ", systemImage: "questionmark.circle")
                    .tag("FAQ")
                Label("Local Business", systemImage: "mappin.and.ellipse")
                    .tag("Local Business")
                Label("Person", systemImage: "person.circle")
                    .tag("Person")
                Label("Website", systemImage: "globe")
                    .tag("Website")
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Tools")
    }
}
