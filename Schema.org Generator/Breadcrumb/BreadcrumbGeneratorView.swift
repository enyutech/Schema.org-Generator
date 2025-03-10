//
//  BreadcrumbGeneratorView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/10/25.
//

import SwiftUI
import AppKit

struct BreadcrumbGeneratorView: View {
    @StateObject private var schemaData = SchemaData()
    @State private var jsonOutput: String = ""
    @State private var showJsonOutput: Bool = false
    @State private var invalidURLs: [Bool] = [] // Track invalid URLs

    var body: some View {
        VStack {
            Text("Breadcrumb Schema Generator")
                .font(.headline)
                .padding()
                .foregroundColor(.primary)

            // Input Fields for Breadcrumb Items
            ForEach($schemaData.breadcrumbs.indices, id: \.self) { index in
                let binding = $schemaData.breadcrumbs[index]
                HStack {
                    Text("Page #\(index + 1)'s name")
                        .frame(width: 150, alignment: .trailing)
                    TextField("Page #\(index + 1)'s name", text: binding.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Text("URL #\(index + 1)")
                    TextField("URL #\(index + 1)", text: binding.item, onEditingChanged: { _ in
                        validateURL(index) // Validate as user types
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .border(index < invalidURLs.count ? (invalidURLs[index] ? Color.red : Color.clear) : Color.clear) // Red border if invalid

                    // Show warning if URL is invalid
                    if index < invalidURLs.count && invalidURLs[index] {
                        Text("Invalid URL")
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    // Remove button (only allowed if more than 2 breadcrumbs)
                    if schemaData.breadcrumbs.count > 2 {
                        Button(action: { removeBreadcrumb(at: index) }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
            .frame(width: 500)

            // Add URL Button (Cannot go below 2 items)
            Button(action: addBreadcrumb) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add URL")
                }
                .padding()
                .cornerRadius(8)
                .buttonStyle(.borderedProminent)
            }
            .padding(.top, 10)

            Divider()
            Spacer()

            // Generate JSON-LD and Copy Buttons
            HStack {
                Button("Generate JSON-LD") {
                    generateJsonLD()
                    showJsonOutput = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!isValidBreadcrumbInput()) // Disable if breadcrumbs are not valid

                Button("Copy") { copyToClipboard() }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .disabled(!isValidBreadcrumbInput()) // Disable if breadcrumbs are not valid
            }
            .padding()
        }
        .onAppear {
            if schemaData.breadcrumbs.isEmpty {
                schemaData.breadcrumbs = [
                    Breadcrumb(position: 1, name: "", item: ""),
                    Breadcrumb(position: 2, name: "", item: "")
                ]
            }

            // Ensure invalidURLs has the same count as breadcrumbs
            if invalidURLs.count != schemaData.breadcrumbs.count {
                invalidURLs = Array(repeating: false, count: schemaData.breadcrumbs.count)
            }
        }
        .sheet(isPresented: $showJsonOutput) {
            JsonOutputView(jsonOutput: $jsonOutput)
        }
    }

    // Function to add a breadcrumb entry
    private func addBreadcrumb() {
        let newPosition = schemaData.breadcrumbs.count + 1
        schemaData.breadcrumbs.append(Breadcrumb(position: newPosition, name: "", item: ""))
        invalidURLs.append(false) // Ensure this stays in sync
    }

    // Function to remove a breadcrumb entry (cannot remove below 2 items)
    private func removeBreadcrumb(at index: Int) {
        if schemaData.breadcrumbs.count > 2 {
            schemaData.breadcrumbs.remove(at: index)
            invalidURLs.remove(at: index) // Keep arrays aligned
            // Recalculate positions
            for i in 0..<schemaData.breadcrumbs.count {
                schemaData.breadcrumbs[i].position = i + 1
            }
        }
    }

    // Function to validate URLs and update the invalidURLs array
    private func validateURL(_ index: Int) {
        if index < invalidURLs.count {
            invalidURLs[index] = !isValidURL(schemaData.breadcrumbs[index].item)
        }
    }

    // Function to generate JSON-LD output
    private func generateJsonLD() {
        let breadcrumbList: [String: Any] = [
            "@context": "https://schema.org/",
            "@type": "BreadcrumbList",
            "itemListElement": schemaData.breadcrumbs.map { breadcrumb in
                [
                    "@type": "ListItem",
                    "position": breadcrumb.position,
                    "name": breadcrumb.name,
                    "item": breadcrumb.item
                ]
            }
        ]

        if let jsonData = try? JSONSerialization.data(withJSONObject: breadcrumbList, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            jsonOutput = """
            <script type="application/ld+json">
            \(jsonString)
            </script>
            """
        }
    }

    // Function to copy JSON-LD to clipboard
    private func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(jsonOutput, forType: .string)
    }
    
    // Function to check if the first two breadcrumbs are filled with valid URLs
    private func isValidBreadcrumbInput() -> Bool {
        return schemaData.breadcrumbs.count >= 2 &&
               invalidURLs.count >= 2 &&
               isValidURL(schemaData.breadcrumbs[0].item) &&
               isValidURL(schemaData.breadcrumbs[1].item) &&
               !schemaData.breadcrumbs[0].name.trimmingCharacters(in: .whitespaces).isEmpty &&
               !schemaData.breadcrumbs[1].name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // Function to validate if a string is a valid URL
    private func isValidURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return url.scheme == "http" || url.scheme == "https"
    }
}
