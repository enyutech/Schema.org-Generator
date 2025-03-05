//
//  AddressView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/5/25.
//

import SwiftUICore
import SwiftUI


struct AddressView: View {
    @ObservedObject var schemaData: SchemaData

    var body: some View {
        Form {
            Section(header: Text("Address")) {
                TextField("Street Address", text: $schemaData.streetAddress)
                TextField("City", text: $schemaData.city)
                TextField("State", text: $schemaData.state)
                TextField("Postal Code", text: $schemaData.postalCode)
                TextField("Country", text: $schemaData.country)
            }
        }
    }
}
