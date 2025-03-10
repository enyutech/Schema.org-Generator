//
//  AddressView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/5/25.
//

import SwiftUI
import CoreLocation

struct AddressView: View {
    @ObservedObject var schemaData: SchemaData
    private let geocoder = CLGeocoder() // Geocoding instance

    var body: some View {
        VStack {
            Text("Business Address")
                .font(.headline)
                .padding(.bottom, 5)

            Grid {
                GridRow {
                    Text("Street Address:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("Enter street address", text: $schemaData.streetAddress)
                        .textFieldStyle(.roundedBorder)
                }

                GridRow {
                    Text("City:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("Enter city", text: $schemaData.city)
                        .textFieldStyle(.roundedBorder)
                }

                GridRow {
                    Text("State/Province:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("Enter state", text: $schemaData.state)
                        .textFieldStyle(.roundedBorder)
                }

                GridRow {
                    Text("Postal Code:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("Enter postal code", text: $schemaData.postalCode)
                        .textFieldStyle(.roundedBorder)
                }

                GridRow {
                    Text("Country:")
                        .frame(width: 150, alignment: .trailing)
                    TextField("Enter country", text: $schemaData.country)
                        .textFieldStyle(.roundedBorder)
                }
            }
            .frame(maxWidth: 500)
            .padding()

            Divider()

            // GEO Coordinates Section
            VStack {
                Text("Geo Coordinates")
                    .font(.headline)
                
                Grid {
                    GridRow {
                        Text("Latitude:")
                            .frame(width: 150, alignment: .trailing)
                        TextField("Enter latitude", text: Binding(
                            get: { String(schemaData.geoLatitude) }, // Convert Double to String
                            set: { schemaData.geoLatitude = Double($0) ?? 0.0 } // Convert back to Double
                        ))
                        .textFieldStyle(.roundedBorder)
                    }

                    GridRow {
                        Text("Longitude:")
                            .frame(width: 150, alignment: .trailing)
                        TextField("Enter longitude", text: Binding(
                            get: { String(schemaData.geoLongitude) }, // Convert Double to String
                            set: { schemaData.geoLongitude = Double($0) ?? 0.0 } // Convert back to Double
                        ))
                        .textFieldStyle(.roundedBorder)
                    }
                }
                .frame(maxWidth: 500)
                .padding()

                Button("Get Coordinates") {
                    fetchCoordinates()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding(.top, 10)
        }
        .padding()
    }

    /// Uses Core Location's CLGeocoder to convert the entered address into latitude and longitude.
    private func fetchCoordinates() {
        let fullAddress = "\(schemaData.streetAddress), \(schemaData.city), \(schemaData.state), \(schemaData.postalCode), \(schemaData.country)"
        
        geocoder.geocodeAddressString(fullAddress) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }

            if let location = placemarks?.first?.location {
                schemaData.geoLatitude = location.coordinate.latitude
                schemaData.geoLongitude = location.coordinate.longitude
                print("Coordinates found: \(schemaData.geoLatitude), \(schemaData.geoLongitude)")
            } else {
                print("No coordinates found for this address.")
            }
        }
    }
}
