//
//  LocalBusinessGeneratorView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/7/25.
//

import SwiftUI
import AppKit // Required for clipboard functionality

struct LocalBusinessGeneratorView: View {
    @State private var showJsonOutput = false
    @State private var jsonOutput: String = ""
//    @State private var openingHours: [OperatingHour] = []
    @ObservedObject var schemaData = SchemaData() // Shared data object

    var body: some View {
        VStack {
            Text ("Local Business Schema Generator")
                .font(.headline)
                .padding()
                .foregroundColor(.primary)
            
            TabView {
                GeneralInfoView(schemaData: schemaData, isOrgGeneratorView: false)
                    .tabItem { Label("General Info", systemImage: "info.circle") }
                
                AddressView(schemaData: schemaData)
                    .tabItem { Label("Address", systemImage: "map") }
                
                OnlinePresenceView(socialProfiles: $schemaData.socialProfiles)
                    .tabItem { Label("Online Presence", systemImage: "network") }
                
                OperatingHoursView(openingHours: $schemaData.openingHours)
                    .tabItem { Label("Hours", systemImage: "clock") }

                DepartmentView(departments: $schemaData.departments)
                    .tabItem { Label("Departments", systemImage: "building.2") }
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
            }
            .padding()
        }
        .sheet(isPresented: $showJsonOutput) {
            JsonOutputView(jsonOutput: $jsonOutput)
        }
    }

    /// Generates JSON-LD dynamically for LocalBusiness
    private func generateJsonLD() {
        let context = "https://schema.org"

        let address = Address(
            type: "PostalAddress",
            streetAddress: schemaData.streetAddress,
            addressLocality: schemaData.city,
            addressRegion: schemaData.state,
            postalCode: schemaData.postalCode,
            addressCountry: schemaData.country
        )

        let geo = GeoCoordinates(
            type: "GeoCoordinates",
            latitude: schemaData.geoLatitude,
            longitude: schemaData.geoLongitude
        )

        let openingHoursSpecification = schemaData.openingHours.isEmpty ? [] : schemaData.openingHours.map { $0.toOpeningHoursSpecification() }

        let departmentData = schemaData.departments.map { department in
            Department(
                type: department.type,
                name: department.name,
                image: department.image,
                telephone: department.telephone,
                openingHoursSpecification: department.openingHoursSpecification
            )
        }
        
        let businessSchema = LocalBusinessSchema(
            context: context,
            type: schemaData.businessType,
            name: schemaData.name,
            image: schemaData.imageUrl,
            id: schemaData.id,
            url: schemaData.url,
            telephone: schemaData.telephone,
            priceRange: schemaData.priceRange,
            address: address, // Fix applied here
            geo: geo,
            openingHoursSpecification: openingHoursSpecification, // Fix applied here
            sameAs: schemaData.socialProfiles,
            department: departmentData
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        if let jsonData = try? encoder.encode(businessSchema),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            jsonOutput = """
            <script type=\"application/ld+json\">
            \(jsonString)
            </script>
            """
        } else {
            jsonOutput = """
            <script type=\"application/ld+json\">
            {}
            </script>
            """
        }
    }

    /// Copies JSON output to clipboard
    private func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(jsonOutput, forType: .string)
    }
}
