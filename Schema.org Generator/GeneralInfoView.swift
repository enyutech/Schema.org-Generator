//
//  GeneralInfoView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/5/25.
//

import SwiftUICore
import SwiftUI

struct GeneralInfoView: View {
    @ObservedObject var schemaData: SchemaData

    var body: some View {
        Form {
            Section(header: Text("Business Information")) {
                TextField("Business Name", text: $schemaData.name)
                TextField("Website URL", text: $schemaData.url)
                TextField("Description", text: $schemaData.description)
                TextField("Disambiguating Description", text: $schemaData.disambiguatingDescription)
                TextField("Slogan", text: $schemaData.slogan)
            }
        }
    }
}
