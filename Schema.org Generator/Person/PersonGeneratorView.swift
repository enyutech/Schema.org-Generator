//
//  PersonGeneratorView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/10/25.
//


import SwiftUI
import AppKit

struct PersonGeneratorView: View {
    @StateObject private var schemaData = SchemaData()
    @State private var jsonOutput: String = ""
    @State private var showJsonOutput: Bool = false

    var body: some View {
        VStack {
            Text("Person Schema Generator")
                .font(.headline)
                .padding()
                .foregroundColor(.primary)

            Grid {
                GridRow {
                    Text("Name:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("Full Name", text: $schemaData.personName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                GridRow {
                    Text("URL:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("https://example.com", text: $schemaData.personUrl)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                GridRow {
                    Text("Picture URL:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("Image URL", text: $schemaData.personImageUrl)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                GridRow {
                    Text("Job Title:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("Job Title", text: $schemaData.personJobTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                GridRow {
                    Text("Company:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("Company Name", text: $schemaData.personCompany)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .frame(width: 500)
            .padding()

            Divider()
            .padding(.vertical, 10)

            OnlinePresenceView(socialProfiles: $schemaData.personSocialProfiles)
            
            Divider()
                .padding(.vertical, 10)
            
            KnowsAboutView(knowsAbout: $schemaData.personKnowsAbout)

            // Generate JSON-LD Button
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
            .padding()
        }
        .sheet(isPresented: $showJsonOutput) {
            JsonOutputView(jsonOutput: $jsonOutput)
        }
    }

    private func generateJsonLD() {
        var personSchema: [String: Any] = [
            "@context": "https://schema.org",
            "@type": "Person",
            "name": schemaData.personName,
            "url": schemaData.personUrl,
            "image": schemaData.personImageUrl,
        ]
        
        if !schemaData.personCompany.trimmingCharacters(in: .whitespaces).isEmpty {
            personSchema["worksFor"] = [
                "@type": "Organization",
                "name": schemaData.personCompany
            ]
        }
        
        if !schemaData.personKnowsAbout.isEmpty {
            personSchema["knowsAbout"] = schemaData.personKnowsAbout
        }
        
        if !schemaData.personJobTitle.trimmingCharacters(in: .whitespaces).isEmpty {
            personSchema["jobTitle"] = schemaData.personJobTitle
        }

        // Include "sameAs" only if social profiles are available
        if !schemaData.personSocialProfiles.isEmpty {
            personSchema["sameAs"] = schemaData.personSocialProfiles
        }

        if let jsonData = try? JSONSerialization.data(withJSONObject: personSchema, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            jsonOutput = """
            <script type="application/ld+json">
            \(jsonString)
            </script>
            """
        }
    }

    private func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(jsonOutput, forType: .string)
    }
}
