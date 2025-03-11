//
//  GeneralInfoView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/5/25.
//

import SwiftUI

struct GeneralInfoView: View {
    @ObservedObject var schemaData: SchemaData
    var isOrgGeneratorView = false
    @State private var selectedSpecificType: String = ""

    var body: some View {
        VStack() {
        
            Text("Business Information")
                .font(.headline)
                .padding(.bottom, 5)

            Grid {
                GridRow {
                    Picker("Business Type (@type):", selection: $schemaData.businessType) {
                        ForEach(schemaData.businessTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: 515)
                    .onChange(of: schemaData.businessType) { _ in
                        schemaData.selectedSpecificType = nil
                    }
                }

                // More Specific @type Picker (Only Show When Needed)
                if !(schemaData.specificBusinessTypes[schemaData.businessType] ?? []).isEmpty {
                    GridRow {
                        Picker("More Specific @type:", selection: Binding(
                            get: { schemaData.selectedSpecificType ?? "" },
                            set: { schemaData.selectedSpecificType = $0.isEmpty ? nil : $0 }
                        )) {
                            ForEach(schemaData.specificBusinessTypes[schemaData.businessType] ?? [], id: \.self) { specificType in
                                Text(specificType).tag(specificType)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: 515)
                    }
                }
            }
            
            Grid {
                GridRow {
                    Text("Business Name:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("Enter business name", text: $schemaData.name)
                        .textFieldStyle(.roundedBorder)
                }
                
                GridRow {
                    Text("Website URL:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("https://example.com", text: $schemaData.url)
                        .textFieldStyle(.roundedBorder)
                }
                
                GridRow {
                    Text("@id (URL):")
                        .frame(width: 150, alignment: .trailing)
                    TextField("https://example.com", text: $schemaData.id)
                        .textFieldStyle(.roundedBorder)
                }
                
                GridRow {
                    Text("Description:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("Enter a brief description", text: $schemaData.description)
                        .textFieldStyle(.roundedBorder)
                }
                
                GridRow {
                    Text("Disambiguating Description:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("Further clarify the business", text: $schemaData.disambiguatingDescription)
                        .textFieldStyle(.roundedBorder)
                }
                
                GridRow {
                    Text("Slogan:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("Enter a slogan", text: $schemaData.slogan)
                        .textFieldStyle(.roundedBorder)
                }
                
                if !isOrgGeneratorView {
                    GridRow {
                        Text("Price Range:")
                            .frame(width: 150, alignment: .trailing)
                        Picker("", selection: $schemaData.priceRange) {
                            ForEach(["$", "$$", "$$$", "$$$$", "$$$$$"], id: \.self) { price in
                                Text(price).tag(price)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 250)
                    }
                }
                
            }
            .frame(maxWidth: 500)
            .padding()
        }
        .padding()
    }
    
    // Extracted into computed property
    private var businessTypeOptions: some View {
        ForEach(schemaData.businessTypes, id: \.self) { type in
            Text(type).tag(type)
        }
    }

    // Extracted specific type options into computed property
    private var specificTypeOptions: some View {
        ForEach(schemaData.specificBusinessTypes[schemaData.businessType] ?? [], id: \.self) { specificType in
            Text(specificType).tag(specificType)
        }
    }
}
