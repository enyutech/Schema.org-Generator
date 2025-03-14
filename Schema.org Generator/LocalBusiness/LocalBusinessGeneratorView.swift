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

        let address: Address? = schemaData.streetAddress.isEmpty ||
        schemaData.city.isEmpty ||
        schemaData.state.isEmpty ||
        schemaData.postalCode.isEmpty ||
        schemaData.country.isEmpty ? nil : Address(
            type: "PostalAddress",
            streetAddress: schemaData.streetAddress,
            addressLocality: schemaData.city,
            addressRegion: schemaData.state,
            postalCode: schemaData.postalCode,
            addressCountry: schemaData.country
        )

        let geo: GeoCoordinates? = (schemaData.geoLatitude == 0.0 && schemaData.geoLongitude == 0.0) ? nil : GeoCoordinates(
            type: "GeoCoordinates",
            latitude: schemaData.geoLatitude,
            longitude: schemaData.geoLongitude
        )

        let openingHoursSpecification: [OpeningHoursSpecification]? = schemaData.openingHours.isEmpty ? nil : schemaData.openingHours.map {
            $0.toOpeningHoursSpecification()
        }

        let departmentData: [Department]? = schemaData.departments.isEmpty ? nil : schemaData.departments.map { department in
            Department(
                type: department.type,
                name: department.name,
                image: department.image,
                telephone: department.telephone,
                openingHoursSpecification: department.openingHoursSpecification
            )
        }
        
        let businessType = (schemaData.selectedSpecificType?.isEmpty == false) ? schemaData.selectedSpecificType! : schemaData.businessType

        let businessSchema = LocalBusinessSchema(
            context: context,
            type: businessType,  // Use the more specific type if set
            name: schemaData.name,
            image: schemaData.imageUrl,
            id: schemaData.id,
            url: schemaData.url,
            telephone: schemaData.telephone,
            priceRange: schemaData.priceRange.isEmpty ? nil : schemaData.priceRange,
            address: address,
            geo: geo,
            openingHoursSpecification: openingHoursSpecification,
            sameAs: schemaData.socialProfiles.isEmpty || schemaData.socialProfiles.first?.isEmpty == true ? nil : schemaData.socialProfiles,
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
