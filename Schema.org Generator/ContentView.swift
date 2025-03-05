//
//  ContentView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/5/25.
//

import SwiftUI
import AppKit // Required for clipboard functionality

struct ContentView: View {
    @State private var showJsonOutput = false
    @State private var jsonOutput: String = ""
    @ObservedObject var schemaData = SchemaData() // Shared data object

    var body: some View {
        VStack {
            TabView {
                GeneralInfoView(schemaData: schemaData)
                    .tabItem { Label("General Info", systemImage: "info.circle") }

                AddressView(schemaData: schemaData)
                    .tabItem { Label("Address", systemImage: "map") }

                OnlinePresenceView(socialProfiles: $schemaData.socialProfiles)
                    .tabItem { Label("Online Presence", systemImage: "network") }

                LegalExpertiseView(knowsAbout: $schemaData.knowsAbout)
                    .tabItem { Label("Legal Expertise", systemImage: "briefcase") }

                FounderView(
                    founderName: $schemaData.founderName,
                    founderUrl: $schemaData.founderUrl,
                    founderDescription: $schemaData.founderDescription,
                    founderDisambiguatingDescription: $schemaData.founderDisambiguatingDescription,
                    founderImage: $schemaData.founderImage,
                    founderTelephone: $schemaData.founderTelephone,
                    founderKnowsAbout: $schemaData.founderKnowsAbout,
                    founderKnowsLanguage: $schemaData.founderKnowsLanguage,
                    founderNationality: $schemaData.founderNationality,
                    founderGender: $schemaData.founderGender,
                    founderWorkLocation: $schemaData.founderWorkLocation,
                    founderJobTitle: $schemaData.founderJobTitle
                )
                .tabItem { Label("Founder", systemImage: "person.fill") }
            }
            .frame(minWidth: 500, minHeight: 400)

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

                Button("Save") { saveJsonFile() }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
            }
            .padding()
        }
        .sheet(isPresented: $showJsonOutput) {
            JsonOutputView(jsonOutput: $jsonOutput)
        }
    }

    /// Generates the JSON-LD dynamically from user input with ordered keys
    /// Generates the JSON-LD dynamically from user input with ordered keys
    private func generateJsonLD() {
        let context = "https://schema.org"

        // Address Component (Ordered)
        let address: [String: Any] = [
            "@type": "PostalAddress",
            "streetAddress": schemaData.streetAddress,
            "addressLocality": schemaData.city,
            "addressRegion": schemaData.state,
            "postalCode": schemaData.postalCode,
            "addressCountry": schemaData.country
        ]

        // Founder Component (Ordered)
        let founder: [String: Any] = [
            "@type": "Person",
            "@id": (schemaData.founderUrl) + "#founder",
            "name": schemaData.founderName,
            "url": schemaData.founderUrl,
            "description": schemaData.founderDescription,
            "disambiguatingDescription": schemaData.founderDisambiguatingDescription,
            "image": schemaData.founderImage,
            "telephone": schemaData.founderTelephone,
            "knowsLanguage": schemaData.founderKnowsLanguage,
            "knowsAbout": schemaData.founderKnowsAbout.split(separator: ",").map { $0.trimmingCharacters(in: CharacterSet.whitespaces) },
            "nationality": schemaData.founderNationality,
            "gender": schemaData.founderGender,
            "workLocation": schemaData.founderWorkLocation,
            "jobTitle": schemaData.founderJobTitle
        ]

        // Aggregate Rating (Ordered)
        let aggregateRating: [String: Any] = [
            "@type": "AggregateRating",
            "ratingValue": schemaData.aggregateRating.isEmpty == false ? schemaData.aggregateRating : "4.9",
            "reviewCount": schemaData.reviewCount.isEmpty == false ? schemaData.reviewCount : "150"
        ]

        // Brand Component (Ordered)
        let brand: [String: Any] = [
            "@type": "Brand",
            "@id": (schemaData.url) + "#brand",
            "name": schemaData.name,
            "alternateName": schemaData.socialProfiles.split(separator: ",").map { $0.trimmingCharacters(in: CharacterSet.whitespaces) },
            "url": schemaData.url,
            "logo": schemaData.imageUrl
        ]

        // Contact Point (Ordered)
        let contactPoint: [String: Any] = [
            "@type": "ContactPoint",
            "telephone": schemaData.telephone,
            "contactType": "Customer Service"
        ]

        // Area Served (Ordered)
        let areaServed: [String: Any] = [
            "@type": "City",
            "name": schemaData.city,
            "description": "Legal services provided in \(schemaData.city) and surrounding areas."
        ]

        // Legal Services Catalog (Ordered)
        let offerCatalogItems = schemaData.knowsAbout.split(separator: ",").map { expertise in
            let formattedExpertise = expertise.lowercased().trimmingCharacters(in: CharacterSet.whitespaces).replacingOccurrences(of: " ", with: "-")
            return [
                "@type": "Offer",
                "itemOffered": [
                    "@type": "Service",
                    "@id": "\(schemaData.url)/practice-areas/\(formattedExpertise)#service",
                    "url": "\(schemaData.url)/practice-areas/\(formattedExpertise)",
                    "name": expertise,
                    "description": "\(schemaData.name) provides expert legal representation for \(expertise) cases."
                ]
            ]
        }

        let hasOfferCatalog: [String: Any] = [
            "@id": (schemaData.url) + "#services",
            "name": "Legal Services Catalog",
            "url": schemaData.url,
            "itemListElement": offerCatalogItems
        ]

        // Main Schema Object (Ordered to match original)
        let graph: [String: Any] = [
            "@type": "LegalService",
            "@id": (schemaData.url) + "#organization",
            "name": schemaData.name,
            "alternateName": schemaData.socialProfiles.split(separator: ",").map { $0.trimmingCharacters(in: CharacterSet.whitespaces) },
            "url": schemaData.url,
            "description": schemaData.description,
            "disambiguatingDescription": schemaData.disambiguatingDescription,
            "sameAs": schemaData.socialProfiles.split(separator: ",").map { $0.trimmingCharacters(in: CharacterSet.whitespaces) },
            "image": schemaData.imageUrl,
            "telephone": schemaData.telephone,
            "openingHours": schemaData.openingHours,
            "address": address,
            "paymentAccepted": schemaData.paymentAccepted,
            "priceRange": schemaData.priceRange,
            "knowsAbout": schemaData.knowsAbout.split(separator: ",").map { $0.trimmingCharacters(in: CharacterSet.whitespaces) },
            "slogan": schemaData.slogan,
            "aggregateRating": aggregateRating,
            "brand": brand,
            "logo": schemaData.imageUrl,
            "contactPoint": contactPoint,
            "areaServed": areaServed,
            "foundingDate": schemaData.foundingDate,
            "founder": founder,
            "hasOfferCatalog": hasOfferCatalog
        ]

        let schema: [String: Any] = ["@context": context, "@graph": [graph]]

        jsonOutput = (try? JSONSerialization.data(withJSONObject: schema, options: .prettyPrinted))
            .map { String(data: $0, encoding: .utf8) ?? "" } ?? ""
    }

    /// Copies JSON output to clipboard
    private func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(jsonOutput, forType: .string)
    }

    /// Saves JSON output to a file
    private func saveJsonFile() {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.json]
        savePanel.nameFieldStringValue = "schema"

        if savePanel.runModal() == .OK, let url = savePanel.url {
            do {
                try jsonOutput.write(to: url, atomically: true, encoding: .utf8)
            } catch {
                print("Error saving file: \(error)")
            }
        }
    }
}
