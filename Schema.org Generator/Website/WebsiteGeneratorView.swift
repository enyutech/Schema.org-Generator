//
//  WebsiteGeneratorView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/10/25.
//


import SwiftUI
import AppKit

struct WebsiteGeneratorView: View {
    @ObservedObject var schemaData = SchemaData()
    @State private var showJsonOutput = false
    @State private var jsonOutput: String = ""

    var body: some View {
        VStack {
            Text("Website Schema Generator")
                .font(.headline)
                .padding()
                .foregroundColor(.primary)

            Grid() {
                GridRow {
                    Text("Website's name:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("Website Name", text: $schemaData.websiteSchema.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                GridRow {
                    Text("URL:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("URL", text: $schemaData.websiteSchema.url)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                GridRow {
                    Text("Internal site search URL:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("e.g. https://example.com/search?q=", text: $schemaData.websiteSchema.searchUrl)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                GridRow {
                    Text("Optional query string:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("Optional string after query", text: $schemaData.websiteSchema.queryParam)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .frame(maxWidth: 500)
            
            Spacer()

            HStack {
                Button("Generate JSON-LD") {
                    generateJsonLD()
                    showJsonOutput = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button("Copy") { copyToClipboard() }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
        }
        .sheet(isPresented: $showJsonOutput) {
            JsonOutputView(jsonOutput: $jsonOutput)
        }
    }

    private func generateJsonLD() {
        let websiteSchema: [String: Any] = [
            "@context": "https://schema.org",
            "@type": "WebSite",
            "name": schemaData.websiteSchema.name,
            "url": schemaData.websiteSchema.url,
            "potentialAction": [
                "@type": "SearchAction",
                "target": "\(schemaData.websiteSchema.searchUrl){query}",
                "query-input": "required name=query"
            ]
        ]

        if let jsonData = try? JSONSerialization.data(withJSONObject: websiteSchema, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            jsonOutput = """
            <script type="application/ld+json">
            \(jsonString)
            </script>
            """
            showJsonOutput = true
        }
    }
    
    private func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(jsonOutput, forType: .string)
    }
}
